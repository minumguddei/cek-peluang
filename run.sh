#!/bin/bash

# 1. Scrap Harga ETH Real-Time (Binance API - Sangat Stabil)
ETH_PRICE=$(curl -s "https://api.binance.com/api/v3/ticker/price?symbol=ETHUSDT" | jq -r '.price')

# Fallback jika Binance gagal (CryptoCompare)
if [[ -z "$ETH_PRICE" || "$ETH_PRICE" == "null" ]]; then
    ETH_PRICE=$(curl -s "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD" | jq -r '.USD')
fi

# Jika semua gagal, baru pakai angka darurat (biar script tidak mati)
[[ -z "$ETH_PRICE" || "$ETH_PRICE" == "null" ]] && ETH_PRICE=3500

# 2. Ambil Data Blok
curl -s -X POST -H "Content-Type: application/json" \
--data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' \
$RPC_URL > temp.json

# 3. Cek API RPC
grep -q "result" temp.json && API_OK=1 || API_OK=0

# 4. Parsing dengan Python
STATS=$(python3 -c "
import json
try:
    with open('temp.json', 'r') as f:
        data = json.load(f)
    txs = data['result']['transactions']
    bots = [t for t in txs if int(t['gas'], 16) > 150000]
    
    # Ambil Bribe Gwei (Cek Priority Fee lalu Gas Price)
    bribes = []
    for t in txs:
        p_hex = t.get('maxPriorityFeePerGas') or t.get('gasPrice') or '0x0'
        bribes.append(int(p_hex, 16) / 1e9)
    
    mx = max(bribes) if bribes else 0.0
    print(f'{len(txs)} {len(bots)} {mx:.2f}')
except:
    print('0 0 0.00')
")

T=$(echo $STATS | cut -d' ' -f1)
B=$(echo $STATS | cut -d' ' -f2)
M=$(echo $STATS | cut -d' ' -f3)

# 5. Compile & Lapor
gcc bot.c -o bot
./bot $API_OK $T $B $M $ETH_PRICE > out.txt
echo "$(date)" >> out.txt

# 6. Kirim NTFY
curl -H "Title: Intel Gerbangku" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU

# Bersihkan
rm temp.json
