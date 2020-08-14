#!/usr/bin/env zsh

SCRIPTS_FOLDER=$(dirname $0)
source $SCRIPTS_FOLDER/logFunctions.sh

if [[ ! -x "$(which rvm)" ]]; then
  logError "rvm not installed"
  echo "Install RVM from https://rvm.io"
	exit -1
fi

if [[ ! -x "$(which brew)" ]]; then
	logError "brew not installed"
  echo "Install Homebrew from https://brew.sh"
	exit -1
fi

if [[ ! -x "$(which mint)" ]]; then
  logStep "Installing mint using brew"
  brew install mint
fi

logStep "Starting setup"

RUBY_VERSION=$(cat .ruby-version)

if [[ ! $(rvm list | grep $RUBY_VERSION) ]]; then
  logStep "Installing ruby version with RVM"
  rvm install $RUBY_VERSION
fi

/bin/bash -l -c "rvm use $RUBY_VERSION"

logStep "Installing required ruby gems"
gem install bundler
bundle install

logStep "mint bootstrap"
mint bootstrap

CONFIGURATION_FOLDER="$SCRIPTS_FOLDER/../Restler-Example/Restler-Example/Configuration"
if [[ ! -f "$CONFIGURATION_FOLDER/Debug.xcconfig" ]]; then
  logStep "Creating configuration file"
  touch "$CONFIGURATION_FOLDER/Debug.xcconfig"
  cat "$CONFIGURATION_FOLDER/debug.xcconfig.tpl" > "$CONFIGURATION_FOLDER/Debug.xcconfig"
  echo "Debug.xcconfig created"
fi
