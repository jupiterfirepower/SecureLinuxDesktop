#!/usr/bin/env bats

load test_helper

@test "Verify LOG_OK_LOGINS in $LOGINDEFS" {
  run bash -c "grep '^LOG_OK_LOGINS.*yes$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}

@test "Verify UMASK in $LOGINDEFS" {
  run bash -c "grep '^UMASK.*077$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}

@test "Verify PASS_MIN_DAYS in $LOGINDEFS" {
  run bash -c "grep '^PASS_MIN_DAYS.*7$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}

@test "Verify PASS_MAX_DAYS in $LOGINDEFS" {
  run bash -c "grep '^PASS_MAX_DAYS.*30$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}

@test "Verify DEFAULT_HOME in $LOGINDEFS" {
  run bash -c "grep '^DEFAULT_HOME no$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}

@test "Verify USERGROUPS_ENAB in $LOGINDEFS" {
  run bash -c "grep '^USERGROUPS_ENAB no$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}

@test "Verify SHA_CRYPT_MAX_ROUNDS in $LOGINDEFS" {
  run bash -c "grep '^SHA_CRYPT_MAX_ROUNDS.*10000$' $LOGINDEFS"
  [ "$status" -eq 0 ]
}
