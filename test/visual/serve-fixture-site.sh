#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/../helpers/prepare_fixture_source.sh"

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <port> <baseurl>" >&2
  exit 64
fi

port="$1"
baseurl="$2"
repo_root="$(git rev-parse --show-toplevel)"
tmp_dir="$(mktemp -d)"
tmp_source="${tmp_dir}/source"
server_pid=""

cleanup() {
  if [ -n "${server_pid}" ] && kill -0 "${server_pid}" >/dev/null 2>&1; then
    kill "${server_pid}"
    wait "${server_pid}" || true
  fi
  rm -rf "${tmp_dir}"
}
trap cleanup EXIT INT TERM

prepare_fixture_source "${tmp_source}"
cp "${repo_root}"/test/fixtures/visual/posts/*.md "${tmp_source}/_posts/"

bundle exec jekyll serve --source "${tmp_source}" --host 127.0.0.1 --port "${port}" --baseurl "${baseurl}" --quiet &
server_pid="$!"
wait "${server_pid}"
