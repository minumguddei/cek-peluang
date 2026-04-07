#!/bin/bash

# 1. Scrap Harga ETH
ETH_PRICE=$(curl -s "https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT" | jq -r '.price')
[[ -z "$ETH_PRICE" || "$ETH_PRICE" == "null" ]] && ETH_PRICE=2100

# 2. Ambil Data Blok
curl -s -X POST -H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' \
$RPC_URL > temp.json

# 3. Cek API
grep -q "result" temp.json && API_OK=1 || API_OK=0

# 4. Parsing dengan Python (Harus Output 3 Angka)
STATS=$(python3 -c "
import json
try:
    with open('temp.json', 'r') as f:
        data = json.load(f)
    txs = data['result']['transactions']
    bots = [t for t in txs if int(t['gas'], 16) > 150000]
    bribes = []
    for t in txs:
        p_hex = t.get('maxPriorityFeePerGas') or t.get('gasPrice') or '0x0'
        bribes.append(int(p_hex, 16) / 1e9)
    mx = max(bribes) if bribes else 0.0
    print(f'{len(txs)} {len(bots)} {mx:.2f}')
except:
    print('0 0 0.00')
")

T=$(echo $STATS | cut -d' ' -f1) # Total TX
B=$(echo $STATS | cut -d' ' -f2) # Bot Count
M=$(echo $STATS | cut -d' ' -f3) # Max Gwei

# 5. Jalankan Audit Intelijen (bot.c)
gcc bot.c -o audit
./audit $API_OK $T $B $M $ETH_PRICE > out.txt

# 6. Jalankan Mesin Eksekusi (engine.c)
# Kita masukkan 3 parameter: Bot_Count, Max_Gwei, ETH_Price
gcc engine.c -o engine
./engine $B $M $ETH_PRICE >> out.txt

# Tambahkan Tanggal
echo -e "\n$(date)" >> out.txt

# 7. Kirim ke NTFY
curl -H "Title: Intel & Engine Gerbangku" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU

rm temp.json
