#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function regex_assign () {
  local RGX="$1"; shift
  RGX="${RGX//'(?%dotnum)'/'¹(?:\.[0-9]+)+'}"
  RGX="${RGX//'(?%triplet)'/'³\.³\.³'}"
  RGX="${RGX//'³'/'¹+'}"
  RGX="${RGX//'²'/'¹{2}'}"
  RGX="${RGX//'¹'/'[0-9]'}"
  [[ "$1" =~ $RGX ]] || return 1$(
    echo "W: nomatch: '$1' =~ $RGX'" >&2)
  echo
  echo "D: match: '$1' =~ $RGX'" >&2
  shift
  echo "@[$*] re[${BASH_REMATCH[*]}]"
  local GRP=1
  while [ "$#" -ge 1 ]; do
    (( GRP += 1 ))
    [ "$1" == . ] && continue
    eval echo ">> $1"='${BASH_REMATCH[$GRP]}'
    shift
  done
  echo
}










return 0
