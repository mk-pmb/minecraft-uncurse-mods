#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function compat_versions_scan () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  cd -- "$SELFPATH" || return $?
  local -A MOD=()
  source -- mod_info.rc || return $?

  export GIT_DIR='tmp.bare-repo.git'
  ../../src/git-util/ensure_bare_repo.sh "${MOD[repo]}" || return $?

  local DEST='compat_versions.txt'
  investigate_all_tags >tmp."$DEST" || return $?
  mv --no-target-directory --verbose -- {tmp.,}"$DEST" || return $?
}


function investigate_all_tags () {
  local PR_503_MERGED='bcea78c701c012948d486e88ec9661f12e0eb60e'
  local TAGS=()
  readarray -t TAGS < <(
    git tag --contains "$PR_503_MERGED" --list --sort='version:refname')
  local TAG=
  for TAG in "${TAGS[@]}"; do
    investigate_one_tag || return $?$(
      echo "E: Failed to investigate tag '$TAG', rv=$?" >&2)
  done
}


function investigate_one_tag () {
  echo -n "tag=$TAG"
  local COMMIT="$(git rev-list -n 1 "$TAG")"
  echo -n $'\t'"commit=$COMMIT"
  local MC_VER="$(find_minecraft_version_for_tag)"
  echo -n $'\t'"minecraft=$MC_VER"
  echo $'\t='
}


function find_minecraft_version_for_tag () {
  git show "$TAG:worldedit-fabric/build.gradle.kts" \
    | sed -nre 's~^val minecraftVersion = "([0-9.]+)"$~\1~p'
}










compat_versions_scan "$@"; exit $?
