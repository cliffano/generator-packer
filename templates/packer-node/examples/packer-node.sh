#!/usr/bin/env bash
set -o errexit
set -o nounset

printf "\n\n========================================\n"
printf "Run the built Docker image and verify its message transformation\n"

image="{{github_id}}/{{project_id}}:latest"
output="$(docker run --rm "$image" --message 'Hello Packer')"

expected_original="Original: Hello Packer"
expected_reverse="Reverse: rekcaP olleH"
expected_uppercase="Uppercase: HELLO PACKER"
expected_lowercase="Lowercase: hello packer"

check_output() {
  local label="$1" expected="$2"
  if [[ "$output" != *"$expected"* ]]; then
    printf "FAIL: %s - expected output to contain '%s', got:\n%s\n" "$label" "$expected" "$output"
    exit 1
  fi
  printf "OK: %s found in output\n" "$expected"
}

check_output "message_original" "$expected_original"
check_output "message_reverse" "$expected_reverse"
check_output "message_uppercase" "$expected_uppercase"
check_output "message_lowercase" "$expected_lowercase"
