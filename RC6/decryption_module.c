#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#define RC6_KEY_SIZE 32
#define RC6_WORD_SIZE 32
#define RC6_WORD_SIZE_LOG 5
#define RC6_NUM_ROUNDS 20
#define RC6_BLOCK_SIZE 16

typedef uint32_t RC6_WORD;
typedef uint8_t RC6_BLOCK[RC6_BLOCK_SIZE];

void rc6_decrypt(const RC6_BLOCK ciphertext, const RC6_WORD *round_keys, RC6_BLOCK plaintext) {
    RC6_WORD A = ((RC6_WORD *)ciphertext)[0];
    RC6_WORD B = ((RC6_WORD *)ciphertext)[1];
    RC6_WORD C = ((RC6_WORD *)ciphertext)[2];
    RC6_WORD D = ((RC6_WORD *)ciphertext)[3];

    C -= round_keys[2 * RC6_NUM_ROUNDS + 3];
    A -= round_keys[2 * RC6_NUM_ROUNDS + 2];

    for (int i = RC6_NUM_ROUNDS; i >= 1; --i) {
        RC6_WORD temp = D;
        D = C;
        C = B;
        B = A;
        A = temp;

        RC6_WORD t = (B * (2 * B + 1)) << RC6_WORD_SIZE_LOG;
        RC6_WORD u = (D * (2 * D + 1)) << RC6_WORD_SIZE_LOG;
        C = (C - round_keys[2 * i + 1]) >> t ^ u;
        A = (A - round_keys[2 * i]) >> u ^ t;
    }

    D -= round_keys[1];
    B -= round_keys[0];

    ((RC6_WORD *)plaintext)[0] = A;
    ((RC6_WORD *)plaintext)[1] = B;
    ((RC6_WORD *)plaintext)[2] = C;
    ((RC6_WORD *)plaintext)[3] = D;
}


void rc6_key_schedule(const uint8_t *key, RC6_WORD *round_keys) {
    const RC6_WORD P32 = 0xB7E15163;
    const RC6_WORD Q32 = 0x9E3779B9;

    /*for (int i = 0; i < RC6_KEY_SIZE / sizeof(RC6_WORD); ++i) {
        round_keys[i] = ((const RC6_WORD *)key)[i];
    }*/
    round_keys[0] = P32;

    // for (int i = RC6_KEY_SIZE / sizeof(RC6_WORD); i < (RC6_NUM_ROUNDS * 2 + 4); ++i) {
    //     round_keys[i] = round_keys[i - 1] + Q32;
    // }
    for (int i = 1; i < (RC6_NUM_ROUNDS * 2 + 4); ++i) {
        round_keys[i] = round_keys[i - 1] + Q32;
    }

    RC6_WORD A, B, i, j, v;
    A = B = i = j = 0;
    v = 3 * ((RC6_KEY_SIZE / sizeof(RC6_WORD)) > (RC6_NUM_ROUNDS * 2 + 4)
                 ? (RC6_KEY_SIZE / sizeof(RC6_WORD))
                 : (RC6_NUM_ROUNDS * 2 + 4));

    for (int s = 0; s < v; ++s) {
        A = round_keys[i] = (round_keys[i] + A + B) << 3;
        B = ((uint32_t *)key)[j] = (((uint32_t *)key)[j] + A + B) << (A + B);
        i = (i + 1) % (RC6_NUM_ROUNDS * 2 + 4);
        j = (j + 1) % (RC6_KEY_SIZE / sizeof(RC6_WORD));
    }
}




void print_hex(const char* label, const uint8_t* data, size_t size) {
    printf("%s:\n", label);
    for (size_t i = 0; i < size; ++i) {
        printf("%02X ", data[i]);
    }
    printf("\n");
}

void run_test(const uint8_t* key, const RC6_BLOCK ciphertext) {
    // Key schedule
    RC6_WORD round_keys[RC6_NUM_ROUNDS * 2 + 4];
    rc6_key_schedule(key, round_keys);

    

// Decryption
    RC6_BLOCK decrypted_text;
    rc6_decrypt(ciphertext, round_keys, decrypted_text);


    // Base64 Encoding
    printf("Test Case:\n");
    print_hex("Ciphertext (Base64)", ciphertext, RC6_BLOCK_SIZE);
    print_hex("Decrypted Text", decrypted_text, RC6_BLOCK_SIZE);
    printf("\n");
}

int main() {
    // Test Case 1
    const uint8_t key1[RC6_KEY_SIZE] = {0x00, 0xF8, 0xC1, 0x8A, 0x00, 0xE8, 0x52, 0x73,
                                        0x00, 0xB2, 0x33, 0x3A, 0x00, 0x88, 0xDE, 0x0A};
    const RC6_BLOCK ciphertext1 = {0x00, 0xF8, 0xC1, 0x8A, 0x00, 0xE8, 0x52, 0x73,
                                   0x00, 0xB2, 0x33, 0x3A, 0x00, 0x88, 0xDE, 0x0A};
    run_test(key1, ciphertext1);

    // Test Case 2
    const uint8_t key2[RC6_KEY_SIZE] = {0x32, 0x56, 0xF8, 0xD2, 0x46, 0x27, 0x85, 0x88,
                                        0xCA, 0xB5, 0x8A, 0x39, 0xCE, 0x67, 0x36, 0xBD};
    const RC6_BLOCK ciphertext2 = {0x02, 0x13, 0x24, 0x35, 0x46, 0x57, 0x68, 0x79,
                                   0x8A, 0x9B, 0xAC, 0xBD, 0xCE, 0xDF, 0xE0, 0xF1};
    run_test(key2, ciphertext2);

    // Test Case 3
    const uint8_t key3[RC6_KEY_SIZE] = {0x00, 0xF8, 0xC1, 0x8A, 0x00, 0xE8, 0x52, 0x73,
                                        0x00, 0xB2, 0x33, 0x3A, 0x00, 0x88, 0xDE, 0x0A};
    const RC6_BLOCK ciphertext3 = {0x00, 0xF8, 0xC1, 0x8A, 0x00, 0xE8, 0x52, 0x73,
                                   0x00, 0xB2, 0x33, 0x3A, 0x00, 0x88, 0xDE, 0x0A};
    run_test(key3, ciphertext3);

    // Test Case 4
    const uint8_t key4[RC6_KEY_SIZE] = {0x79, 0x85, 0x78, 0x93, 0xCD, 0x36, 0xE5, 0xA4,
                                        0xD0, 0x12, 0xCD, 0x8A, 0x98, 0x4E, 0xDA, 0x61};
    const RC6_BLOCK ciphertext4 = {0x89, 0x9A, 0xAB, 0xBC, 0xCD, 0xDE, 0xEF, 0xF0,
                                   0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE};
    run_test(key4, ciphertext4);

    // Test Case 5
    const uint8_t key5[RC6_KEY_SIZE] = {0x78, 0x16, 0xAC, 0x0F, 0xF0, 0x13, 0x53, 0xE5,
                                        0xE0, 0xED, 0xCB, 0x15, 0x67, 0xEE, 0x3D, 0x5E};
    const RC6_BLOCK ciphertext5 = {0xC8, 0x24, 0x18, 0x16, 0xF0, 0xD7, 0xE4, 0x89,
                                   0x20, 0xAD, 0x16, 0xA1, 0x67, 0x4E, 0x5D, 0x48};
    run_test(key5, ciphertext5);

    return 0;
}

