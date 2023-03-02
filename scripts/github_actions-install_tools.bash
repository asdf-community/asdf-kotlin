#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

function retry_command() {
  # Source: https://github.com/aws-quickstart/quickstart-linux-utilities/blob/master/quickstart-cfn-tools.source#L413-L433
  # $1 = NumberOfRetries $2 = Command
  # retry_command 10 some_command.sh
  # Command will retry with linear back-off
  local -r __tries="${1}"
  shift
  declare -a __run=("${@}")
  local -i __backoff_delay=2
  local __current_try=0
  until "${__run[@]}"; do
    if ((__current_try == __tries)); then
      echo "Tried ${__current_try} times and failed!"
      return 1
    else
      echo "Retrying ...."
      sleep $(((__backoff_delay++) + (__current_try++)))
    fi
  done
}

function get_arch() {
  case "$(uname -m)" in
  armv5*) echo -n "armv5" ;;
  armv6*) echo -n "armv6" ;;
  armv7*) echo -n "armv7" ;;
  aarch64) echo -n "arm64" ;;
  x86) echo -n "386" ;;
  x86_64) echo -n "amd64" ;;
  i686) echo -n "386" ;;
  i386) echo -n "386" ;;
  esac
}

function get_os() {
  local kernel_name
  kernel_name="$(uname)"
  case "${kernel_name}" in
  Linux)
    echo -n 'linux'
    ;;
  Darwin)
    echo -n 'macos'
    ;;
  *)
    echo "Sorry, ${kernel_name} is not supported." >&2
    exit 1
    ;;
  esac
}

retry=3

echo "Install detect-secrets"

retry_command "${retry}" 'bash' '-c' 'pip install detect-secrets'

hash -r
