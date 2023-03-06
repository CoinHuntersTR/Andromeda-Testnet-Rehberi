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
 ![andromeda-1](https://user-images.githubusercontent.com/111747226/223242085-09fc964b-0dc5-4628-932f-6c1aefaf0b1a.png)
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
- Sizden bir şifre oluşturmanızı isteyecek gireceğiniz şifreyi unutmayın bir yere not edin. Aynı şifreyi iki kere girdiğinizde aşağıdaki gibi cüzdan adresi ve kelimeleri alabilrisiniz.
![andromeda-2](https://user-images.githubusercontent.com/111747226/223243262-a2931fab-0091-46d9-a4b5-e0a6f15c9d26.png)
- Cüzdan kelimelerinizi ve cüzdan adresini bir yere kayıt etmeyi unutmayın.

# 3) Validator Kurulumu
  
- Ağın sekronize olması bitene kadar bekliyoruz. False sonucunu görene kadar bekle. Aşağıdaki şekilde true aldığın sürece bekliyorsun!
 ![andromeda-3](https://user-images.githubusercontent.com/111747226/223243839-89a58c62-6150-4b5e-886b-408b2d26a7bc.png)
  
```
andromedad status 2>&1 | jq .SyncInfo
```
### Log Kontrolü
  
```
journalctl -u andromedad -f -o cat
``` 
- Bu şekilde blok kayıtları akıyorsa sıkıntı yok demektir.
![blok-kayitlari](https://user-images.githubusercontent.com/111747226/223246515-30f69bc4-75fc-4993-b105-067c06a50a1c.png)
 ### Faucet
 - Discorda kanalında #faucet-pub kanalına gidiyoruz. aşağdaki kod şeklinde test tokeni talep ediyoruz.
  
```
!request cüzdanadresi
``` 

### Validator Kurulumu;
 ![andromeda-4](https://user-images.githubusercontent.com/111747226/223249218-357e36c8-8367-4daf-a540-ff0de09b1361.png)
 -Bu şekilde FALSE aldığınızda validator kurulumuna geçebilirsiniz.
 - cüzdanadi yazan yere, oluşturduğunuz cüzdan adını ekleyin. Website linkleri kısmını mutlaka değiştirin. Kendi twitter veya telegram adreslerinizi verebilirsiniz.
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
 ![validator-kurulumu](https://user-images.githubusercontent.com/111747226/223251105-5716eb9f-6cb3-46a5-9610-f9f4ef1fe14c.png)
 -Cüzdanı açarken girmiş olduğunuz şifreyi sizden isteyecek burada onu giriyoruz ve ENTER tuşuna basıyoruz. İşlem tamamdır.
