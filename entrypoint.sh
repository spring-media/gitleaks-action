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
  echo gitleaks --path=$GITHUB_WORKSPACE -v $CONFIG --report=gitleaks-report.json
  CAPTURE_OUTPUT=$(gitleaks --path=$GITHUB_WORKSPACE -v $CONFIG)

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
