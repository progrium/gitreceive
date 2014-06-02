
teardown() {
  rm -rf /home/git
  userdel git
}

@test "gitreceive init creates git user ready for pushes" {
  gitreceive init
  [[ -d /home/git ]]
  [[ -f /home/git/.ssh/authorized_keys ]]
  [[ -f /home/git/receiver ]]
  [[ "git" == "$(ls -l /home/git/receiver | awk '{print $3}')" ]]
}

@test "gitreceive receiver script gets tar of pushed repo" {
  gitreceive init
  cat /root/.ssh/id_rsa.pub | gitreceive upload-key test
  local output_dir="$BATS_TMPDIR/$BATS_TEST_NAME-push"
  mkdir -p "$output_dir"
  chown git "$output_dir"
  cat <<EOF > /home/git/receiver
#!/bin/bash
set -x
tar -C $output_dir -xvf - 
EOF
  local input_repo="$BATS_TMPDIR/$BATS_TEST_NAME-repo"
  mkdir -p "$input_repo"
  cd "$input_repo"
  git init
  echo "foobar" > contents
  git add .
  git commit -m 'only commit'
  git remote add test git@localhost:test-$BATS_TEST_NUMBER
  git push test master
  [[ -f "$output_dir/contents" ]]
  [[ "foobar" == $(cat "$output_dir/contents") ]]
}
