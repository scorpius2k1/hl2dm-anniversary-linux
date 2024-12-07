#!/bin/bash
#
# Info    : Linux workaround for HL2DM operability under Linux clients
# Author  : Scorp (https://github.com/scorpius2k1)
# Repo    : https://github.com/scorpius2k1/hl2dm-anniversary-linux
# License : https://www.gnu.org/licenses/gpl-3.0.en.html#license-text
#

## CONFIG
steampath="$HOME/.steam/steam/steamapps/common"
hl2dmpath="Half-Life 2 Deathmatch"
hl2path="Half-Life 2"
## CONFIG

appname="HL2DM Anniversary Linux"
version="1.0"
hl2script="hl2.sh"
hl2binary="hl2_linux"
launcher=('#!/bin/bash

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

exit $STATUS')
grn='\033[0;32m'
grb='\033[1;32m'
yel='\033[0;33m'
red='\033[0;31m'
rdb='\033[1;31m'
blb='\033[1;34m'
whb="\e[1;97m"
ncl='\033[0m'

function yesno {
    echo -e "${whb}"
    while true; do
            read -p "$*[Y/n]: " yn
            case $yn in
                    [Yy]*) return 0 ;;
                    [Nn]*) echo -e "${rdb}Aborted${ncl}\n" ; exit 0 ;;
            esac
    done
    echo -e "${ncl}"
}
function checksnap { if [ -d "$HOME/snap/steam/common/.local/share/Steam/steamapps/common" ]; then steampath="$HOME/snap/steam/common/.local/share/Steam/steamapps/common"; notice "Flatpak Install Detected"; fi }
function checkflat { if [ -d "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common" ]; then steampath="$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/common"; notice "Snap Install Detected"; fi }
function checkpath { if [ -d "$2" ]; then echo -e "${whb}[ ${grb}FOUND${whb} ] $1${ncl}"; else echo -e "${whb}[ ${rdb}ERROR${whb} ] $1 : ${red}'$2' ${ncl}\n"; exit 0; fi }
function checkfile { if [ -f "$2" ]; then echo -e "${whb}[ ${grb}FOUND${whb} ] $1${ncl}"; else echo -e "${whb}[ ${rdb}ERROR${whb} ] $1 : ${red}'$2' ${ncl}\n"; exit 0; fi }
function notice { echo -e "${whb}=> $1${ncl}"; sleep 1; }

clear
echo -ne "${blb}.:: ${appname} by Scorp v${version}::.${nc}\n\n"
notice "Checking Requirements..."
checkflat
checksnap
checkpath "Steam Path" "${steampath}"
checkpath "HL2 Path  " "${steampath}/${hl2path}"
checkfile "HL2 Binary" "${steampath}/${hl2path}/${hl2binary}"
checkpath "HL2DM Path" "${steampath}/${hl2dmpath}"
echo -e "\n${yel}DISCLAIMER: This workaround will allow HL2DM to run\nunder Linux using only the official HL2 binary and\ncustom launch script. While this should be safe to\ndo, there is a risk of triggering a VAC ban on the\naccount used. Please use at your own discretion.${nc}"
yesno "Install HL2DM Linux Anniversary Workaround? "
echo -e ""
notice "Symlinking Official HL2 Binary..."
rm -rf "${steampath}/${hl2dmpath}/${hl2binary}"
ln -s "${steampath}/${hl2path}/${hl2binary}" "${steampath}/${hl2dmpath}/"
if [ -f "${steampath}/${hl2dmpath}/${hl2script}" ]; then notice "Backup Existing Steam Launch Script..."; mv -f "${steampath}/${hl2dmpath}/${hl2script}" "${steampath}/${hl2dmpath}/${hl2script}.bak"; fi
notice "Generating Steam Launch Script..."
rm -rf "${steampath}/${hl2dmpath}/${hl2script}"
echo "${launcher}" > "${steampath}/${hl2dmpath}/${hl2script}"
chmod +x "${steampath}/${hl2dmpath}/${hl2script}"
notice "Validating Install..."
checkfile "Binary" "${steampath}/${hl2dmpath}/${hl2binary}"
checkfile "Launch Script" "${steampath}/${hl2dmpath}/${hl2script}"
echo -e ""
notice "Success! Please launch HL2DM via Steam!"
echo -e ""
