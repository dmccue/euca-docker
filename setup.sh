#!/bin/bash
echo
echo Installing dependencies...
which prlctl || {echo FATAL: Please install parallels; exit 1;}
which brew || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew cask install vagrant
brew install python bats ansible boot2docker

echo
echo Retrieving eucalyptus ansible playbook
[ -d playbook ] || git clone https://github.com/eucalyptus/playbook playbook
cd playbook; git pull; cd ..
cp -f playbook.yml playbook/