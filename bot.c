#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 6) return 1;

    int api = atoi(argv[1]);
    int txs = atoi(argv[2]);
    int bot = atoi(argv[3]);
    double max_g = atof(argv[4]);
    double eth_p = atof(argv[5]); // Harga real-time dari script
    
    double gas_u = 250000.0; 
    double usd_v = (max_g * gas_u * 1e-9) * eth_p;

    printf("🤖 *GERBANGKU INTEL*\n");
    printf("API: %s | BLOK: %d TX\n", (api == 1) ? "OK" : "ERR", txs);
    printf("👥 BOTS: %d | ETH: $%.2f\n", bot, eth_p);
    printf("--------------------\n");
    printf("💸 MAX: %.2f Gwei\n", max_g);
    printf("💵 COST: $%.2f\n", usd_v);
    printf("--------------------\n");

    if (bot > 100) printf("⚠️ PADAT\n");
    else if (usd_v < 1.5) printf("🟢 MURAH (SIKAT)\n");
    else printf("🟡 NORMAL\n");

    return 0;
}
