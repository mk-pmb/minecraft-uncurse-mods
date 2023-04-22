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
    --sort="${CFG[scan_tags_sort]:-version:refname}"
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

  "$DIFF" -sU 2 -- "$REPORT_DEST" "$REPORT_TMP" || true
  mv --no-target-directory --verbose \
    -- "$REPORT_TMP" "$REPORT_DEST" || return $?
}








[ "$1" == --lib ] && return 0; scan_all_tags "$@"; exit $?
