#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function releases_scan () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"

  export REPO_MAIN_BRANCH='unstable'

  local -A MOD=() CFG=(
    [scan_tags_since]='12b8856a'
    [scan_tags_report_dest]='.'
    [scan_tags_extra_libs]='git-util/github_release_scanner.sh'
    [jar_file_prefix]='mousewheelie-'
    )
  local NEW_TAGS=()

  source -- "$SELFPATH"/../../src/git-util/scan_all_tags.sh "$@" || return $?
  download_missing_files_lists || return $?
}















releases_scan "$@"; exit $?
