import QtQuick
import Quickshell
import Quickshell.Io

// iwd + systemd-networkd stand-in for Quickshell.Networking, which only
// speaks NetworkManager. State comes from `desktop-network-iwd snapshot`,
// refreshed whenever `desktop-network-iwd monitor` reports a D-Bus change and
// on a slow poll while the panel is open. Devices and networks are plain JS
// objects, replaced wholesale on every snapshot so bindings re-evaluate:
//
//   device:  { path, type: "wifi" | "ethernet", name, powered, state,
//              scanning, connected, connectedNetwork, networks: [network] }
//   network: { path, knownPath, devicePath, name, security, connected,
//              known, signalStrength (0..1), stateChanging }
//
// Actions take a callback that receives "" on success or a reason from
// `reasons` on failure, so the panel can reuse its NetworkManager-era
// failure text.
Item {
  id: backend

  // The panel sets this while it is open; it only drives the poll.
  property bool active: false

  property var snapshot: ({ available: false, wifiEnabled: false, devices: [] })
  readonly property bool available: snapshot.available === true
  readonly property bool wifiEnabled: snapshot.wifiEnabled === true
  readonly property var devices: snapshot.devices || []

  // Same names the panel used for Quickshell's ConnectionFailReason values.
  readonly property var reasons: ({
    NoSecrets: "NoSecrets",
    WifiAuthTimeout: "WifiAuthTimeout",
    WifiNetworkLost: "WifiNetworkLost",
    WifiClientDisconnected: "WifiClientDisconnected",
    WifiClientFailed: "WifiClientFailed"
  })

  property bool refreshQueued: false

  function refresh() {
    if (snapshotProc.running) refreshQueued = true
    else snapshotProc.running = true
  }

  function parseSnapshot(raw) {
    var next
    try {
      next = JSON.parse(String(raw || ""))
    } catch (error) {
      return
    }
    var devices = Array.isArray(next.devices) ? next.devices : []
    for (var i = 0; i < devices.length; i++) {
      var device = devices[i]
      var transitional = ["connecting", "disconnecting", "roaming"].indexOf(device.state) !== -1
      var networks = Array.isArray(device.networks) ? device.networks : []
      var mapped = []
      for (var j = 0; j < networks.length; j++) {
        var net = networks[j]
        mapped.push({
          path: net.path || "",
          knownPath: net.knownPath || "",
          devicePath: device.path || "",
          name: net.name || "",
          security: net.security || "",
          connected: !!net.connected,
          known: !!net.known,
          signalStrength: Number(net.signal) || 0,
          stateChanging: transitional
        })
      }
      device.networks = mapped
    }
    snapshot = { available: !!next.available, wifiEnabled: !!next.wifiEnabled, devices: devices }
  }

  // iwd's error names, mapped onto the reasons the panel words.
  function reasonFor(error, security) {
    var name = String(error || "").trim().split("\n")[0]
    if (name === "Aborted" || name === "Canceled" || name === "NoAgent") return reasons.NoSecrets
    if (name === "Failed" || name === "InvalidFormat")
      return security === "psk" || security === "wep" ? reasons.WifiAuthTimeout : reasons.WifiClientFailed
    if (name === "NotFound" || name === "NotAvailable") return reasons.WifiNetworkLost
    if (name === "Busy" || name === "InProgress" || name === "AlreadyConnected") return reasons.WifiClientFailed
    return name
  }

  function scan(device) {
    if (!device || !device.path || scanProc.running) return
    scanProc.command = ["desktop-network-iwd", "scan", device.path]
    scanProc.running = true
  }

  function setWifiEnabled(enabled) {
    if (powerProc.running) return
    var paths = []
    for (var i = 0; i < devices.length; i++) {
      if (devices[i].type === "wifi" && devices[i].path) paths.push(devices[i].path)
    }
    if (paths.length === 0) return
    powerProc.command = ["bash", "-c",
      "state=$1; shift; for path; do desktop-network-iwd power \"$path\" \"$state\" || exit; done",
      "desktop-network-power", enabled ? "on" : "off"].concat(paths)
    powerProc.running = true
  }

  // A passphrase travels on stdin, never in argv.
  function connect(network, passphrase, callback) {
    var args = ["desktop-network-iwd", "connect", network.path]
    if (passphrase) args.push("--passphrase-stdin")
    runAction(args, passphrase || "", network.security, callback)
  }

  function disconnect(network, callback) {
    runAction(["desktop-network-iwd", "disconnect", network.devicePath], "", network.security, callback)
  }

  function forget(network, callback) {
    runAction(["desktop-network-iwd", "forget", network.knownPath], "", network.security, callback)
  }

  function runAction(command, secret, security, callback) {
    if (actionProc.running) {
      if (callback) callback(reasons.WifiClientFailed)
      return
    }
    actionProc.callback = callback || null
    actionProc.security = security || ""
    actionProc.secret = secret
    actionProc.command = command
    actionProc.running = true
  }

  Component.onCompleted: refresh()

  Process {
    id: snapshotProc
    command: ["desktop-network-iwd", "snapshot"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: backend.parseSnapshot(text)
    }
    onExited: {
      if (backend.refreshQueued) {
        backend.refreshQueued = false
        Qt.callLater(backend.refresh)
      }
    }
  }

  // Coalesce bursts of monitor lines (a scan emits many) into one snapshot.
  Timer {
    id: changeDebounce
    interval: 250
    onTriggered: backend.refresh()
  }

  Process {
    id: monitorProc
    command: ["desktop-network-iwd", "monitor"]
    running: true
    stdout: SplitParser {
      onRead: changeDebounce.restart()
    }
    // iwd going away ends the stream; try again in a while.
    onExited: monitorRestart.start()
  }

  Timer {
    id: monitorRestart
    interval: 5000
    onTriggered: {
      monitorProc.running = true
      backend.refresh()
    }
  }

  Timer {
    interval: 4000
    repeat: true
    running: backend.active
    onTriggered: backend.refresh()
  }

  Process {
    id: scanProc
    onExited: backend.refresh()
  }

  Process {
    id: powerProc
    onExited: backend.refresh()
  }

  Process {
    id: actionProc
    property var callback: null
    property string security: ""
    property string secret: ""
    // The exit code and the error name on stdout can land in either order;
    // report once both are in.
    property int exitCode: -1
    property bool streamDone: false
    property string output: ""
    stdinEnabled: true
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        actionProc.output = text
        actionProc.streamDone = true
        actionProc.finish()
      }
    }
    onStarted: {
      exitCode = -1
      streamDone = false
      output = ""
      if (secret !== "") write(secret + "\n")
      secret = ""
    }
    onExited: function(code) {
      actionProc.exitCode = code
      actionProc.finish()
    }

    function finish() {
      if (exitCode < 0 || !streamDone) return
      var done = callback
      callback = null
      backend.refresh()
      if (done) done(exitCode === 0 ? "" : backend.reasonFor(output, security))
    }
  }
}
