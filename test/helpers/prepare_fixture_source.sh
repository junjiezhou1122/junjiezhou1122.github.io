#!/usr/bin/env bash

prepare_fixture_source() {
  if [ "$#" -ne 1 ]; then
    echo "prepare_fixture_source expects exactly one target directory" >&2
    return 64
  fi

  local target="$1"
  local repo_root
  repo_root="$(git rev-parse --show-toplevel)"

  if [ -e "${target}" ]; then
    echo "fixture source target already exists: ${target}" >&2
    return 1
  fi

  mkdir -p "${target}"
  git -C "${repo_root}" ls-files -z | tar -C "${repo_root}" --null -T - -cf - | tar -xf - -C "${target}"
  mkdir -p "${target}/_posts"
}
