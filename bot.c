#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 7) return 1;

    int api = atoi(argv[1]);
    int txs = atoi(argv[2]);
    int bot = atoi(argv[3]);
    double max_gwei = atof(argv[4]);
    double eth_price = atof(argv[5]);
    double gas_used = 250000.0; // Standar gas untuk Flash Loan/Swap kompleks

    // Rumus: (Gwei * GasUsed * 1e-9) * HargaETH
    double max_usd = (max_gwei * gas_used * 1e-9) * eth_price;

    printf("🤖 *INTEL GERBANGKU*\n");
    printf("API: %s | BLOK: %d TX\n", (api == 1) ? "OK" : "ERR", txs);
    printf("👥 BOTS: %d | ETH: $%.0f\n", bot, eth_price);
    printf("--------------------\n");
    printf("⛽ Est. Gas: %.0f unit\n", gas_used);
    printf("💸 Max Bribe: %.2f Gwei\n", max_gwei);
    printf("💵 Biaya Gas: $%.2f\n", max_usd);
    printf("--------------------\n");

    if (max_usd < 2.0 && bot < 50) {
        printf("🟢 STATUS: MURAH ($%.2f). Cocok untuk Test/Run.\n", max_usd);
    } else if (max_usd > 10.0) {
        printf("🔥 STATUS: MAHAL. Gas per transaksi > $10.\n");
    } else {
        printf("🟡 STATUS: NORMAL.\n");
    }

    return 0;
}
