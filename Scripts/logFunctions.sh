#!/usr/bin/env zsh

function logStep {
  message=$1
  messageContent="------- $message -------"
  messageLength=${#messageContent}
  separator=""
  for (( i=0; i<${messageLength}; i++ )); do
    separator="$separator-"
  done
  echo -e "\e[92m$separator\e[0m"
  echo -e "\e[92m$messageContent\e[0m"
  echo -e "\e[92m$separator\e[0m"
}

function logError {
  message=$1
  echo -e "\e[91m------- $message -------\e[0m"
}
