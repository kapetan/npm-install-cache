#!/bin/bash

function get_cache_dir() {
	local cache_id=$(cat package.json | grep '"name"' | sed 's/"name"//; s/[^"]*"//; s/"[^"]*//')

	if [ "$cache_id" == "" ]; then
		cache_id=__misc__
	fi

	echo "/tmp/npm-install-cache/$cache_id"
}

function get_hash() {
	echo $(shasum package.json | shasum | sed 's/[ \t]*-[ \t]*//')
}

function read_hash() {
	echo $(cat "$1/package.shasum" 2> /dev/null)
}

function build() {
	local cache_dir=$(get_cache_dir)

	mkdir -p "$cache_dir"

	local new_hash=$(get_hash)
	local old_hash=$(read_hash "$cache_dir")

	if [ "$new_hash" == "$old_hash" ]; then
		cp -r "$cache_dir/" node_modules
	else
		npm install || exit $?
		rm -rf "$cache_dir"
		cp -r "node_modules/" "$cache_dir"
		echo "$new_hash" > "$cache_dir/package.shasum"
	fi
}

build
