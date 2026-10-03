pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property var devices: []

	property string section: ""
	property var connectedMap: ({})
	property var pairedMap: ({})

	function refresh() {
		if (!listProc.running)
			listProc.running = true
	}

	Process {
		id: listProc
		command: ["bash", "-c",
			"echo --connected--; bluetoothctl devices Connected; " +
			"echo --paired--; bluetoothctl devices Paired"
		]

		stdout: SplitParser {
			onRead: data => {
				const line = data.trim()
				if (line === "--connected--") {
					root.section = "connected"
					return
				}
				if (line === "--paired--") {
					root.section = "paired"
					return
				}
				if (!line.startsWith("Device "))
					return

				const parts = line.split(" ")
				const address = parts[1]
				const name = parts.slice(2).join(" ")

				if (root.section === "connected")
					root.connectedMap[address] = name
				else if (!(address in root.connectedMap))
					root.pairedMap[address] = name
			}
		}

		onExited: {
			const list = []

			for (const address of Object.keys(root.connectedMap))
				list.push({ address: address, name: root.connectedMap[address], connected: true })

			for (const address of Object.keys(root.pairedMap))
				list.push({ address: address, name: root.pairedMap[address], connected: false })

			root.devices = list
			root.connectedMap = {}
			root.pairedMap = {}
		}
	}

	Process {
		id: toggleProc

		property string action: "connect"
		property string address: ""
		command: ["bluetoothctl", action, address]
	}

	Timer {
		id: refreshDelay
		interval: 800
		onTriggered: root.refresh()
	}

	function toggle(device) {
		toggleProc.action = device.connected ? "disconnect" : "connect"
		toggleProc.address = device.address
		toggleProc.startDetached()
		refreshDelay.restart()
	}
}
