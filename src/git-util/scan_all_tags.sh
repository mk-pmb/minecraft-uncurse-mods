#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function scan_all_tags () {
  local EACH_TAG_CMD="${1:-found_one_tag}"; shift

  cd -- "$SELFPATH" || return $?
  local REPOPATH="$(git rev-parse --show-toplevel)"
  [ -d "$REPOPATH" ] || return 3$(echo 'E: Cannot detect repo path!' >&2)
  source -- "$REPOPATH"/src/bash-util/regex_util.sh --lib || return $?

  local -A MOD=()
  source -- mod_info.rc || return $?
  export GIT_DIR='tmp.bare-repo.git'
  "$REPOPATH"/src/git-util/ensure_bare_repo.sh "${MOD[repo]}" || return $?

  local REPORT_DEST="${CFG[scan_tags_report]}"
  local REPORT_TMP="tmp.$REPORT_DEST"

  local DIFF='diff'
  colordiff </dev/null &>/dev/null && DIFF='colordiff'

  local TAGS=(
    git tag
    --list
    --contains "${CFG[scan_tags_since]:-<E: missing option scan_tags_since>}"
    --sort="${CFG[scan_tags_ref_sort]:-version:refname}"
    )
  readarray -t TAGS < <("${TAGS[@]}")
  local TAG= COMMIT=
  if [ "$EACH_TAG_CMD" == --func ]; then "$@"; return $?; fi
  for TAG in "${TAGS[@]}"; do
    COMMIT="$(git rev-list -n 1 "$TAG")"
    [ -n "$COMMIT" ] || return 4$(echo "E: Tag '$TAG' has no commit!" >&2)
    $EACH_TAG_CMD || return $?$(
      echo "E: Failed to run hook '$EACH_TAG_CMD' for tag '$TAG', rv=$?" >&2)
  done 7>"$REPORT_TMP"

  LANG=C sort --version-sort -- "$REPORT_TMP" >"$REPORT_TMP".sorted || return $?
  mv --no-target-directory -- "$REPORT_TMP"{.sorted,} || return $?

  "${CFG[scan_tags_refine_tmp]:-true}" "$REPORT_TMP" || return $?

  "$DIFF" -sU 2 -- "$REPORT_DEST" "$REPORT_TMP" || true
  mv --no-target-directory --verbose \
    -- "$REPORT_TMP" "$REPORT_DEST" || return $?
}


function scan_all_tags__write_info_dict () {
  local KEY= VAL= MANDATORY= BUF=
  KEY="
    ${CFG[scan_tags_version_field]:-modver}
    tag|
    commit|
    $*"
  for KEY in $KEY; do
    MANDATORY=
    case "$KEY" in
      *'|' ) KEY="${KEY%|}"; MANDATORY='|';;
      *'!' ) KEY="${KEY%!}"; MANDATORY='+';;
    esac
    VAL="${INFO[$KEY]}"
    [ -n "$VAL" ] || [ "$MANDATORY" != '|' ] || eval 'VAL=$'"${KEY^^}"
    [ -z "$MANDATORY" ] || case "$VAL" in
      *$'\n'* | \
      '' ) echo "E: Invalid info '$KEY'='$VAL' for tag '$TAG'!" >&2; return 4;;
    esac
    BUF+="$KEY=$VAL"$'\t'
  done
  echo >&7 "$BUF="
}








[ "$1" == --lib ] && return 0; scan_all_tags "$@"; exit $?
