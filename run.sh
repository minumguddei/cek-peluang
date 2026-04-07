#!/bin/bash

# 1. Scrap Harga ETH
ETH_PRICE=$(curl -s "https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT" | jq -r '.price')
[[ -z "$ETH_PRICE" || "$ETH_PRICE" == "null" ]] && ETH_PRICE=2100

# 2. Ambil Data Blok
curl -s -X POST -H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' \
$RPC_URL > temp.json

# 3. Parsing (Python)
STATS=$(python3 -c "
import json
try:
    with open('temp.json', 'r') as f:
        data = json.load(f)
    txs = data['result']['transactions']
    bots = [t for t in txs if int(t['gas'], 16) > 150000]
    bribes = [int(t.get('maxPriorityFeePerGas') or t.get('gasPrice') or '0x0'), 16) / 1e9 for t in txs]
    mx = max(bribes) if bribes else 0.0
    print(f'{len(txs)} {len(bots)} {mx:.2f}')
except:
    print('0 0 0.00')
")

T=$(echo $STATS | cut -d' ' -f1)
B=$(echo $STATS | cut -d' ' -f2)
M=$(echo $STATS | cut -d' ' -f3)

# 4. Bersihkan Laporan Lama & Jalankan Engine Baru
echo "--- 📊 AUDIT BLOK ---" > out.txt
echo "Total TX: $T | Rival: $B" >> out.txt
echo "Bribe Tertinggi: $M Gwei" >> out.txt

gcc engine.c -o engine
./engine $B $M $ETH_PRICE >> out.txt

# 5. Timestamp & Kirim
echo -e "\n$(date)" >> out.txt
curl -H "Title: Gerbangku Intel" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU

rm temp.json
