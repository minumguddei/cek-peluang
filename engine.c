#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 4) {
        printf("Gunakan: ./engine [BOT_COUNT] [MAX_GWEI] [ETH_PRICE]\n");
        return 1;
    }

    int bots = atoi(argv[1]);
    double max_g = atof(argv[2]);
    double eth_p = atof(argv[3]);

    // Simulasi Target Profit (Misal kita cari profit $5)
    double target_profit_usd = 5.0;
    double gas_used = 250000.0;
    double cost_usd = (max_g * gas_used * 1e-9) * eth_p;
    double net_profit = target_profit_usd - cost_usd;

    printf("\n--- 🤖 EKSEKUTOR GERBANGKU ---\n");
    printf("Target Profit : $%.2f\n", target_profit_usd);
    printf("Estimasi Biaya: $%.2f\n", cost_usd);
    
    // LOGIKA KEPUTUSAN:
    // Sikat jika Net Profit > $1 DAN saingan di bawah 50 bot
    if (net_profit > 1.0 && bots < 50) {
        printf("KONDISI: 🟢 MENGUNTUNGKAN (Net: $%.2f)\n", net_profit);
        printf("[!] ACTION: MENGIRIM TRANSAKSI KE RPC...\n");
        printf("INFO: Menyalip dengan %.2f Gwei\n", max_g + 0.1);
    } else if (bots >= 50) {
        printf("KONDISI: 🔴 SKIP (Rival Terlalu Banyak: %d)\n", bots);
    } else {
        printf("KONDISI: 🟡 SKIP (Biaya Gas Terlalu Mahal)\n");
    }

    return 0;
}
