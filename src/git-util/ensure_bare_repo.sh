#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ensure_bare_repo () {
  local URL="$1"
  local RMT="${REPO_UPSTREAM:-origin}"
  local BRAN="${REPO_MAIN_BRANCH:-master}"
  local MAX_AGE="${REPO_MAX_AGE:-3 hours}"
  [ -n "$GIT_DIR" ] || export GIT_DIR='tmp.bare-repo.git'
  git init || return $?
  git remote add "$RMT" "$URL" || true

  local FETCH_REF_FILE="$GIT_DIR/refs/remotes/$RMT/$BRAN"
  local AGE_CMP="$GIT_DIR"/recent_enough_fetch.ts
  touch --date="$MAX_AGE ago" -- "$AGE_CMP" || return $?
  if [ "$FETCH_REF_FILE" -nt "$AGE_CMP" ]; then
    echo -n "D: Last fetch for $RMT/$BRAN seems recent enough: "
    stat -c '%y' -- "$FETCH_REF_FILE"
  else
    git fetch "$RMT" || return $?
    # Update file time even if git did not find new commits:
    touch --no-create -- "$FETCH_REF_FILE" || return $?
  fi

  git branch --force {,"$RMT"/}"$BRAN" || return $?
}






ensure_bare_repo "$@"; exit $?
