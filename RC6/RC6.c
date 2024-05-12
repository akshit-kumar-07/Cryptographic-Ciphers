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

static const char base64_chars[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

// Helper function to get the index of a character in the base64 alphabet
static int base64_decode_char(char c) {
    if (c >= 'A' && c <= 'Z') {
        return c - 'A';
    } else if (c >= 'a' && c <= 'z') {
        return c - 'a' + 26;
    } else if (c >= '0' && c <= '9') {
        return c - '0' + 52;
    } else if (c == '+') {
        return 62;
    } else if (c == '/') {
        return 63;
    } else {
        return -1;  // Invalid character
    }
}

// RC6 key schedule generation
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

// RC6 encryption
void rc6_encrypt(const RC6_BLOCK plaintext, const RC6_WORD *round_keys, RC6_BLOCK ciphertext) {
    RC6_WORD A = ((RC6_WORD *)plaintext)[0];
    RC6_WORD B = ((RC6_WORD *)plaintext)[1];
    RC6_WORD C = ((RC6_WORD *)plaintext)[2];
    RC6_WORD D = ((RC6_WORD *)plaintext)[3];

    B += round_keys[0];
    D += round_keys[1];

    for (int i = 1; i <= RC6_NUM_ROUNDS; ++i) {
        RC6_WORD t = (B * (2 * B + 1)) << RC6_WORD_SIZE_LOG;
        RC6_WORD u = (D * (2 * D + 1)) << RC6_WORD_SIZE_LOG;
        A = (A ^ t) + round_keys[2 * i];
        C = (C ^ u) + round_keys[2 * i + 1];

        RC6_WORD temp = A;
        A = B;
        B = C;
        C = D;
        D = temp;
    }

    A += round_keys[2 * RC6_NUM_ROUNDS + 2];
    C += round_keys[2 * RC6_NUM_ROUNDS + 3];

    ((RC6_WORD *)ciphertext)[0] = A;
    ((RC6_WORD *)ciphertext)[1] = B;
    ((RC6_WORD *)ciphertext)[2] = C;
    ((RC6_WORD *)ciphertext)[3] = D;
}

// RC6 decryption
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

const RC6_BLOCK cipher_txt[5];

// Base64 encoding
void base64_encode(const uint8_t *data, size_t length) {
    size_t encoded_size = ((length + 2) / 3) * 4;
    char *encoded_data = malloc(encoded_size + 1);  // +1 for null terminator

    if (!encoded_data) {
        // Handle memory allocation failure
        return;
    }

    size_t output_index = 0;

    for (size_t i = 0; i < length; i += 3) {
        uint32_t chunk = (data[i] << 16) | ((i + 1 < length ? data[i + 1] : 0) << 8) |
                         (i + 2 < length ? data[i + 2] : 0);

        encoded_data[output_index++] = base64_chars[(chunk >> 18) & 0x3F];
        encoded_data[output_index++] = base64_chars[(chunk >> 12) & 0x3F];
        encoded_data[output_index++] = (i + 1 < length) ? base64_chars[(chunk >> 6) & 0x3F] : '=';
        encoded_data[output_index++] = (i + 2 < length) ? base64_chars[chunk & 0x3F] : '=';
    }

    encoded_data[output_index] = '\0';  // Null-terminate the string
    // Print or use the encoded_data as needed

    free(encoded_data);
}

// Base64 decoding
void base64_decode(const char *data, size_t length) {
    size_t decoded_size = (length * 3) / 4;
    uint8_t *decoded_data = malloc(decoded_size);

    if (!decoded_data) {
        // Handle memory allocation failure
        return;
    }

    size_t input_index = 0;
    size_t output_index = 0;

    while (input_index < length) {
        uint32_t chunk = 0;
        size_t chunk_size = 0;

        for (size_t i = 0; i < 4; ++i) {
            if (input_index < length && data[input_index] != '=') {
                chunk |= base64_decode_char(data[input_index++]) << (18 - i * 6);
                ++chunk_size;
            } else {
                // Padding character '=', ignore
                ++input_index;
            }
        }

        for (size_t i = 0; i < chunk_size - 1; ++i) {
            decoded_data[output_index++] = (chunk >> (16 - i * 8)) & 0xFF;
        }
    }

    // Use or process the decoded_data as needed

    free(decoded_data);
}


void print_hex(const char* label, const uint8_t* data, size_t size) {
    printf("%s:\n", label);
    for (size_t i = 0; i < size; ++i) {
        printf("%02X ", data[i]);
    }
    printf("\n");
}


/*RC6_BLOCK* run_encryption_test(const uint8_t* key, const RC6_BLOCK plaintext) {
    // Key schedule
    RC6_WORD round_keys[RC6_NUM_ROUNDS * 2 + 4];
    rc6_key_schedule(key, round_keys);

    // Encryption
    RC6_BLOCK ciphertext;
    rc6_encrypt(plaintext, round_keys, ciphertext);

    // Base64 Encoding
    printf("Encryption Test Case:\n");
    print_hex("Input", plaintext, RC6_BLOCK_SIZE);
    print_hex("Output (Base64)", ciphertext, RC6_BLOCK_SIZE);
    printf("\n");
    return ciphertext;
}*/

void run_encryption_test(const uint8_t* key, const RC6_BLOCK plaintext, RC6_BLOCK* ciphertext) {
    // Key schedule
    RC6_WORD round_keys[RC6_NUM_ROUNDS * 2 + 4];
    rc6_key_schedule(key, round_keys);

    // Encryption
    rc6_encrypt(plaintext, round_keys, *ciphertext);

    // Base64 Encoding
    printf("Encryption Test Case:\n");
    print_hex("Input", plaintext, RC6_BLOCK_SIZE);
    print_hex("Output (Base64)", *ciphertext, RC6_BLOCK_SIZE);
    printf("\n");
}

void run_decryption_test(const uint8_t* key, const RC6_BLOCK ciphertext) {
    // Key schedule
    RC6_WORD round_keys[RC6_NUM_ROUNDS * 2 + 4];
    rc6_key_schedule(key, round_keys);

    // Decryption
    RC6_BLOCK decrypted_text;
    rc6_decrypt(ciphertext, round_keys, decrypted_text);

    // Base64 Encoding
    printf("Decryption Test Case:\n");
    print_hex("Input (Ciphertext)", ciphertext, RC6_BLOCK_SIZE);
    print_hex("Output", decrypted_text, RC6_BLOCK_SIZE);
    printf("\n");
}

int main() {
    char operation;
    int testCase;
    RC6_BLOCK cipher_txt[5];
    RC6_BLOCK ct;

    do {
        printf("Enter 'e' for encryption, 'd' for decryption, or 't' to exit: ");
        scanf(" %c", &operation);

        switch (operation) {
            case 'e':
            case 'd':
                printf("Enter a test case number (1-5): ");
                scanf("%d", &testCase);

                switch (testCase) {
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5: {
                        // Test Case selection
                        RC6_WORD round_keys[RC6_NUM_ROUNDS * 2 + 4];
                        const uint8_t key[RC6_KEY_SIZE] = {0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF,
                                                           0x01, 0x12, 0x23, 0x34, 0x45, 0x56, 0x67, 0x78};
                        rc6_key_schedule(key, round_keys);
                        const RC6_BLOCK plaintext[5] = {
                            {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
                            {0x02, 0x13, 0x24, 0x35, 0x46, 0x57, 0x68, 0x79, 0x8A, 0x9B, 0xAC, 0xBD, 0xCE, 0xDF, 0xE0, 0xF1},
                            {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},
                            {0x89, 0x9A, 0xAB, 0xBC, 0xCD, 0xDE, 0xEF, 0xF0, 0x10, 0x32, 0x54, 0x76, 0x98, 0xBA, 0xDC, 0xFE},
                            {0xC8, 0x24, 0x18, 0x16, 0xF0, 0xD7, 0xE4, 0x89, 0x20, 0xAD, 0x16, 0xA1, 0x67, 0x4E, 0x5D, 0x48}
                        };

                        if (operation == 'e') {
                            run_encryption_test(key, plaintext[testCase - 1], &cipher_txt[testCase - 1]);
                        } else {
                            // Generate ciphertext using encryption function before decryption
                            run_decryption_test(key, cipher_txt[testCase - 1]);
                        }
                        break;
                    }
                    default:
                        printf("Invalid test case number\n");
                        break;
                }
                break;
            case 't':
                break; // Exit the loop and program
            default:
                printf("Invalid operation\n");
                break;
        }

    } while (operation != 't');

    return 0;
}
