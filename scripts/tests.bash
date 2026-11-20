#!/usr/bin/env bash
set -eo pipefail
IFS=$'\n\t'

# Legacy Kotlin/Native (1.3.21, 1.4.30-RC, 1.5.30-M1) rejects JDK >= 25
# in its bundled IntelliJ JavaVersion parser. Keep those tests on JDK 21.
JAVA_LEGACY_VERSION='temurin-21.0.13+9.0.LTS'
JAVA_CURRENT_VERSION='temurin-25.0.5+8.0.LTS'
# CI supplies these from actions/setup-java outputs; local runs use `asdf where`.
JAVA_LEGACY_HOME="${JAVA_LEGACY_HOME:-}"
JAVA_CURRENT_HOME="${JAVA_CURRENT_HOME:-}"
ANSI_NO_COLOR=$'\033[0m'
THIS_SCRIPT=$(basename "${0}")

function usage() {
  msg_info "Usage:"
  msg_info "${THIS_SCRIPT}"
  echo
  msg_info "Run kotlin tests"
  exit 1
}

function msg_info() {
  local GREEN=$'\033[0;32m'
  printf "%s\n" "${GREEN}${*}${ANSI_NO_COLOR}" >&2
}

function msg_warn() {
  local YELLOW=$'\033[0;33m'
  printf "%s\n" "${YELLOW}${*}${ANSI_NO_COLOR}" >&2
}

function msg_error() {
  local RED=$'\033[0;31m'
  printf "%s\n" "${RED}${*}${ANSI_NO_COLOR}" >&2
}

function msg_fatal() {
  msg_error "${*}"
  exit 1
}

function return_non_empty_array() {
  declare -a INPUT
  # https://stackoverflow.com/questions/7577052/bash-empty-array-expansion-with-set-u
  INPUT=("${@+"${@}"}")
  if [[ ${#INPUT[@]} -ne 0 ]]; then
    printf "%s\n" "${INPUT[@]}"
  fi
}

function install_requirements() {
  if ! asdf plugin list | grep -qx 'java'; then
    asdf plugin add java https://github.com/halcyon/asdf-java.git
  fi
  msg_info "Will try to install java's ${JAVA_LEGACY_VERSION} and ${JAVA_CURRENT_VERSION}"
  asdf install java "${JAVA_LEGACY_VERSION}"
  asdf install java "${JAVA_CURRENT_VERSION}"
  asdf set java "${JAVA_CURRENT_VERSION}"
}

function get_java_home() {
  local version="${1}"
  local java_home=""
  case "${version}" in
    "${JAVA_LEGACY_VERSION}") java_home="${JAVA_LEGACY_HOME}" ;;
    "${JAVA_CURRENT_VERSION}") java_home="${JAVA_CURRENT_HOME}" ;;
    *) msg_fatal "Unknown java version: ${version}" ;;
  esac
  if [[ -z ${java_home} ]]; then
    java_home="$(asdf where java "${version}")"
  fi
  if [[ ! -x "${java_home}/bin/java" ]]; then
    msg_fatal "Java executable not found at ${java_home}/bin/java"
  fi
  printf '%s\n' "${java_home}"
}

function get_tool_version() {
  local TOOL="${1}"
  awk '{ print $2 }' <(grep "${TOOL}" "${HOME}"/.tool-versions)
}

function set_kotlin_version() {
  local KOTLIN_VERSION="${1}"
  msg_warn "Setting kotlin ${KOTLIN_VERSION} as the default value in ${HOME}/.tool-versions"
  asdf set kotlin "${KOTLIN_VERSION}"
}

function confirm_kotlin_version() {
  local KOTLIN_VERSION="${1}"
  declare -a KOTLIN_ARGS=('kotlin' '-version') KOTLINC_ARGS=('kotlinc-native' '-version')
  msg_warn 'Listing kotlin binaries in PATH'
  type -a kotlin
  msg_warn 'Printing kotlin binary used when called'
  type -P kotlin
  msg_warn "Confirming version ${KOTLIN_VERSION}"
  grep "^Kotlin version ${KOTLIN_VERSION}" <("${KOTLIN_ARGS[@]}" 2>&1)
  if [[ ${KOTLIN_VERSION} != '1.0.3' ]]; then
    if [[ ${KOTLIN_VERSION} == '1.3.21' ]]; then
      grep '^Kotlin/Native: 1.1.2' <("${KOTLINC_ARGS[@]}" 2>&1)
    else
      grep -i "^Kotlin/Native: ${KOTLIN_VERSION}" <("${KOTLINC_ARGS[@]}" 2>&1)
    fi
  fi
}

function test_kotlin_version() {
  local KOTLIN_VERSION="${1}"
  local JAVA_VERSION="${2:-${JAVA_CURRENT_VERSION}}"
  local java_home
  java_home="$(get_java_home "${JAVA_VERSION}")"
  export JAVA_HOME="${java_home}"
  set_kotlin_version "${KOTLIN_VERSION}"
  msg_warn "java version is $("${JAVA_HOME}/bin/java" -version 2>&1)"
  confirm_kotlin_version "${KOTLIN_VERSION}"
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
    -h | --help)
      usage
      ;;
    -*)
      echo "Unknown option ${1}"
      usage
      ;;
  esac
done

if [[ -z ${GITHUB_ACTIONS:-""} ]]; then
  GITHUB_ACTIONS='false'
fi

msg_info "GITHUB_EVENT_NAME is ${GITHUB_EVENT_NAME}"
msg_info "GITHUB_REF_NAME is ${GITHUB_REF_NAME}"
msg_info "GITHUB_SHA is ${GITHUB_SHA}"
msg_info "GITHUB_ACTIONS is ${GITHUB_ACTIONS}"
if [[ ${GITHUB_ACTIONS} == 'true' ]]; then
  msg_info "GITHUB_RUN_NUMBER is ${GITHUB_RUN_NUMBER}"
  msg_info "GITHUB_RUN_ATTEMPT is ${GITHUB_RUN_ATTEMPT}"
fi

if [[ ${GITHUB_ACTIONS} != 'true' ]]; then
  install_requirements
fi
msg_info "Running asdf version $(asdf version)"
msg_warn 'Trying to list all versions of kotlin'
asdf list all kotlin
msg_info 'Will try to install kotlin 1.0.3 (version without kotlin native)'
asdf install kotlin '1.0.3'
msg_info 'Will try to install kotlin 1.3.21 (version with kotlin native)'
asdf install kotlin '1.3.21'
msg_info 'Will try to install kotlin 1.4.30-RC (version with new kotlin native naming)'
asdf install kotlin '1.4.30-RC'
msg_info 'Will try to install kotlin 1.5.30-M1 (version with MacOS aarch64 kotlin native)'
asdf install kotlin '1.5.30-M1'
msg_info 'Will try to install kotlin latest version'
asdf install kotlin 'latest' | tee -a kotlin-latest.out
LATEST_VERSION="$(grep 'installation was successful' kotlin-latest.out | awk '{ print $2 }')"
rm kotlin-latest.out
msg_info 'Will test versions now'
test_kotlin_version '1.0.3' "${JAVA_LEGACY_VERSION}"
test_kotlin_version '1.3.21' "${JAVA_LEGACY_VERSION}"
test_kotlin_version '1.4.30-RC' "${JAVA_LEGACY_VERSION}"
test_kotlin_version '1.5.30-M1' "${JAVA_LEGACY_VERSION}"
test_kotlin_version "${LATEST_VERSION}" "${JAVA_CURRENT_VERSION}"
