#!/bin/bash

# ... (Bagian atas sama dengan run.sh sebelumnya untuk ambil data) ...

# 5. Compile & Jalankan Intelijen
gcc bot.c -o bot
./bot $API_OK $T $B $M $ETH_PRICE > out.txt

# 6. Jalankan Engine Eksekusi (Bot)
gcc engine.c -o engine
./engine $B $M $ETH_PRICE >> out.txt

# 7. Kirim Gabungan Laporan ke NTFY
curl -H "Title: Gerbangku Bot & Intel" -d "$(<out.txt)" https://ntfy.sh/GERBANGKU
