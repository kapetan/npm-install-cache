#!/bin/bash

DEFAULT_RETAIN=10

function _retain() {
	local r=${1:-$DEFAULT_RETAIN}

	if [ "$r" == all ]; then
		cat
	else
		tail -n "+$((r + 1))"
	fi
}

function get_package_hash() {
	echo $(cat package.json | shasum | sed 's/[ \t]*-[ \t\n]*$//')
}

function get_cache_dir() {
	local cache_id=$(get_package_hash)
	echo "/tmp/npm-install-cache/$cache_id"
}

function clean_cache_dir() {
	ls -tp /tmp/npm-install-cache | grep /$ | _retain "$1" | while read d; do
		rm -rf "/tmp/npm-install-cache/$d"
	done
}

function build() {
	local cache_dir=$(get_cache_dir)

	if [ -d "$cache_dir" ]; then
		cp -r "$cache_dir/" node_modules
	else
		npm install || exit $?
		cp -r "node_modules/" "$cache_dir" 2> /dev/null || mkdir -p "$cache_dir"
	fi
}

function usage() {
	local dir="$(cd "$(dirname "$0")" && pwd)"
	cat "$dir/usage.txt"
}

if [ "$1" == clean ]; then
	clean_cache_dir "$2"
elif [ "$1" == help ]; then
	usage
else
	build
fi
