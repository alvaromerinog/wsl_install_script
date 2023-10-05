#!/bin/bash
# Script to install and configure pyenv
# install and configure the powerlevel10k terminal theme.
# Install other tools like fzf or aws tooling

function install-pyenv() {
    sudo  -y
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc
    if [ -f ~/.zshrc ]; then
        echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshhrc
        echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshhrc
        echo 'eval "$(pyenv init -)"' >> ~/.zshhrc
    fi
}

function install-virtualenvwrapper() {
    sudo apt install virtualenvwrapper -y
    echo -e '\nsource /usr/share/virtualenvwrapper/virtualenvwrapper.sh' >> ~/.bashrc
    if [ -f ~/.zshrc ]; then
        echo -e '\nsource /usr/share/virtualenvwrapper/virtualenvwrapper.sh' >> ~/.zshrc
    fi
}

function install-awscli() {
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    sudo rm -r ./awscliv2.zip
}

function install-awssam() {
    wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
    unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
    sudo ./sam-installation/install
    sudo rm -r aws-sam-cli-linux-x86_64.zip ./sam-installation
}

function install-powerlevel10k() {
    sudo apt install zsh -y
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    sed -i "s#robbyrussell#powerlevel10k/powerlevel10k#1" ~/.zshrc

    mkdir ~/.fonts
    curl -L -O https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -L -O https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -L -O https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    curl -L -O https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    mv *.ttf ~/.fonts
    fc-cache -fv
}

function install-fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    cd ~/.fzf/
    ./install
    cd
}

sudo apt update
# Install basic tooling
sudo apt install git curl zip unzip jq -y
echo "Select an option:"
select choice in "Install everything" "Install pyenv" "Install VirtualEnvWrapper" "Install Fzf" "Install AWSCLI2" "Install AWS SAM" "Install Powerlevel10k" "Fix APT PKG" "Exit"
do
    case $choice in
        "Install everything")
            echo "Installing and configuring everything..."
            install-pyenv
            install-virtualenvwrapper
            install-fzf
            install-awscli
            install-awssam
            install-powerlevel10k
            ;;
        "Install pyenv)
            echo "Installing and configuring pyenv..."
            install-pyenv
            ;;
        "Install VirtualEnvWrapper")
            echo "Installing and configuring VirtualEnvWrapper..."
            install-virtualenvwrapper
            ;;
        "Install Fzf")
            echo "Installing and configuring Fzf..."
            install-fzf
            ;;
        "Install AWSCLI2")
            echo "Installing awscli 2 and dependencies..."
            install-awscli
            ;;
        "Install AWS SAM")
            echo "Installing AWS SAM and dependencies..."
            install-awssam
            ;;
        "Install Powerlevel10k")
            echo "Installing and configuring powerlevel10k..."
            install-powerlevel10k
            ;;
        "Fix APT PKG")
            echo "Fixing APT PKG..."
            fix-apt_pkg
            ;;
        "Exit")
            echo "My job here is done."
            break
            ;;
        *)
            echo "Unknown option"
            ;;
    esac
done
