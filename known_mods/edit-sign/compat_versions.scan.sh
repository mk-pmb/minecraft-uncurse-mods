#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function compat_versions_scan () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  local -A CFG=(
    [scan_tags_since]='0393cbae'
    [scan_tags_report]='compat_versions.txt'
    )
  source -- "$SELFPATH"/../../src/git-util/scan_all_tags.sh "$@" || return $?
}


function found_one_tag () {
  local -A INFO=()
  local VAL="$(<<<"$TAG" "$SELFPATH"/parse_tag.sed)"
  case "$VAL" in
    *'¦'* | \
    '' ) echo "E: Failed to parse tag: '$TAG' -> '$VAL'" >&2; return 4;;
    * ) eval "INFO=( $VAL )";;
  esac

  INFO[mod_ver]+="${INFO[mod_suf]}"
  unset INFO[mod_suf]
  [ -n "${INFO[mcr]}" ] || INFO[mcr]="$(find_minecraft_version_for_tag)"

  INFO[java]="$(find_java_version_for_tag)"

  scan_all_tags__write_info_dict '
    mcr!
    loader
    java!
    ' || return $?
}


function find_minecraft_version_for_tag () {
  git show "$TAG:gradle/libs.versions.toml" | sed -nre '
    s~^minecraft-?version = "([0-9.]+)(w[0-9]+[a-z]*|)"$~\1\2~ip
    '
}


function find_java_version_for_tag () {
  git show "$TAG:.github/workflows/gradle_build.yml" | sed -nrf <(echo '
    s~^ *APP_JAVA_VERSION: *([0-9]+)$~\1~p
    s~^ *uses: *[A-Za-z]+/gradle-actions/openjdk-([0-9]+)@\S+$~\1~p
    s~^ *java-version: ([0-9]+)$~\1~p
    ')
}










compat_versions_scan "$@"; exit $?
