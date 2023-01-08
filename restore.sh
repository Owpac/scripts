#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Restore
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon ♻️

# Documentation:
# @raycast.author owpac

BREW_PATH=$HOME/.brew
BACKUP_PATH=$HOME/Backup

# Check if stdout is a terminal
if test -t 1; then

  # Check if it supports colors
  ncolors=$(tput colors)

  if test -n "$ncolors" && test $ncolors -ge 8; then
    bold="$(tput bold)"
    underline="$(tput smul)"
    standout="$(tput smso)"
    normal="$(tput sgr0)"
    black="$(tput setaf 0)"
    red="$(tput setaf 1)"
    green="$(tput setaf 2)"
    yellow="$(tput setaf 3)"
    blue="$(tput setaf 4)"
    magenta="$(tput setaf 5)"
    cyan="$(tput setaf 6)"
    white="$(tput setaf 7)"
  fi
fi

# Setup script for setting up a new macos machine
echo "${blue}>>> ${yellow}Starting installation.${normal}"

# 1. Installing dev tools or upgrading them if outdated
xcode-select --install >/dev/null 2>&1

if [ $? = 0 ]; then
  echo "${blue}>>> ${yellow}Installing Command Line Tools...${normal}"
else
  echo "${blue}>>> ${yellow}Command Line Tools already installed.${normal}"
  echo "${blue}>>> ${yellow}Installing software updates...${normal}"
  softwareupdate -ia
fi

# 2. Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
  echo "${blue}>>> ${yellow}Installing Homebrew...${normal}"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 3. Installing Oh My ZSH
if [ -d $HOME/.oh-my-zsh ]; then
  echo "${blue}>>> ${yellow}OMZ is already installed.${normal}"
  echo "${blue}>>> ${yellow}Updating OMZ...${normal}"
  omz update
else
  echo "${blue}>>> ${yellow}Installing OMZ...${normal}"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  echo "${blue}>>> ${yellow}Installing OMZ external plugins...${normal}"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoupdate
fi

# 4. Installing necessary apps
brew update
echo "${blue}>>> ${yellow}Installing 1Password...${normal}"
brew install --cask 1password
brew install --cask 1password-cli
echo "${blue}>>> ${yellow}Configuring 1Password...${normal}"
#op account add --address my.1password.com --email thomas.faugier@gmail.com --signin
echo "${blue}>>> ${yellow}Installing Google Drive...${normal}"
brew install --cask google-drive
echo "${blue}>>> ${yellow}Installing mackup...${normal}"
brew install mackup

# 5. Configuring temporary SSH
# if [ -d $HOME/.ssh ]; then
#   echo "${blue}>>> ${yellow}SSH keys already configured.${normal}"
# else
#   echo "${blue}>>> ${yellow}Exporting SSH socket in CLI session...${normal}"
#   export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
# fi

# 6. Cloning repository
# if [ -d $DOTFILES_PATH ]; then
#   cd $DOTFILES_PATH
#   echo "${blue}>>> ${yellow}Updating dotfiles repository...${normal}"
#   git pull >/dev/null 2>&1
# else
#   echo "${blue}>>> ${yellow}Cloning dotfiles repository...${normal}"
#   git clone git@github.com:Owpac/dotfiles.git $DOTFILES_PATH
# fi

# 6. Check if drive is configured
if [ -d $BACKUP_PATH ]; then
  echo "${blue}>>> ${yellow}Backup files detected...${normal}"
else
  echo "${blue}>>> ${yellow}You need to configure Google Drive first.${normal}"
  exit
fi

# 7. Restoring configs & apps
echo "${blue}>>> ${yellow}Restoring configs...${normal}"
cp $BACKUP_PATH/.mackup.cfg $HOME
mackup restore

echo "${blue}>>> ${yellow}Installing Brew apps...${normal}"
brew bundle --file "$BREW_PATH"/Brewfile

echo "${blue}>>> ${yellow}Cleaning up...${normal}"
brew autoremove
brew cleanup

echo "${blue}>>> ${yellow}Macbook setup completed!${normal}"