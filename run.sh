#!/bin/bash

# 1. Ambil Harga ETH (CoinGecko API)
ETH_PRICE=$(curl -s "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd" | jq -r '.ethereum.usd')
[[ -z "$ETH_PRICE" || "$ETH_PRICE" == "null" ]] && ETH_PRICE=3500 # Backup jika API limit

# 2. Ambil Data Blok
curl -s -X POST -H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' \
$RPC_URL > temp.json

# 3. Cek API
grep -q "result" temp.json && API=1 || API=0

# 4. Parsing dengan Python (Stabil & Akurat)
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

    max_b = max(bribes) if bribes else 0.0
    print(f'{len(txs)} {len(bots)} {max_b:.2f}')
except:
    print('0 0 0.00')
")

TXS=$(echo $STATS | cut -d' ' -f1)
BOT=$(echo $STATS | cut -d' ' -f2)
MAX_G=$(echo $STATS | cut -d' ' -f3)

# 5. Compile & Lapor
gcc bot.c -o bot
./bot $API $TXS $BOT $MAX_G $ETH_PRICE > out.txt
echo "$(date)" >> out.txt

# 6. Kirim ke NTFY
curl -H "Title: Audit Biaya Gerbangku" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU

rm temp.json
