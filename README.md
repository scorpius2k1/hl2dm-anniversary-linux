<a name="top"></a>
![Half Life 2: Deathmatch 20th Anniversary Linux](http://f.scorpex.org/i/90106db5b72cab30ac44d5faa32686ff.png)

## Table of Contents
- [Description](#-information)
- [Prerequisites](#-prerequisites)
- [Disclaimer](#-disclaimer)
- [How does this work?](#-how-does-this-work)
- [What doesn't work?](#-what-does-not-work)
- [Installation](#-installation)
- [Removal](#-removal)
- [Support](#-support)

## 📜 Information
On November 15th, 2024, Valve released the 20th Anniversary update for Half-Life 2. With this, an update to Half-Life 2: Deathmatch was included _without_ working binaries for Linux clients, effectively rendering the game inoperable on all Linux distributions, including the Steam Deck. Until an official update is released for Linux clients, this repository will serve as a workaround to enable Linux users to play Half-Life 2: Deathmatch again.

## ✅ Prerequisites
To use this repository, you will need to have Steam for Linux installed as well as Half-Life 2: Deathmatch and Half-Life 2 purchased and installed on your desired Steam account.
- Half-Life 2: Deathmatch is now available as a [bundle with Half-Life 2](https://store.steampowered.com/app/220/HalfLife_2/)

## ⚠️ Disclaimer
While this workaround should be safe using the official HL2 binary, it is not officially supported by Valve. There is always the risk this workaround could potentially trigger a VAC ban on the account being used. Please use at your own risk and discretion.

## ℹ️ How does this work?
Half-Life 2's official Linux binary included with the 20th Anniversary update is (mostly) compatible with Half-Life 2: Deathmatch. This means it can currently be used as a drop-in replacement for its missing binary running alongside an updated launch script.

## ℹ️ What does not work?
At present, this workaround has a couple of components that do not work:
- Intro video
- MP3 audio files do not play
- Loading maps locally via console
- Start local listening server in-game (Create Server)

The game seems to function perfectly otherwise and can connect to secure and non-secure servers. There may be additional binaries/configs that can be used from Half-Life 2 to get missing functionalities working again. If you are a developer and have solutions, please feel free to open an issue and/or PR.

## 🚀 Installation
- **Automated**
  - Simply clone this repository and run the installation script `hl2dm-anniversary-linux.sh` and follow the prompts. Afterward, launch Half-Life 2: Deathmatch from Steam.

![Half Life 2: Deathmatch 20th Anniversary Linux Installation](http://f.scorpex.org/i/65910a8a9d45e7ff3d2b986e2b0a29dc.gif)

_This script has been tested on Arch Linux, Ubuntu, and Debian, along with Snap and Flatpak. Most other distributions should work as well; future updates will aim to include more options, if needed. If you run into any problems on your distro, please check that the path in the installation script ##CONFIG `steampath=""` variable matches your specific Steam "common" folder path._

- **Manual** (if you prefer to manually apply the same workaround as the automation script)
  - Symlink (recommended), or copy the `hl2_linux` binary from your **Half-Life 2** root folder into your **Half-Life 2: Deathmatch** root folder
  - Copy the updated Steam launch script below and paste into a new file, save as `hl2.sh`, mark as executable `chmod +x hl2.sh`, and place this file into your **Half-Life 2: Deathmatch** root folder
  - Launch **Half-Life 2: Deathmatch** from Steam

```shell
#!/bin/bash

UNAME=`uname`
GAMEROOT=$(cd "${0%/*}" && echo $PWD)
GAMEEXE=hl2_linux

if [ "$UNAME" == "Linux" ]; then
	ulimit -n 2048

	export LD_LIBRARY_PATH="${GAMEROOT}"/bin:$LD_LIBRARY_PATH
	export __GL_THREADED_OPTIMIZATIONS=1
	cd "$GAMEROOT"

	if [ -f pathmatch.inf ]; then export ENABLE_PATHMATCH=1; fi

	STATUS=42
	while [ $STATUS -eq 42 ]; do
		if [ "${GAME_DEBUGGER}" == "gdb" ] || [ "${GAME_DEBUGGER}" == "cgdb" ]; then
			ARGSFILE=$(mktemp $USER.hl2.gdb.XXXX)
			echo b main > "$ARGSFILE"
			echo set env LD_PRELOAD=$LD_PRELOAD >> "$ARGSFILE"
			echo show env LD_PRELOAD >> "$ARGSFILE"
			unset LD_PRELOAD
			echo run $@ >> "$ARGSFILE"
			echo show args >> "$ARGSFILE"
			${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} -x "$ARGSFILE" -novid
			rm "$ARGSFILE"
		else
			${GAME_DEBUGGER} "${GAMEROOT}"/${GAMEEXE} "$@" -novid
		fi
		STATUS=$?
	done   
fi

exit $STATUS
```
## 🗑️ Removal
- Navigate to your **Half-Life 2: Deathmatch** root folder and delete two files, `hl2.sh` and `hl2_linux`. Additionally, there may be a launch script backup file `hl2.sh.bak`, which can also be deleted as well if you do not need it.

## 👥 Support
- A ticket for this issue is open on Valve's official Github, please [follow there](https://github.com/ValveSoftware/Source-1-Games/issues/6556) for updated information.
- If you find this useful and it works well for you, please ⭐ this repository and share with others in the community.
- If you would like to support my work and [servers](https://stats.scorpex.org/) I run in the community, please [buy me a coffee](https://help.scorpex.org/) ☕
  
[Back to top](#top)
