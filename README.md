<h1 align="center">Andromeda Testnet Rehberi

## Andromeda Test ağında  validator kuruyoruz. Sağ üstten yıldızlayıp forklamayı unutmayalım. Sorularınız olursa: <a href="https://t.me/CoinHuntersTR/34102" target="_blank" rel="Coin Hunters TR" >Coin Hunters TR</a>

![image](https://miro.medium.com/v2/resize:fit:4800/format:webp/1*xC-wZV_HIWzLVEXWNNlsHQ.png)

## Sistem gereksinimleri:
NODE TİPİ | CPU     | RAM      | SSD     |
| ------------- | ------------- | ------------- | -------- |
| Ubuntu 20.04 |4          | 8         | 200  |
 

## Andromeda için önemli linkler:
- <a href="https://andromedaprotocol.io/" target="_blank">Website</a>
- <a href="https://andromeda.explorers.guru/" target="_blank">Explorer</a>
- <a href="https://twitter.com/andromedaprot" target="_blank">Twitter</a>
- <a href="https://discord.gg/a78qDEUF" target="_blank">Discord</a>



# 1) Otomatik Kurulum için;

- Aşağıdaki komutu çalıştırın. 
- Validator için bir ad belirleyin ve kurulumun tamamlanmasını bekleyin.
```
wget -q -O andromeda.sh https://raw.githubusercontent.com/CoinHuntersTR/Andromeda-Testnet-Rehberi/main/andromeda.sh && chmod +x andromeda.sh && sudo /bin/bash andromeda.sh
```
- Kurulum tamamlandıktan sonra bu komutu girin.
```
source $HOME/.bash_profile
```

# 2) Cüzdan Kurulumu

- cüzdanadi yerine istediğiniz bir ismi girin.
```
andromedad keys add cüzdanadi
```
- Cüzdan kelimelerinizi ve cüzdan adresini bir yere kayıt etmeyi unutmayın.

# 3) Validator Kurulumu
  
- Ağın sekronize olması bitene kadar bekliyoruz. False sonucunu görene kadar bekle. 
  
```
curl -s localhost:26657/status | jq .result.sync_info.catching_up
```
### Log Kontrolü
  
```
journalctl -u andromedad -f -o cat
``` 

### Validator Kurulumu;
```
andromedad tx staking create-validator \
--moniker="$VALIDATOR" \
--website="https://coinhunterstr.com/" \
--details="https://linktr.ee/coinhunters" \
--amount=1000000uandr \
--fees 300uandr \
--pubkey=$(andromedad tendermint show-validator) \
--chain-id=$CHAIN_ID \
--commission-max-change-rate=0.01 \
--commission-max-rate=0.20 \
--commission-rate=0.10 \
--min-self-delegation=1 \
--from=cüzdanadi \
--yes
```
