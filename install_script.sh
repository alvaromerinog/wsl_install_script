#!/bin/bash
# Script to install and configure python 3.7 in Ubuntu 20.04 and 
# install and configure the powerlevel10k terminal theme. 


function install-python3.7() {
    sudo apt update
    sudo apt install python -y
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:deadsnakes/ppa -y
    sudo apt install python3.7 -y
    sudo apt autoremove -y

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2

    sudo update-alternatives --set python /usr/bin/python3.7

    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.7 1
    sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2

    sudo update-alternatives --set python3 /usr/bin/python3.7

    sudo apt install pip -y
}

function install-powerlevel10k() {
    sudo apt update
    sudo apt install zsh git curl -y
    sudo apt autoremove -y
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

    zsh
}

function install-virtualenvwrapper() {
    sudo apt install virtualenvwrapper -y
    echo -e '\nsource /usr/share/virtualenvwrapper/virtualenvwrapper.sh' >> ~/.bashrc
    if [ -f ~/.zshrc ]; then
        echo -e '\nsource /usr/share/virtualenvwrapper/virtualenvwrapper.sh' >> ~/.zshrc
    fi
}

function install-fzf() {
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    cd ~/.fzf/
    ./install
}

function install-awscli() {
    sudo apt update
    sudo apt install curl zip unzip jq -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    sudo rm -r ./awscliv2.zip
    sudo rm -r ./aws
}

function fix-apt_pkg() {
    sudo apt remove python3-apt
    sudo apt autoremove -y
    sudo apt autoclean -y
    sudo apt install python3-apt
}

echo "Select an option:"
select choice in "Install everything" "Install Python 3.7" "Install VirtualEnvWrapper" "Install Fzf" "Install AWSCLI2"  "Install Powerlevel10k" "Fix APT PKG" "Exit"
do
    case $choice in
        "Install everything")
            echo "Installing and configuring everything..."
            install-python3.7
            install-virtualenvwrapper
            install-fzf
            install-awscli
            install-powerlevel10k
            ;;
        "Install Python 3.7")
            echo "Installing and configuring Python 3.7..."
            install-python3.7
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