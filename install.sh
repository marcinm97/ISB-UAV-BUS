#!/bin/bash
if [ ! -x "$(command -v docker)" ]
    then
    if [ -x "$(command -v pacman)" ]
        then
        sudo pacman -S docker
    elif [ -x "$(command -v apt-get)" ]
        then
        sudo apt-get install docker
    elif [ -x "$(command -v dnf)" ]
        then
        sudo dnf install docker
    fi
    sudo groupadd docker
    sudo usermod -aG docker $(whoami)
    sudo systemctl enable --now docker
else
    echo "Docker found"
fi
chmod +x builder.sh
chmod +x docker_builder.sh
sudo docker pull thematiq/solar-bus:3
echo "========================================="
echo "Docker installation prepared"
echo "Please relog/reboot before using builder.sh"
echo "Run ./builder.sh to build project"