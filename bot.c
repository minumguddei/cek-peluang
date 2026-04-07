#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 6) return 1;

    int api = atoi(argv[1]);
    int txs = atoi(argv[2]);
    int bot = atoi(argv[3]);
    double max_gwei = atof(argv[4]);
    double avg_gwei = atof(argv[5]);

    printf("🤖 *INTEL GERBANGKU*\n");
    printf("API: %s | TXS: %d\n", (api == 1) ? "OK" : "ERR", txs);
    printf("👥 BOTS: %d (Potensi Rival)\n", bot);
    printf("--------------------\n");
    printf("💸 MAX BRIBE: %.2f Gwei\n", max_gwei);
    printf("📊 AVG BRIBE: %.2f Gwei\n", avg_gwei);
    printf("--------------------\n");

    // Analisis Peluang
    if (bot > 50 && max_gwei < 10.0) {
        printf("🟢 PELUANG: Bot lawan pelit! Sikat dengan Bribe 15-20 Gwei.\n");
    } else if (max_gwei > 100.0) {
        printf("🔥 BAHAYA: Perang Bribe Tinggi. Hindari dulu.\n");
    } else {
        printf("🟡 STATUS: Normal.\n");
    }

    return 0;
}
