export EDITOR=vim
export TERMINAL=lxterminal
export BROWSER=firefox

# Gtk themes
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

#if in screen, set screen's title to command. revert when done
function set_title_and_run(){
	local title="$1"
	shift
	local cmd="$*"
	if [[ ! -z "$STY" ]]; then
		local old_title="$(screen -Q title)"
		screen -X title "$title"
	fi
	$cmd
	[[ ! -z "$STY" ]] && screen -X title "$old_title"
}

alias ls='ls -F --color=auto'
alias ll="ls -lh"
alias la="ls -lah"
alias gst="git status"
alias nocaps="setxkbmap -option 'ctrl:nocaps'"
#clear the exit code, forcing prompt to smile
alias k='clear'
#pacman aliases
alias Up='sudo pacman -Syu'
alias Pm='sudo pacman -S'
alias Ps='pacman -Ss'

#commands that will set screen window titles
alias profanity='set_title_and_run chat profanity'
alias vim='set_title_and_run vim vim'
alias w3m='set_title_and_run w3m w3m -v'
alias cmus="set_title_and_run cmus cmus"

#beep. useful to get screen notification when command finishes ala './some_long_script; beep'
alias beep='echo -en "\007"'

# Colors
COLOR_ESC='\[\033['
COLOR_END='m\]'
COLOR_RESET="${COLOR_ESC}0${COLOR_END}"
COLOR_GREEN="${COLOR_ESC}1;32${COLOR_END}"
COLOR_RED="${COLOR_ESC}1;31${COLOR_END}"
PSWIN="${COLOR_GREEN}:-]${COLOR_RESET}"
PSFAIL="${COLOR_RED}:-[${COLOR_RESET}"
PS1="\u@\h \$((( \$? == 0 )) && echo \"${PSWIN}\" || echo \"${PSFAIL}\") "

#fix errors in spectrwm
LD_PRELOAD=""

#load da
. $HOME/da.sh

function mntlbl(){
	local label="${1:?"no label given"}"
	sudo mkdir -p "/mnt/$label"
	sudo mount -L "$label" "/mnt/$label"
}

#note: to mount an iso image:
#may need to sudo modprobe loop on arch
#sudo mount -o loop $1 /media/cdrom0

