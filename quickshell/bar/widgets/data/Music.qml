pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root

	property bool playing: false
	property bool active: false
	property string audioDevice: ""
	property bool visualiserEnabled: true

	property string tagTitle: ""
	property string fileTitle: ""
	property string artist: ""
	property var bars: []

	readonly property string title: tagTitle !== "" ? tagTitle : (fileTitle !== "" ? fileTitle : "No music playing :(")

	readonly property string sockPath: Quickshell.env("XDG_RUNTIME_DIR") + "/qs-music.sock"
	readonly property string musicDir: Quickshell.env("HOME") + "/music"
	readonly property string cavaConfig: Quickshell.env("HOME") + "/.config/cava/cava.conf"
	readonly property int barCount: 24

	Process {
		id: player

		command: [
			"bash",
			"-c",
			"for p in $(pgrep -f qs-music.sock 2>/dev/null); do [ \"$p\" != \"$$\" ] && kill $p 2>/dev/null; done; " +
			"exec mpv --no-video --no-terminal --shuffle --pause --idle=yes --input-ipc-server='" + root.sockPath + "' '" + root.musicDir + "'"
		]

		running: true
	}

	Socket {
		id: ipc
		path: root.sockPath

		function send(request) {
			ipc.write(JSON.stringify(request) + "\n")
			ipc.flush()
		}

		parser: SplitParser {
			onRead: data => {
				let msg

				try {
					msg = JSON.parse(data)
				} catch (e) {
					return
				}

				if (msg.event === "property-change") {
					switch (msg.name) {
						case "pause":
							root.playing = msg.data !== true
							break
						case "playlist-pos":
							if (msg.data < 0) {
								root.tagTitle = ""
								root.fileTitle = ""
								root.artist = ""
							}
							break
						case "metadata":
							root.tagTitle = msg.data ? (msg.data.title ?? "") : ""
							root.artist = msg.data ? (msg.data.artist ?? "") : ""
							break
						case "filename/no-ext":
							root.fileTitle = msg.data ?? ""
							break
						case "audio-device":
							root.audioDevice = (msg.data ?? "").replace("pipewire/", "")
							break
					}
				}
			}
		}

		onConnectedChanged: if (connected) {
			send({ command: ["observe_property", 1, "pause"] })
            		send({ command: ["observe_property", 2, "playlist-pos"] })
            		send({ command: ["observe_property", 3, "metadata"] })
            		send({ command: ["observe_property", 4, "filename/no-ext"] })
			send({ command: ["observe_property", 5, "audio-device"] })
			send({ command: ["set_property", "volume", 100] })
            		
		}
	}

	Timer {
		interval: 250
		running: player.running && !ipc.connected
		repeat: true
		onTriggered: ipc.connected = true
	}

	function toggle() { ipc.send({ command: ["set_property", "pause", root.playing] }) }
    	function next() { ipc.send({ command: ["playlist-next"] }) }
	function prev() { ipc.send({ command: ["playlist-prev"] }) }

	function setAudioDevice(device) {
		ipc.send({ command: ["set_property", "audio-device", "pipewire/" + device] })
		visualiserEnabled = false
		restartTimer.restart()
	}

	Timer {
		id: restartTimer
		interval: 50
		onTriggered: root.visualiserEnabled = true
	}

	Process {
		id: cava

		readonly property string runtimeConfig:
			Quickshell.env("XDG_RUNTIME_DIR") + "/qs-cava-run.conf"

		command: [
			"bash",
			"-c",
			"src=''; " +
			"for i in $(seq 1 20); do " +
			"src=$(pactl list short sources | grep RUNNING | grep monitor | head -n1 | cut -f2); " +
			"[ -n \"$src\" ] && break; " +
			"sleep 0.1; " +
			"done; " +
			"[ -z \"$src\" ] && src=auto; " +
			"sed \"s|^source.*|source = $src|\" '" + root.cavaConfig + "' > '" + runtimeConfig + "'; " +
			"exec cava -p '" + runtimeConfig + "'"
		]
		running: root.active && root.playing && root.visualiserEnabled

		stdout: SplitParser {
			onRead: data => {
				const parts = data.split(";").filter(part => part !== "")
				if (parts.length !== root.barCount)
					return

				const next = []

				for (let index = 0; index < root.barCount; index++)
					next.push(parseInt(parts[index]) / 255)

				root.bars = next
			}
		}
	}
}
