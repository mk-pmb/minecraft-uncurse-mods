#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

[[ "${FUNCNAME[*]}" == 'source scan_all_tags '* ]] || return 3$(
  echo "D: Function name stack: ${FUNCNAME[*]} (n=${#FUNCNAME[@]})" >&2
  echo "E: File $BASH_SOURCE is meant to be sourced from " >&2)
[ "${#FUNCNAME[@]}" -ge 1 ] || exit 4

[ -n "${CFG[web_cache_dir]}" ] || CFG[web_cache_dir]='tmp.webcache'
mkdir --parents "${CFG[web_cache_dir]}" || return $?


function found_one_tag () {
  local EXPA="${CFG[web_cache_dir]}/expa_$TAG.html"
  if [ ! -f "$EXPA" ]; then
    NEW_TAGS+=( "$TAG" )
    return 0
  fi

  local UE_TAG="$TAG"
  UE_TAG="${UE_TAG//+/%2B}"

  local DL_FILES=()
  parse_expa_download_links || return $?
  local JAR=
  case "${#DL_FILES[@]}:${DL_FILES[*]}" in
    0: ) echo "W: tag '$TAG': Found no JAR!" >&2;;
    1:"${CFG[jar_file_prefix]}"*.jar ) JAR="${DL_FILES[0]}";;
    * )
      echo "E: tag '$TAG': Unexpected download file(s): ${DL_FILES[*]}" >&2
      return 4;;
  esac
}


function parse_expa_download_links () {
  local LINKS=()
  readarray -t LINKS < <(<"$EXPA" tr -s ' \t\r\n' ' ' \
    | sed -re 's~<a href="~\n\a~g;s~</a~\n~g' | sed -rf <(echo '
      /^\a/!d
      s~^\a~~
      s~<[^<>]*>~~g
      s~"[^<>]*>\s*~\t~
      s~\s+$~~
      s~^(/[A-Za-z0-9_.-]+){2}/~~
      s~\tSource code \(([a-z.]+)\)$~\t~
      ')
    )
  local KEY= VAL=
  for VAL in "${LINKS[@]}"; do
    case "$VAL" in
      archive/refs/tags/"$TAG".tar.gz$'\t' | \
      archive/refs/tags/"$TAG".zip$'\t' ) continue;;
    esac
    KEY="${VAL%%$'\t'*}"
    VAL="${VAL#*$'\t'}"
    if [ "$KEY" == "releases/download/$UE_TAG/$VAL" ]; then
      DL_FILES+=( "$VAL" )
      continue
    fi
    echo "E: unexpected download link format: '$VAL' -> '$KEY'" >&2
    return 8
  done
}


function download_missing_files_lists () {
  local CNT="${#NEW_TAGS[@]}"
  echo "D: Need to download files lists for $CNT tags."
  [ "$CNT" == 0 ] && return 0
  local EXPA_BASE="${MOD[mod_repo]}/releases/expanded_assets/"

  local RATE_SEC=5
  # ^-- The API call sometimes takes up to 6 sec, sometimes just 2 sec.
  #     Thus, to be able to estimate, we need to use an absolute rate
  #     rather than a static cooldown.
  local ESTIMATE=$(( CNT * RATE_SEC ))
  printf 'D: [%(%F %T)T] Downloads will probably finish before %(%F %T)T.\n'\
    -1 $(( EPOCHSECONDS + ESTIMATE ))

  local IDX=0 PGR= WAIT= BUF= TAG= URL=
  SECONDS=0
  for TAG in "${NEW_TAGS[@]}"; do
    if [ "$IDX" != 0 ]; then sleep "$RATE_SEC"s & WAIT=$!; fi
    (( IDX += 1 ))
    PGR="$(( ( IDX * 100 ) / $CNT ))% of tags, $((
      ( SECONDS * 100 ) / ESTIMATE ))% of estimated time"
    BUF='   '
    [ "$IDX" == "$CNT" ] || BUF=' …'
    printf '\rD: [%(%F %T)T] #%s = %s, tag %- 30s% 10s' \
      -1 "$IDX/$CNT" "$PGR" "$TAG$BUF" ''
    URL="$EXPA_BASE${TAG//+/%2B}"
    BUF="${CFG[web_cache_dir]}/expa_$TAG.html"
    wget --quiet --output-document="$BUF.tmp" -- "$URL" || return $?
    mv --no-target-directory -- "$BUF"{.tmp,} || return $?
    [ -z "$WAIT" ] || wait "$WAIT" || return $?
  done
  echo
  printf 'D: [%(%F %T)T] Dowloads finished.\n' -1
  echo 'W: The missing files have been downloaded,' \
    'but you must run the scanner again to add their data.' >&2
}












return 0
