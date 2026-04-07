#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Pastikan ada 4 argumen: nama_program, bot_count, max_gwei, eth_price
    if (argc < 4) {
        printf("Gunakan: ./engine [BOT_COUNT] [MAX_GWEI] [ETH_PRICE]\n");
        return 1;
    }

    int bots = atoi(argv[1]);
    double max_g = atof(argv[2]);
    double eth_p = atof(argv[3]);

    printf("\n--- MESIN EKSEKUSI GERBANGKU ---\n");
    
    // Logika Sederhana: Sikat jika bot lawan di bawah 50 dan bribe di bawah 20 Gwei
    if (bots < 50 && max_g < 20.0) {
        printf("KONDISI: AMAN. Target terdeteksi.\n");
        printf("[!] MENGIRIM TRANSAKSI KE RPC... (Simulated)\n");
        printf("INFO: Menggunakan suap %.2f Gwei\n", max_g + 0.5);
    } else {
        printf("KONDISI: SKIP. Persaingan terlalu tinggi.\n");
    }

    return 0;
}
