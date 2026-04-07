#!/bin/bash

# 1. Ambil data blok terakhir (Format JSON)
DATA=$(curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest", true],"id":1}' $RPC_URL)

# 2. Cek Koneksi API (Health Check)
if [[ $DATA == *"result"* && $DATA == *"0x"* ]]; then
    API=1
else
    API=0
    echo "Koneksi API Gagal"
    exit 1
fi

# 3. Parsing Gas & Jumlah Transaksi
# Mengambil list gas limit per transaksi
GAS_HEX_LIST=$(echo $DATA | jq -r '.result.transactions[].gas')
TXS=$(echo "$GAS_HEX_LIST" | wc -w)

BOT=0
for g in $GAS_HEX_LIST; do
    # Konversi Hex ke Decimal
    d_gas=$(printf "%d" $g)
    # Kriteria Bot: Transaksi berat di atas 150.000 Gas
    if [ $d_gas -gt 150000 ]; then
        BOT=$((BOT + 1))
    fi
done

# 4. Parsing Bribe (Priority Fee / Gas Price)
# Kita ambil maxPriorityFeePerGas, jika null (Legacy), ambil gasPrice
B_LIST=$(echo $DATA | jq -r '.result.transactions[] | (.maxPriorityFeePerGas // .gasPrice // "0x0")')

MAX_DEC=0
TOTAL_DEC=0
COUNT=0

for b_hex in $B_LIST; do
    d_bribe=$(printf "%d" $b_hex)
    
    # Filter: Hanya hitung yang di atas 1 Gwei (1.000.000.000 Wei)
    if [ $d_bribe -gt 1000000000 ]; then
        if [ $d_bribe -gt $MAX_DEC ]; then
            MAX_DEC=$d_bribe
        fi
        TOTAL_DEC=$((TOTAL_DEC + d_bribe))
        COUNT=$((COUNT + 1))
    fi
done

# 5. Konversi ke ETH (Wei / 10^18)
MAX_ETH=$(awk "BEGIN {print $MAX_DEC / 1000000000000000000}")
if [ $COUNT -gt 0 ]; then
    AVG_ETH=$(awk "BEGIN {print ($TOTAL_DEC / $COUNT) / 1000000000000000000}")
else
    AVG_ETH=0
fi

# 6. Compile & Jalankan Bot Audit
gcc bot.c -o bot
./bot $API $TXS $BOT $MAX_ETH $AVG_ETH > out.txt

# Tambahkan Timestamp Waktu Indonesia (WITA)
echo "$(date)" >> out.txt

# 7. Kirim Laporan ke NTFY
curl -H "Title: Intelijen GERBANGKU" \
     -H "Priority: urgent" \
     -d "$(<out.txt)" \
     https://ntfy.sh/GERBANGKU
