pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property var sinks: []
	property string defaultSink: ""
	property real volume: 100

	readonly property string statePath:
		(Quickshell.env("XDG_STATE_HOME") || Quickshell.env("HOME") + "/.local/state")
		+ "/qs-audio-volume"

	function refresh() {
		if (!listProc.running)
			listProc.running = true
		if (!volumeProc.running)
			volumeProc.running = true
	}

	Process {
		id: listProc
		command: ["bash", "-c",
			"printf '{\"default\":\"%s\",\"sinks\":%s}' " +
			"\"$(pactl get-default-sink)\" \"$(pactl -f json list sinks)\""
		]

		stdout: SplitParser {
			onRead: data => {
				try {
					const doc = JSON.parse(data)
					root.defaultSink = doc.default
					root.sinks = doc.sinks.map(s => ({
						name: s.name,
						description: s.description
					}))
				} catch (e) {
				}
			}
		}
	}

	Process {
		id: volumeProc

		command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]

		stdout: SplitParser {
			onRead: data => {
				const match = data.match(/(\d+)%/)
				if (match)
					root.volume = parseInt(match[1])
			}
		}
	}

	Process {
		id: restoreProc

		running: true
		command: ["bash", "-c",
			"v=$(cat '" + root.statePath + "' 2>/dev/null) || exit 0; " +
			"case \\\"$v\\\" in ''|*[!0-9]*) exit 0;; esac; " +
			"[ \\\"$v\\\" -le 100 ] || exit 0; " +
			"for i in $(seq 1 20); do " +
			"pactl set-sink-volume @DEFAULT_SINK@ \\\"$v%\\\" 2>/dev/null && break; " +
			"sleep 0.5; " +
			"done; " +
			"pactl get-sink-volume @DEFAULT_SINK@"
		]

		stdout: SplitParser {
			onRead: data => {
				const match = data.match(/(\d+)%/)
				if (match)
					root.volume = parseInt(match[1])
			}
		}
	}

	Process {
		id: applyProc

		property string percent: ""

		command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", percent + "%"]
	}

	Process {
		id: saveProc

		property string percent: ""

		command: ["bash", "-c",
			"mkdir -p \"$(dirname '" + root.statePath + "')\" && " +
			"printf '%s' '" + percent + "' > '" + root.statePath + "'"
		]
	}

	Process {
		id: switchProc

		property string target: ""
		command: ["pactl", "set-default-sink", target]
	}

	Timer {
		id: refreshDelay
		interval: 300
		onTriggered: root.refresh()
	}

	function setDefault(name) {
		switchProc.target = name
		switchProc.startDetached()
		refreshDelay.restart()
	}

	function setVolume(value) {
		const v = Math.max(0, Math.min(100, Math.round(value)))
		root.volume = v
		applyProc.percent = String(v)
		applyProc.startDetached()
		saveProc.percent = String(v)
		saveProc.startDetached()
	}
}
