#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function compat_versions_scan () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  local -A CFG=(
    [scan_tags_since]='0393cbae'
    [scan_tags_report]='compat_versions.txt'
    )
  source "$SELFPATH"/../../src/git-util/scan_all_tags.sh || return $?
}


function found_one_tag () {
  printf >&7 '%s\t' tag="$TAG" commit="$COMMIT"
  local MOD_VER="$TAG"
  local MCR_VER=
  local RGX=''
  local -p

  echo >&7 =
}


function find_minecraft_version_for_tag () {
  git show "$TAG:worldedit-fabric/build.gradle.kts" \
    | sed -nre 's~^val minecraftVersion = "([0-9.]+)"$~\1~p'
}










compat_versions_scan "$@"; exit $?
