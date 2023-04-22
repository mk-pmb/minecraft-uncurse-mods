#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ensure_bare_repo () {
  local URL="$1"
  if [ -z "$URL" ]; then
    local -A MOD=()
    source -- mod_info.rc
    URL="${MOD[repo]}"
    [ -n "$URL" ] || return 3$(
      echo "E: $FUNCNAME: No URL given and failed to detect it." >&2)
  fi
  local RMT="${REPO_UPSTREAM:-origin}"
  local BRAN="$REPO_MAIN_BRANCH"
  local MAX_AGE="${REPO_MAX_AGE:-3 hours}"
  [ -n "$GIT_DIR" ] || GIT_DIR='tmp.bare-repo.git'
  [ "${GIT_DIR:0:1}" == / ] || GIT_DIR="$PWD/$GIT_DIR"
  export GIT_DIR
  git init || return $?
  git remote add "$RMT" "$URL" || true

  if ! ensure_bare_repo__is_recent_enough; then
    echo 'D: Last fetch was too long ago. Fetching again.'
    git fetch "$RMT" || return $?

    # Update file time even if git did not find new commits:
    touch --no-create -- "$FETCH_REF_FILE" || return $?

    # Update our knowledge about which remote branch is the default:
    git remote set-head "$RMT" --auto
    # This is important for repos where the name of the latest branch
    # isn't long-term predictable, e.g. with EditSign.
  fi

  git branch --force {,"$RMT"/}"$BRAN" || return $?
}


function ensure_bare_repo__is_recent_enough () {
  local HEAD="refs/remotes/$RMT/HEAD"
  [ -f "$GIT_DIR/$HEAD" ] || return 4
  [ -n "$BRAN" ] || BRAN="$(git rev-parse --abbrev-ref "$HEAD")"
  [[ "$BRAN" == "$RMT/"* ]] && BRAN="${BRAN#$RMT/}"
  local FETCH_REF_FILE="$GIT_DIR/refs/remotes/$RMT/$BRAN"
  local AGE_CMP="$GIT_DIR"/recent_enough_fetch.ts
  touch --date="$MAX_AGE ago" -- "$AGE_CMP" || return $?
  [ "$FETCH_REF_FILE" -nt "$AGE_CMP" ] || return 1
  echo -n "D: Last fetch for $RMT/$BRAN seems recent enough: "
  stat -c '%y' -- "$FETCH_REF_FILE"
}






ensure_bare_repo "$@"; exit $?
