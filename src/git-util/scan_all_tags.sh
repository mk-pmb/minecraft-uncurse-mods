#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function scan_all_tags () {
  local EACH_TAG_CMD="${1:-found_one_tag}"; shift

  cd -- "$SELFPATH" || return $?
  local REPOPATH="$(git rev-parse --show-toplevel)"
  [ -d "$REPOPATH" ] || return 3$(echo 'E: Cannot detect repo path!' >&2)
  local LIB='
    bash-util/eqtabtbl.sh
    bash-util/regex_util.sh
    bash-util/detect_mod_meta.sh
    '"${CFG[scan_tags_extra_libs]}"
  for LIB in $LIB; do source -- "$REPOPATH/src/$LIB" --lib || return $?; done

  local REPORT_DEST="${CFG[scan_tags_report_dest]}"
  [ -n "$REPORT_DEST" ] || return 4$(
    echo "E: $FUNCNAME: No report destination!" >&2)
  local REPORT_TMP="tmp.$REPORT_DEST"

  detect_mod_meta || return $?
  export GIT_DIR='tmp.bare-repo.git'
  "$REPOPATH"/src/git-util/ensure_bare_repo.sh "${MOD[mod_repo]}" || return $?

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
  done 7>>"$REPORT_TMP"

  scan_all_tags__finalize_report || return $?
}


function scan_all_tags__finalize_report () {
  if [ "$REPORT_DEST" == . ]; then
    rm -- "$REPORT_TMP" || return $?
    return 0
  fi

  LANG=C sort --version-sort -- "$REPORT_TMP" >"$REPORT_TMP".sorted || return $?
  local VAL="${CFG[scan_tags_report_prepend]}"
  >"$REPORT_TMP" || return $?
  [ -z "$VAL" ] || echo "$VAL" >>"$REPORT_TMP" || return $?
  VAL="${CFG[scan_tags_report_tabwidth]:-16}"
  [ "$VAL" == 0 ] || echo "# -*- coding: utf-8, tab-width: $VAL -*-" \
    >>"$REPORT_TMP" || return $?
  cat -- "$REPORT_TMP".sorted >>"$REPORT_TMP" || return $?
  rm -- "$REPORT_TMP".sorted || return $?

  "${CFG[scan_tags_refine_tmp]:-true}" "$REPORT_TMP" || return $?

  "$DIFF" -sU 2 -- "$REPORT_DEST" "$REPORT_TMP" || true
  mv --no-target-directory --verbose \
    -- "$REPORT_TMP" "$REPORT_DEST" || return $?
}


function scan_all_tags__write_info_dict () {
  local PRIO= KEY= VAL= MANDATORY= BUF=

  # Assemble column priorities in VAL:
  for KEY in $*; do case "$KEY" in
    '<'* ) PRIO+=" ${KEY:1}";;
    * ) VAL+=" $KEY";;
  esac; done
  MANDATORY="${CFG[scan_tags_version_field]:-modver} tag| commit|"
  for KEY in $MANDATORY; do case " $PRIO $VAL " in
    *" $KEY! "* ) ;;
    *" $KEY "* ) ;;
    * ) PRIO+=" $KEY";;
  esac; done

  for KEY in $PRIO $VAL; do
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








[ "$1" == --lib ] && return 0; scan_all_tags "$@"; return $?
