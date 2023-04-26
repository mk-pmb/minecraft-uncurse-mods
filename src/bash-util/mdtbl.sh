#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function mdtbl_head () {
  local C='
    s~\s+~ ~g
    /^ ?#/b
    s~^ ?(\S+) (<|>|) ?([0-9]+)$~\n\2 \3:\1~
    /^\n/!b
    s~^\n ~m~p
    s~^\n< ~l~p
    s~^\n> ~r~p
    '
  C="$( <<<"$*" sed -nrf <(echo "$C") | tr '\n' '|' )"
  MDTBL=( [cols]="$C" )
  mdtbl_rowfmt :
  mdtbl_rowfmt -
}


function mdtbl_rowfmt () {
  local D="$1" C="${MDTBL[cols]}" A= W= K= V=
  while [ -n "$C" ]; do
    K="${C%%|*}"
    [ "$K" != "$C" ] || break
    C="${C#*|}"
    A="${K:0:1}"; K="${K:1}"
    W="${K%%:*}"; K="${K#*:}"
    case "$D" in
      : ) V="$K";;
      - )
        printf -v V -- '% *s' "$W" ''
        V="${V// /-}"
        case "$A" in
          r ) echo -n "| $V-";;
          m ) echo -n "| $V ";;
          * ) echo -n "|-$V ";;
        esac
        continue;;
      * ) eval 'V="${'"$D"'["$K"]}"';;
    esac
    case "$A" in
      r ) printf -v V -- '% *s' "$W" "$V";;
      * ) printf -v V -- '%- *s' "$W" "$V";;
    esac
    echo -n "| $V "
  done
  echo '|'
}










return 0
