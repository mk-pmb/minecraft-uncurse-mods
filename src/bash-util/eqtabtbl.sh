#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function eqtabtbl_foreach () {
  local EQTABTBL_LINES=()
  IFS= readarray -t EQTABTBL_LINES < <(
    LANG=C sed -rf "${BASH_SOURCE/%.sh/.sed}" -- "$1" ) || return $?
  local EQTABTBL_LCNT="${#EQTABTBL_LINES[@]}"
  [ "$EQTABTBL_LCNT" -ge 1 ] || return 4$(
    echo "E: Found no data lines in '$1'!" >&2)
  shift
  local EQTABTBL_LNUM=0
  local EQTABTBL_LINE=
  for EQTABTBL_LINE in "${EQTABTBL_LINES[@]}"; do
    (( EQTABTBL_LNUM += 1 ))
    "$@" || return $?
  done
}


[ "$1" == --lib ] && return 0; eqtabtbl_"$@"; exit $?
