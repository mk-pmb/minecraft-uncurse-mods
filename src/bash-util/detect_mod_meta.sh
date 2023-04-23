#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function detect_mod_meta () {
  local SED_SECT=
  local RAW_META="$(detect_mod_meta__find_sect meta)"
  local RAW_DESCR="$(detect_mod_meta__find_sect descr)"
  local DICT_DATA='
    s~^\* __([A-Za-z ]+):__$~[\L\1\E]=\n~
    /\n$/{
      s~\s+~_~g
      N
    }
    /_\n  /{
      s~\x27+~\x27"&"\x27~g
      s~_\n +~\x27~
      s~$~\x27~
      p
    }
    '
  DICT_DATA="$( <<<"$RAW_META" LANG=C sed -nrf <(echo "$DICT_DATA") )"
  eval "MOD=( $DICT_DATA )"
}


function detect_mod_meta__find_sect () {
  local TX="/<!-- %begin% $1 -->/,/<!-- %endof% $1 -->/p"
  TX="$(sed -nre "$TX" -- "${2:-README.md}")"
  TX="${TX#*>}"
  TX="${TX%<*}"
  local TRIM=
  for TRIM in {1..3}; do
    TX="${TX#$'\n'}"
    TX="${TX%$'\n'}"
  done
  echo "$TX"
}


function detect_mod_meta__debug () {
  local -A MOD=()
  detect_mod_meta "$@" || return $?
  local -p
}


[ "$1" == --lib ] && return 0; detect_mod_meta__debug "$@"; exit $?
