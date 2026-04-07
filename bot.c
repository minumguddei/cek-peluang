#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 6) return 1;

    int api = atoi(argv[1]);
    int txs = atoi(argv[2]);
    int bot = atoi(argv[3]);
    double max = atof(argv[4]);
    double avg = atof(argv[5]);

    printf("🤖 *GERBANGKU INTEL*\n");
    printf("API: %s\n", (api == 1) ? "OK" : "ERR");
    printf("TXS: %d | BOTS: %d\n", txs, bot);
    printf("MAX: %.6f ETH\n", max);
    printf("AVG: %.6f ETH\n", avg);
    printf("--------------------\n");

    if (bot > 100) printf("⚠️ PADAT\n");
    else if (max > 0.05) printf("🔥 PAUS\n");
    else printf("🟢 SEPI\n");

    return 0;
}
