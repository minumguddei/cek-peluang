#!/bin/bash

# 1. Ambil data
DATA=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' $RPC_URL)

# 2. Cek API
[[ $DATA == *"result"* ]] && API=1 || API=0

# 3. Parsing Gas & Bot
GAS_HEX=$(echo $DATA | jq -r '.result.transactions[].gas')
TXS=0; BOT=0
for g in $GAS_HEX; do
    TXS=$((TXS + 1))
    # Konversi hex ke decimal dengan python agar aman dari overflow
    d=$(python3 -c "print(int('$g', 16))")
    [[ $d -gt 150000 ]] && BOT=$((BOT + 1))
done

# 4. Parsing Bribe (Pakai Python untuk presisi 18 desimal)
B_LIST=$(echo $DATA | jq -r '.result.transactions[] | (.maxPriorityFeePerGas // .gasPrice // "0x0")')

# Gunakan skrip Python singkat untuk hitung Max & Avg agar tidak 0.000000
STATS=$(python3 -c "
bribes = [int(x, 16) for x in '$B_LIST'.split() if int(x, 16) > 1000000000]
if not bribes:
    print('0.0 0.0')
else:
    max_b = max(bribes) / 1e18
    avg_b = (sum(bribes) / len(bribes)) / 1e18
    print(f'{max_b:.12f} {avg_b:.12f}')
")

MAX_E=$(echo $STATS | cut -d' ' -f1)
AVG_E=$(echo $STATS | cut -d' ' -f2)

# 5. Compile & Lapor
gcc bot.c -o bot
./bot $API $TXS $BOT $MAX_E $AVG_E > out.txt
echo "$(date)" >> out.txt

curl -H "Title: Gerbangku Audit" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU
