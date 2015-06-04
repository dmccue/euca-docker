#!/bin/bash

# Install dependencies
which brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew cask install vagrant
brew install python bats ansible boot2docker

# Retrieve eucalyptus ansible playbook
[ -d playbook ] || git clone https://github.com/eucalyptus/playbook playbook
cd playbook; git pull; cd ..
cp -f playbook.yml playbook/