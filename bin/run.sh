#!/bin/bash

# Ambil data
DATA=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' $RPC_URL)

# Cek API
[[ $DATA == *"result"* ]] && API=1 || API=0

# Parsing
GAS=$(echo $DATA | jq -r '.result.transactions[].gas')
TXS=$(echo "$GAS" | wc -w)
BOT=0
for g in $GAS; do
    [[ $(printf "%d" $g) -gt 150000 ]] && BOT=$((BOT+1))
done

# Bribe
B_LIST=$(echo $DATA | jq -r '.result.transactions[] | select(.maxPriorityFeePerGas != null) | .maxPriorityFeePerGas')
MAX=0; TOTAL=0; COUNT=0
for b in $B_LIST; do
    d=$(printf "%d" $b)
    [[ $d -gt $MAX ]] && MAX=$d
    TOTAL=$((TOTAL + d))
    COUNT=$((COUNT + 1))
done

# Konversi
MAX_E=$(awk "BEGIN {print $MAX / 1e18}")
[[ $COUNT -gt 0 ]] && AVG_E=$(awk "BEGIN {print ($TOTAL / $COUNT) / 1e18}") || AVG_E=0

# Lapor
gcc src/bot.c -o bot
./bot $API $TXS $BOT $MAX_E $AVG_E > out.txt
curl -d "$(<out.txt)" https://ntfy.sh/GERBANGKU
