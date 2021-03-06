#!/usr/bin/env bats

load test_helper

@test "detects the shell" {
  SHELL=/bin/false run basher-init - bash
  assert_success
  assert_line 0 'export BASHER_SHELL=bash'
}

@test "exports BASHER_ROOT" {
  BASHER_ROOT=/lol run basher-init - bash
  assert_success
  assert_line 1 'export BASHER_ROOT=/lol'
}

@test "adds cellar/bin to path" {
  run basher-init - bash
  assert_success
  assert_line 2 'export PATH="$BASHER_ROOT/cellar/bin:$PATH"'
}

@test "setup shell completions if available" {
  mkdir -p "$BASHER_ROOT/completions"
  touch "$BASHER_ROOT/completions/basher.fakesh"
  run basher-init - fakesh
  assert_success
  assert_line 3 'source "$BASHER_ROOT/completions/basher.fakesh"'
}

@test "does not setup shell completions if not available" {
  mkdir -p "$BASHER_ROOT/completions"
  touch "$BASHER_ROOT/completions/basher.other"
  run basher-init - fakesh
  assert_success
  refute_line 'source "$BASHER_ROOT/completions/basher.fakesh"'
  refute_line 'source "$BASHER_ROOT/completions/basher.other"'
}

@test "sources require runtime" {
  run basher-init -
  assert_success
  assert_line 'source "$BASHER_ROOT/runtime/require.bash"'
}

