#!/bin/bash


install_golang()
{
	chk1=`dpkg -l | grep 'golang'`
	if [ -z "$chk1" ]; then
		echo "Go language Install ..."
		sudo add-apt-repository ppa:longsleep/golang-backports -y
		sudo apt update && sudo apt install golang-go -y
	else
		echo -e "\n\nGolang already installed"
  fi
}

install_nvm()
{
	echo "NVM Install"
	version=$(curl -sS https://github.com/nvm-sh/nvm/tags | grep 'href="/nvm-sh/nvm/releases/tag/' | head -n 1 | grep -oe '[^ /]*$' | grep -oe '[^ \">]*')

	echo "NodeJS Install"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$version/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

	echo "Active Nodejs"
	source ~/.bashrc && nvm install node
}

install_docker()
{
  chk1=`dpkg -l | grep 'docker'`
  if [ -z "$chk1" ]; then
    echo "Docker Install Start..."
    sudo apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo usermod -aG docker $USER
  else
    echo -e "\n\nDocker Already Installed."
  fi
}

install_compose()
{
  chk2=`ls /usr/local/bin | grep 'docker-compose'`
  compose_version=$(curl -sS https://docs.docker.com/compose/install/ | grep 'https://github.com/docker/compose/releases/download/' | head -n 1 | grep -Po '(?<=download/)[^;/]+')
  if [ -z "$chk2" ];  then
      if [ "$osname" == "CoreOS" ];then
        sudo mkdir -p /opt/bin
        sudo curl -L "https://github.com/docker/compose/releases/download/1.9.0/docker-compose-$(uname -s)-$(uname -m)" -o /opt/bin/docker-compose
        sudo chmod +x /opt/bin/docker-compose
      else
        echo "Docker-Compose Install Start..."
        # Docker Compose Install
        sudo curl -L "https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
      fi
    else
      echo -e "\n\nDocker-Compose Already Installed.\n"
    fi

}

echo "dependency install"
sudo apt update && sudo apt install -y \
	curl \
	python \
	python-pip \
	python-dev \
	python3-dev \
	libssl-dev \
	libltdl-dev \
	make \
	gcc \
	g++ \
	libtool \
	tree \
	git


install_golang
install_nvm
install_docker
install_compose

echo -e "\e[32m docker version: " $(docker --version)
echo -e "\e[32m docker compose version: " $(docker-compose --version)
echo -e "\e[32m NVM version: " $(nvm --version)
echo -e "\e[32m NodeJS version: " $(node --version)
echo -e "\e[32m NPM version: " $(npm --version)
echo -e "\e[32m Go version: " $(go version)
echo -e "\e[32m Python version: " $(python --version)
