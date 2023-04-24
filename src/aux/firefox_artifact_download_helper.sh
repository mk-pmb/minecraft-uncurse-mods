#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ardl () {
  local WT_FFOX='Mozilla Firefox'
  local WT_SAVE='Enter name of file to save to…'

  local URLS=()
  readarray -t URLS < <( clipdump | sed -rf <(echo '
    /\s/d
    s~^https://github\.com(/[A-Za-z0-9_.-]+){2}/~& ~
    / /!d
    s: (releases/download/):\1:p
    s: (suites/[0-9]+/artifacts/[0-9]+)$:$1:p
    ') )
  local CNT="${#URLS[@]}"
  local MIN=3
  [ "$CNT" -ge "$MIN" ] || return 4$(
    echo "E: Found too few qualified URLs in clipboard!" \
      "Copy at least $MIN to justify mass-downloading." >&2)
  local URL= HAD=0
  for URL in "${URLS[@]}"; do
    echo -n "$(( ( HAD * 100) / CNT ))% "
    wait_for_window_title P " — $WT_FFOX"'$' || return $?
    setsid firefox "$URL" </dev/null &>/dev/null
    wait_for_window_title xF "$WT_SAVE" || return $?
    xdotool key Alt+s
    # Confirming the save yields a left-over empty tab.
    wait_for_window_title xF "$WT_FFOX" || return $?
    xdotool key Ctrl+w
    sleep 2s # Wait for empty tab to close
    (( HAD += 1 ))
  done
  echo "100% = $CNT qualified URLs processed."
}


function wait_for_window_title () {
  echo -n "Waiting for window title '$2'… "
  while sleep 1s; do
    xdotool getactivewindow getwindowname 2>/dev/null \
      | grep -q"$1"e "$2" && break
    echo -n '… '
  done
  echo found.
}










ardl "$@"; exit $?
