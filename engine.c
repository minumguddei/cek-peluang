#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 4) return 1;

    int bots = atoi(argv[1]);
    double max_g = atof(argv[2]);
    double eth_p = atof(argv[3]);

    double target_profit_usd = 5.0;
    double gas_used = 250000.0;
    double cost_usd = (max_g * gas_used * 1e-9) * eth_p;
    double net_profit = target_profit_usd - cost_usd;

    printf("\n--- 🤖 EKSEKUTOR GERBANGKU ---\n");
    printf("Target Profit : $%.2f\n", target_profit_usd);
    printf("Estimasi Biaya: $%.2f\n", cost_usd);
    
    if (net_profit > 1.0 && bots < 100) { // Saya naikkan batas ke 100 agar lebih berani
        printf("KONDISI: 🟢 MENGUNTUNGKAN (Net: $%.2f)\n", net_profit);
        printf("[!] ACTION: MENGIRIM TRANSAKSI...\n");
    } else if (bots >= 100) {
        printf("KONDISI: 🔴 SKIP (Rival Terlalu Banyak: %d)\n", bots);
    } else {
        printf("KONDISI: 🟡 SKIP (Biaya Gas Mahal/Profit Tipis)\n");
    }
    return 0;
}
