#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function compat_versions_scan () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  local -A MOD=() CFG=(
    [scan_tags_since]='bcea78c7' # PR 503 merged
    [scan_tags_report_dest]='compat_versions.txt'
    )
  source -- "$SELFPATH"/../../src/git-util/scan_all_tags.sh "$@" || return $?
}


function found_one_tag () {
  printf >&7 '%s\t' tag="$TAG" commit="$COMMIT"
  local MC_VER="$(find_minecraft_version_for_tag)"
  printf >&7 '%s\t' minecraft="$MC_VER"
  echo >&7 =
}


function find_minecraft_version_for_tag () {
  git show "$TAG:worldedit-fabric/build.gradle.kts" \
    | sed -nre 's~^val minecraftVersion = "([0-9.]+)"$~\1~p'
}










compat_versions_scan "$@"; exit $?
