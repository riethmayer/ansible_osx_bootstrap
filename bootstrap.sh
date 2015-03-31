#!/bin/bash
# Purpose:
#	* bootstrap machine in order to prepare for ansible playbook run

set -e

# Download and install Command Line Tools if no developer tools exist
#       * previous evaluation didn't work completely, due to gcc binary existing for vanilla os x install
#       * gcc output on vanilla osx box:
#       * 'xcode-select: note: no developer tools were found at '/Applications/Xcode.app', requesting install.
#       * Choose an option in the dialog to download the command line developer tools'
#
# Evaluate 2 conditions
#       * ensure dev tools are installed by checking the output of gcc
#       * check to see if gcc binary even exists ( original logic )
# if either of the conditions are met, install dev tools
if [[ $(/usr/bin/gcc 2>&1) =~ "no developer tools were found" ]] || [[ ! -x /usr/bin/gcc ]]; then
    echo "checking for xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "ensure homebrew installed"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 
fi


# Download and install Ansible
if [[ ! -d $HOME/github/ansible ]]; then
  echo "ensure ansible is present and setup"
  git clone git://github.com/ansible/ansible.git --recursive $HOME/github/ansible
  cd $HOME/github/ansible
  source ./hacking/env-setup
fi

# Modify the PATH
# This should be subsequently updated in shell settings
export PATH=/usr/local/bin:$PATH

cd -
ansible-playbook riethmayer.yml
