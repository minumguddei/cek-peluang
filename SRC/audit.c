#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 5) return 1;

    int total_tx = atoi(argv[1]);
    int mev_tx = atoi(argv[2]);
    double avg_bribe = atof(argv[3]);
    int reverted_tx = atoi(argv[4]);

    double mev_percent = ((double)mev_tx / total_tx) * 100;
    double failure_rate = ((double)reverted_tx / mev_tx) * 100;

    printf("🔍 *AUDIT GERBANGKU: INTELIJEN PASAR*\n");
    printf("------------------------------------\n");
    printf("📦 Total Tx di Blok: %d\n", total_tx);
    printf("🤖 Estimasi Bot MEV: %d (%.1f%%)\n", mev_tx, mev_percent);
    printf("💸 Rata-rata Bribe: %.4f ETH\n", avg_bribe);
    printf("❌ Bot Gagal (Revert): %d (%.1f%%)\n", reverted_tx, failure_rate);
    printf("------------------------------------\n");

    if (mev_percent > 15.0 && failure_rate > 50.0) {
        printf("🚫 KESIMPULAN: JANGAN SEWA VPS DULU. Kompetisi terlalu padat & banyak bot 'mati' konyol.\n");
    } else if (mev_percent < 5.0) {
        printf("🟢 KESIMPULAN: PELUANG TINGGI. Pasar sepi, saatnya masuk dengan Bare Metal!\n");
    } else {
        printf("🟡 KESIMPULAN: WAIT & SEE. Monitor 24 jam ke depan.\n");
    }

    return 0;
}
