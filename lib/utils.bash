#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/gitpod-io/openvscode-server"
TOOL_NAME="openvscode-server"
TOOL_TEST="openvscode-server --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if openvscode-server is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  # Change this function if openvscode-server has other means of determining installable versions.
  #
  # Old release tags start with a number like '1.48.2' and don't contain prebuilt binaries
  #
  # Starting from version 1.60.0, release tags look like 'openvscode-server-v1.60.0':
  # - prebuilt binaries are provided
  # - bin/openvscode-server needs to be replaced with server.sh
  # - after replacing, bin/openvscode-server needs to be adjusted (for the location change)
  #
  # Starting from version 1.64.0 (right now still an insiders build):
  # - bin/openvscode-server is ready to use out of the box
  # - server.sh has been removed
  #
  list_github_tags | grep 'openvscode-server-v[0-9]' | sed -e 's/^openvscode-server-v//'
}

download_release() {
  local version="$1"
  local filename="$2"

  local uname_s="$(uname -s)"
  local uname_m="$(uname -m)"
  local os arch

  case "$uname_s" in
  # FreeBSD) os="freebsd" ;;
  # Darwin) os="darwin" ;;
  Linux) os="linux" ;;
  *) fail "OS not supported: $uname_s" ;;
  esac

  case "$uname_m" in
  # i?86) arch="386" ;;
  x86_64) arch="x64" ;;
  aarch64) arch="arm64" ;;
  armv8l) arch="arm64" ;;
  arm64) arch="arm64" ;;
  armv7l) arch="armhf" ;;
  *) fail "Architecture not supported: $uname_m" ;;
  esac

  local url="$GH_REPO/releases/download/openvscode-server-v${version}/openvscode-server-v${version}-${os}-${arch}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
