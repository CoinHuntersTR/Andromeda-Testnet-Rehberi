#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi
sleep 1 && curl -s https://raw.githubusercontent.com/CoinHuntersTR/Andromeda-Testnet-Rehberi/main/logo.sh | bash && sleep 1

NODE=ANDROMEDA
NODE_HOME=$HOME/.andromedad
BRANCH=galileo-3-v1.1.0-beta1
GIT="https://github.com/andromedaprotocol/andromedad.git"
GIT_FOLDER=andromedad
BINARY=andromedad
GENESIS="https://raw.githubusercontent.com/andromedaprotocol/testnets/galileo-3/genesis.json"
ADDRBOOK="https://snapshot.yeksin.net/andromeda/addrbook.json"
CHAIN_ID=galileo-3
echo 'export CHAIN_ID='\"${CHAIN_ID}\" >> $HOME/.bash_profile

if [ ! $VALIDATOR ]; then
    read -p "Enter validator name: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1
cd $HOME
sudo apt update
sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu bsdmainutils htop -y < "/dev/null"

echo -e '\n\e[42mInstall Go\e[0m\n' && sleep 1
cd $HOME
if [ ! -f "/usr/local/go/bin/go" ]; then
    VERSION=1.19.6
    wget -O go.tar.gz https://go.dev/dl/go$VERSION.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go.tar.gz && rm go.tar.gz
    echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
    echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
    echo 'export GO111MODULE=on' >> $HOME/.bash_profile
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
    go version
fi

echo -e '\n\e[42mInstall software\e[0m\n' && sleep 1
rm -rf $HOME/$GIT_FOLDER
git clone $GIT
cd $GIT_FOLDER && git checkout $BRANCH
make build
sudo mv $HOME/$GIT_FOLDER/build/$BINARY /usr/local/bin/ || exit
sleep 1
$BINARY init "$VALIDATOR" --chain-id $CHAIN_ID
SEEDS="e711b6631c3e5bb2f6c389cbc5d422912b05316b@seed.ppnv.space:37256,5cfce64114f98e29878567bdd1adbebe18670fc6@andromeda-testnet-seed.itrocket.net:443"
PEERS="c043b90a737b92b26b39c52c502d7468dc6b1481@46.0.203.78:22258,9d058b4c4eb63122dfab2278d8be1bf6bf07f9ef@65.109.86.236:26656,7ac17e470c16814be55aa02a1611b23a3fba3097@75.119.141.16:26656,c5f6021d8da08ff53e90725c0c2a77f8d65f5e03@195.201.195.40:26656,bcdd1b337504f2d3523f6d63a7de1a2641187908@154.26.130.175:26656,1d94f397352dc20be4b56e4bfd9305649cbac778@65.108.232.150:20095,749114faeb62649d94b8ed496efbdcd4a08b2e3e@136.243.93.134:20095"
sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $NODE_HOME/config/config.toml
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $NODE_HOME/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $NODE_HOME/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $NODE_HOME/config/config.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uandr\"/" $NODE_HOME/config/app.toml

wget $GENESIS -O $NODE_HOME/config/genesis.json

$BINARY tendermint unsafe-reset-all

wget $ADDRBOOK -O $NODE_HOME/config/addrbook.json
curl -L https://snapshot.yeksin.net/andromeda/data.tar.lz4 | lz4 -dc - | tar -xf - -C $NODE_HOME

echo -e '\n\e[42mRunning\e[0m\n' && sleep 1
echo -e '\n\e[42mCreating a service\e[0m\n' && sleep 1

echo "[Unit]
Description=$NODE Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/usr/local/bin/$BINARY start
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target" > $HOME/$BINARY.service
sudo mv $HOME/$BINARY.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
echo -e '\n\e[42mRunning a service\e[0m\n' && sleep 1
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
sudo systemctl enable $BINARY
sudo systemctl restart $BINARY

echo -e '\n\e[42mCheck node status\e[0m\n' && sleep 1
if [[ `service $BINARY status | grep active` =~ "running" ]]; then
  echo -e "Your $NODE node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice $BINARY status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your $NODE node \e[31mwas not installed correctly\e[39m, please reinstall."
fi
