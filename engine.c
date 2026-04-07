#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc < 4) return 1;

    int bots = atoi(argv[1]);
    double max_g = atof(argv[2]);
    double eth_p = atof(argv[3]);

    double gas_used = 250000.0;
    double cost_usd = (max_g * gas_used * 1e-9) * eth_p;

    printf("\n--- 🤖 EKSEKUTOR GERBANGKU ---\n");
    printf("Biaya Gas Lawan: $%.2f\n", cost_usd);
    
    // ANALISIS SINYAL
    if (max_g > 15.0) {
        printf("⚠️ SINYAL: PAUS TERDETEKSI!\n");
        printf("INFO: Ada bot yang ngejar profit > $20.\n");
        printf("KONDISI: 🔴 JANGAN LAWAN (Modal suap mereka terlalu kuat).\n");
    } else if (max_g < 5.0 && bots > 0) {
        printf("✅ SINYAL: BOT RAKSASA LAGI PELIT.\n");
        printf("KONDISI: 🟢 PELUANG SNIPE (Bisa disalip pakai $2 - $3).\n");
    } else {
        printf("KONDISI: 🟡 PASAR NORMAL/SEPI.\n");
    }

    return 0;
}
