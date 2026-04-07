#!/bin/bash

# 1. Ambil data blok terbaru
DATA=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' $RPC_URL)

# 2. Cek API
[[ $DATA == *"result"* ]] && API=1 || API=0

# 3. Parsing Gas & Estimasi Bot (Pakai Python agar akurat)
BOT_STATS=$(python3 -c "
import json
data = json.loads('''$DATA''')
txs = data['result']['transactions']
total = len(txs)
# Filter Bot: Gas > 150k ATAU ada priority fee
bots = [t for t in txs if int(t['gas'], 16) > 150000]
print(f'{total} {len(bots)}')
")

TXS=$(echo $BOT_STATS | cut -d' ' -f1)
BOT=$(echo $BOT_STATS | cut -d' ' -f2)

# 4. Parsing Bribe (Mencakup GasPrice & PriorityFee)
# Kita ambil data bribe dari semua transaksi untuk melihat skala pasar
STATS=$(python3 -c "
import json
data = json.loads('''$DATA''')
bribes = []
for t in data['result']['transactions']:
    # Ambil yang tertinggi antara priority fee atau gas price (dikurangi base fee estimasi)
    p = int(t.get('maxPriorityFeePerGas', t.get('gasPrice', '0x0')), 16)
    if p > 1000000000: bribes.append(p)

if not bribes:
    print('0.0 0.0')
else:
    max_b = max(bribes) / 1e18
    avg_b = (sum(bribes) / len(bribes)) / 1e18
    print(f'{max_b:.12f} {avg_b:.12f}')
")

MAX_E=$(echo $STATS | cut -d' ' -f1)
AVG_E=$(echo $STATS | cut -d' ' -f2)

# 5. Eksekusi Audit C
gcc bot.c -o bot
./bot $API $TXS $BOT $MAX_E $AVG_E > out.txt
echo "$(date)" >> out.txt

# 6. Lapor NTFY
curl -H "Title: Intelijen GERBANGKU" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU
