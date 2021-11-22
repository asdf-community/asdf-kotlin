#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

GH_REPO="https://github.com/JetBrains/kotlin"
TOOL_NAME="kotlin"
TOOL_TEST="kotlin -help"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kotlin is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/v.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename url
  version="$1"
  filename="$2"

  url="$GH_REPO/releases/download/v${version}/$TOOL_NAME-compiler-${version}.zip"

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
    test -x "${install_path}/kotlinc/bin/${tool_cmd}" || fail "Expected ${install_path}/kotlinc/bin/${tool_cmd} to be executable."
    if [[ -d "${install_path}/kotlin-native" ]]; then
      test -x "${install_path}/kotlin-native/bin/${tool_cmd}c-native" || fail "Expected ${install_path}/kotlin-native/bin/${tool_cmd}c-native to be executable."
    fi

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}

# the releases page version does not line up with the kotlin version
# so fetch the native-x.y.z version from the releases page
get_native_download_path() {
  local check_url="${GH_REPO}/releases/tag/v${ASDF_INSTALL_VERSION}"
  local grep_option="$(get_grep_options)"
  local tempdir="$(create_temp_dir)"
  local check_regex="/JetBrains/kotlin/releases/download/v${ASDF_INSTALL_VERSION}/$(get_native_regex_pattern)"
  local temp_html="${tempdir}/github-kotlin.html"
  curl -s --disable "${check_url}" -o "${temp_html}"
  local native_download_path=""
  if grep -q ${grep_option} "${check_regex}" "${temp_html}"; then
    native_download_path=$(grep ${grep_option} "${check_regex}" "${temp_html}" | cut -f2 -d '"')
  fi
  rm -rf "${tempdir}"
  echo "${native_download_path}"
}

get_kernel() {
  local kernel_name="$(uname)"
  case "${kernel_name}" in
  Linux)
    echo -n 'linux'
    ;;
  Darwin)
    echo -n 'macos'
    ;;
  *)
    fail "Sorry, ${kernel_name} is not supported."
    ;;
  esac
}

get_arch() {
  local machine_hw_name="$(uname -m)"
  case "${machine_hw_name}" in
  x86_64)
    echo -n 'x86_64'
    ;;
  aarch64 | arm64)
    echo -n 'aarch64'
    ;;
  *)
    fail "Sorry, ${machine_hw_name} is not supported."
    ;;
  esac
}

get_grep_options() {
  case "$(get_kernel)" in
  linux)
    echo -n '-P'
    ;;
  macos)
    /bin/echo -n '-E'
    ;;
  esac
}

get_native_regex_pattern() {
  echo -n "kotlin-native-(prebuilt-)?$(get_kernel)-($(get_arch)-)?\d+\.\d+\.\d+[^.]*.tar.gz"
}

create_temp_dir() {
  case "$(get_kernel)" in
  linux)
    echo -n "$(mktemp -dt asdf-kotlin-native.XXXX)"
    ;;
  macos)
    echo -n "$(/usr/bin/mktemp -dt asdf-kotlin-native)"
    ;;
  esac
}
