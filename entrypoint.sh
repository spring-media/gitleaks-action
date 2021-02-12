#!/bin/bash

CONFIG=""
# check if using gitleaks config or not
if [ -f "$GITHUB_WORKSPACE/.gitleaks.toml" ]
then
  CONFIG=" --config-path=$GITHUB_WORKSPACE/.gitleaks.toml"
fi

echo running gitleaks "$(gitleaks --version) with the following command👇"

if [ "$GITHUB_EVENT_NAME" = "push" ]
then
  echo gitleaks --path=$GITHUB_WORKSPACE -v --report=gitleaks-report.json $CONFIG
  CAPTURE_OUTPUT=$(gitleaks --path=$GITHUB_WORKSPACE -v --report=gitleaks-report.json $CONFIG)
elif [ "$GITHUB_EVENT_NAME" = "pull_request" ]
then 
  git --git-dir="$GITHUB_WORKSPACE/.git" log --left-right --cherry-pick --pretty=format:"%H" remotes/origin/$GITHUB_BASE_REF... > commit_list.txt
  echo gitleaks --path=$GITHUB_WORKSPACE --verbose --redact --commits-file=commit_list.txt $CONFIG
  CAPTURE_OUTPUT=$(gitleaks --path=$GITHUB_WORKSPACE --verbose --redact --commits-file=commit_list.txt $CONFIG)
fi
LEAKS_FOUND=$?

echo "$CAPTURE_OUTPUT"
echo "::set-output name=result::$CAPTURE_OUTPUT"
if [ $LEAKS_FOUND -eq 1 ]
then
  GITLEAKS_RESULT=$(echo -e "\e[31m🛑 STOP! Gitleaks encountered leaks")
  echo "$GITLEAKS_RESULT"
  echo "::set-output name=exitcode::$GITLEAKS_RESULT" 
  exit 1
else
  GITLEAKS_RESULT=$(echo -e "\e[32m✅ SUCCESS! Your code is good to go!")
  echo "$GITLEAKS_RESULT"
  echo "::set-output name=exitcode::$GITLEAKS_RESULT"
fi
