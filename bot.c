#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 6) return 1;

    int api = atoi(argv[1]);
    int txs = atoi(argv[2]);
    int bot = atoi(argv[3]);
    // Gunakan %lf untuk membaca double dari bash
    double max_eth = atof(argv[4]);
    double avg_eth = atof(argv[5]);

    printf("🤖 *GERBANGKU INTEL*\n");
    printf("API: %s | BLOK: %d TX\n", (api == 1) ? "OK" : "ERR", txs);
    printf("👥 ESTIMASI BOT: %d\n", bot);
    printf("--------------------\n");
    // Print dengan presisi lebih tinggi
    printf("💸 MAX BRIBE: %.9f ETH\n", max_eth);
    printf("📊 AVG BRIBE: %.9f ETH\n", avg_eth);
    printf("--------------------\n");

    if (bot > 80) printf("⚠️ STATUS: PADAT (High Competition)\n");
    else if (max_eth > 0.01) printf("🔥 STATUS: PERANG PAUS\n");
    else printf("🟢 STATUS: SEPI\n");

    return 0;
}
