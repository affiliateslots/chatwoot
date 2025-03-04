sudo dpkg --configure -a

apt update && apt upgrade

sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

swapon --show
free -h


./install.sh --install




sudo rm /etc/apt/sources.list.d/pgdg.list