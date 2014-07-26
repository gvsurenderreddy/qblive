#!/bin/bash

#source this ('source da.sh' or '. da.sh') to put load functions in your environment.
#executing this script will do nothing. do not './da.sh', or put da.sh in your path.

#declare the global associative array to store aliases in
#WARNING: bash manpage reports in bugs "Array variables may not (yet) be exported."
#redeclaring the list does not clear it; list will remain populated if this file is sourced again
declare -A DA_LIST
#default alias '.' for HOME
DA_LIST['.']="$HOME"

#show usage info
function da_help(){
	cat <<-EOF
		da: directory aliases. for using short aliases to refer to long paths
	
		usage:
		da OPTION
		da -
		da [ALIAS [PATH]]
		
		if given no arguments, da will print the currently loaded aliases
		if given a command option (listed below), da will execute the command
		if given a single argument, da will attempt to switch to the indicated directory
		    like cd, da supports using - to switch to the previous directory
		    da has a default alias, '.' for HOME ($HOME)
		    if given a path or existing alias, da will go there
		    if given something that is both a path and an existing alias, da will go to the path, not the alias
				except if given the alias '.'
		    if given an alias that is not assigned, da will prompt to create an alias for the current directory
		if given two arguments (an alias and a path), da will create the alias for the directory
	
		options:
		    -h, -H         print this message
		    -c, -C         clear the list, uppercase to skip confirmation
		    -d, -D alias   delete an alias, upper case to skip confirmation
		    -s, -S path    save a set of aliases, uppercase to overwrite without confirmation
		    -l, -L path    load a set of aliases, uppercase to clear the existing list first
		
		notes:
		confirmation accepts 'y', 'yes', or 'eys' (case insensitive) as affirmitive.
		    all other responses are considered negative.
		do NOT use ':' character in alias names. spaces and slashes not advised either, but should work (untested)
	EOF
}

#confirmation function. call like: if da_confirm "do stuff?"; then do_stuff; fi
function da_confirm(){
	read -p "$* " inpt
	case "$(echo "$inpt" | tr [:upper:] [:lower:])" in
		'y'|'yes'|'eys') return 0 ;;
		*) return 1 ;;
	esac
}

#print the contents of the list to stdout
function da_print(){
	for key in "${!DA_LIST[@]}"; do
		echo "$key:${DA_LIST["$key"]}"
	done
}

#change to given directory or alias
function da_cd(){
	local ali="$1"
	if [[ "$ali" == "-" ]]; then
		cd - > /dev/null #supress output; will echo at end of function anyway
	elif [[ "$ali" != "." && -d "$ali" ]]; then
		cd "$ali";
	else
		local dir="${DA_LIST["$ali"]}"
		if [[ -z "$dir" ]]; then
			if da_confirm "no such alias. create one for '$(pwd)'?"; then
				da_save "$ali" "$(pwd)"
			fi
		else
			cd "$dir"
		fi
	fi
	echo "da: '$(pwd)'"
}

#delete alias from da list
function da_del(){
	local ali="${1:?"no alias given"}"
	unset DA_LIST["$ali"]
}

#confirm before deleting
function da_conf_del(){
	local ali="${1:?"no alias given"}"
	local dir="${DA_LIST["$ali"]}"
	if [[ -z "$dir" ]]; then
		echo "alias does not exist"
	else
		if da_confirm "delete alias '$ali' to '$dir'?"; then
			da_del "$ali"
		fi
	fi
}

#save da list into given file; overwrites.
function da_save(){
	local file="${1?"no file given"}"
	da_print > "$file"
}

#check if file exists and confirm before overwriting
function da_safe_save(){
	local file="${1?"no file given"}"
	if [ ! -f "$file" ] || da_confirm "overwrite existing file '$file'?"; then
		da_save "$file"
	fi
}

#load a saved set of aliases
function da_load(){
	local file="${1?"no file given"}"
	if [[ -f "$file" ]]; then
		while read line; do
			key="$(echo "$line" | cut -d: -f1)"
			dir="$(echo "$line" | cut -d: -f2)"
			DA_LIST["$key"]="$dir"
		done < "$file"
	else
		echo "file '$file' not found or cannot be read"
	fi
}

#clear da list
function da_clear(){
	unset DA_LIST
	declare -gA DA_LIST
}

#save an alias into da list
function da_save(){
	local ali="${1:?"no alias"}"
	local dir="${2:-"$(pwd)"}"
	if echo "$ali" | grep ':' > /dev/null; then
		echo "illegal alias name. no colons allowed."
		return 1
	fi
	#convert relative path to an absolute path
	local absdir="$(cd "$dir" && pwd)"
	if [[ -d "$absdir" ]]; then
		DA_LIST["$ali"]="$absdir"
	else
		echo "directory check failed ('$dir' probably doesn't exist)"
		return 1
	fi
}

#main da function. check help above for usage info
function da(){
	while getopts "HhCcD:d:S:s:L:l:" OPTION; do
		echo "checking opts. '$OPTION', '$OPTARG'"
		case $OPTION in
			H|h) da_help; return ;;
			C) da_clear; return ;;
			c) if da_confirm "clear da list?"; then da_clear; fi; return ;;
			D) da_del "$OPTARG"; return ;;
			d) da_conf_del "$OPTARG"; return ;;
			S) da_save "$OPTARG"; return ;;
			s) da_safe_save "$OPTARG"; return ;;
			L) da_clear; da_load "$OPTARG"; return ;;
			l) da_load "$OPTARG"; return ;;
		esac
	done
	case $# in
		0) da_print ;;
		1) da_cd "$1" ;;
		2) da_save "$1" "$2" ;;
		*) da_help ;;
	esac
}

