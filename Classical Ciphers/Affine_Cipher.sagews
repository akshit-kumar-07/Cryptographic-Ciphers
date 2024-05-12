︠970efdbe-c479-4e06-b169-5bb0723ef887s︠
a,b=17,8
def gcd(a,b):
    while(b):
        a,b=b,a%b
    return a

alp='abcdefghijklmnopqrstuvwxyz'
enc={char:i for i,char in enumerate(alp)}
dec={i:char for i,char in enumerate(alp)}

#dictionary check
#print(enc['f'],dec[13])

#plain_text='thisassignmentisforimplementingtheaffinecipher'
plain_text='thistextismeanttobeencryptedusingaffinecipher'
#encryption begins

def affine_cipher_encrypt(plaintext):
    ciphertext=''
    for ch in plaintext:
        if ch in alp: #we can only encrypt those symbols which are defined in our alphabet
            num=(enc[ch]*a+b)%26
            ciphertext+=dec[num]
        else:
            ciphertext+=ch #this code assumes that any character apart from lowercase letters won't get encrypted
    return ciphertext

cipher_text=affine_cipher_encrypt(plain_text)
print(cipher_text)

︡cda737f3-2484-4c98-b8a1-263613ce372f︡{"stdout":"txoctyjtoceyivttmzyyvqladtyhkcovgippovyqodxyl\n"}︡{"done":true}
︠1a843fad-8cc2-4dd8-8544-e63ae60f5fe3s︠

#decryption part

#define a function to find the multiplicative inverse
def power_mod(a,m) :
    a=a%m
    for x in range(1,m):
        if((a*x)%m==1):
            return x
    return 1

#cipher_text='qxbwxifhwdehobqiucqgqyghmcvepwno'
cipher_text='txociccogveyvtocpmloednyeyvtovgtxyippovyqodxyl'

def affine_cipher_decrypt(ciphertext,a,b):
    plaintext=''
    a_inv=power_mod(a,26)
    for ch in ciphertext:
        if ch in alp:
            num=((enc[ch]-b)*a_inv)%26
            plaintext+=dec[num]
        else:
            plaintext+=ch
    return plaintext

def affine_cipher_decrypt_2(ciphertext):
    plaintext=''
    a_inv=power_mod(a,26)
    for ch in ciphertext:
        if ch in alp:
            num=((enc[ch]-b)*a_inv)%26
            plaintext+=dec[num]
        else:
            plaintext+=ch
    return plaintext

plain_text=affine_cipher_decrypt(cipher_text,a,b)
print(plain_text)
︡34012a3f-b6c0-4e32-a5ad-edd188ecac8c︡{"stdout":"thisassignmentisforimplementingtheaffinecipher\n"}︡{"done":true}
︠745b45ea-4812-431e-b73d-06542e9fd0f8s︠

'''
cryptanalysis

In this section we perform cryptanaylsis using the three of the methods taught in the class viz. :
    1. Known Plaintext
    2. Chosen Plaintext
    3. Chosen Ciphertext

For each of these methods we use a common method to find the values of a and b because we know that
                            C(x)=aP(x)+b
Since a ∈ {1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25} and b ∈ Z26, we have 26*12 pairs to check

'''

'''
First we implement the function to get the keys a and b:

1. Find a:

This can be found by the fact that
    C(x)=aP(x)+b
    Therefore :
    C(x1)-C(x2)=aP(x1)+b-aP(x2)-b
               =a(P(x1)-P(x2))
    So by iterating through the set Z*26, the value of a for which the above equality holds is a candidate for a

2. Find b:
This can be found by the fact that
    C(x)=aP(x)+b'
    => b'= C(x)- aP(x)
Now the value of b for which b%26==b'%26 will result in the correct value of b
'''

def find_keys(ptxt,ctxt):
    zp_26=[1,3,5,7,9,11,15,17,19,21,23,25]
    for i in zp_26:
        a1=(ord(ctxt[1])-ord(ctxt[0]))%26
        a2=(i*(ord(ptxt[1])-ord(ptxt[0])))%26
        if(a1==a2):
            a=i
            b=ord(ctxt[0])-((ord(ptxt[0])*a)%26)
    return a,b%26

#Known Plaintext Attack



def known_plaintext(cipher_txt):
    known_ptxt='beholdthesamplepieceofplaintextthathasbeenchosenfortheknownplaintextattack'
    known_ctxt= 'zyxmnhtxyciednydoyqympdniovtyjttxitxiczyyvqxmcyvpmltxywvmsvdniovtyjtittiqw'
    a,b=find_keys(known_ptxt,known_ctxt)
    b=b-(a//2)
    print(a,b)
    dec_ptxt=affine_cipher_decrypt(cipher_txt,a,b)
    return dec_ptxt

msg='txoctyjtoceyivttmzyyvqladtyhkcovgippovyqodxyl'
known_plaintext(msg)
︡e4e19451-95b3-4a51-9a0c-195ba8a7d125︡{"stdout":"'\\ncryptanalysis\\n\\nIn this section we perform cryptanaylsis using the three of the methods taught in the class viz. :\\n    1. Known Plaintext\\n    2. Chosen Plaintext\\n    3. Chosen Ciphertext\\n\\nFor each of these methods we use a common method to find the values of a and b because we know that\\n                            C(x)=aP(x)+b\\nSince a ∈ {1, 3, 5, 7, 9, 11, 15, 17, 19, 21, 23, 25} and b ∈ Z26, we have 26*12 pairs to check\\n\\n'\n"}︡{"stdout":"\"\\nFirst we implement the function to get the keys a and b:\\n\\n1. Find a:\\n\\nThis can be found by the fact that\\n    C(x)=aP(x)+b\\n    Therefore :\\n    C(x1)-C(x2)=aP(x1)+b-aP(x2)-b\\n               =a(P(x1)-P(x2))\\n    So by iterating through the set Z*26, the value of a for which the above equality holds is a candidate for a\\n\\n2. Find b:\\nThis can be found by the fact that\\n    C(x)=aP(x)+b'\\n    => b'= C(x)- aP(x)\\nNow the value of b for which b%26==b'%26 will result in the correct value of b\\n\"\n"}︡{"stdout":"17 8\n'thistextismeanttobeencryptedusingaffinecipher'\n"}︡{"done":true}
︠39311641-24ce-490f-869b-9a57ee4112e5s︠

def chosen_plain_text_attack(cipher_txt):
    chosen_plain_text='thisisthechosenplaintextforthisparticularattack'
    alice_encrypt=affine_cipher_encrypt(chosen_plain_text)
    a,b=find_keys(chosen_plain_text,alice_encrypt)
    b=b-(a//2)
    print(a,b)
    dec_ptxt=affine_cipher_decrypt(cipher_txt,a,b)
    return dec_ptxt

msg='txyhkmovtxytlomzyxmnhtxyqxmcyvdniovtyjtittiqw'
chosen_plain_text_attack(msg)
︡4c7a1814-e9f3-473d-bbf2-e67b7c051b2b︡{"stdout":"17 8\n'theduointhetriobeholdthechosenplaintextattack'\n"}︡{"done":true}
︠bf56d078-09c6-4f2e-8625-f611a38b4a03s︠

def chosen_cipher_text_attack(cipher_txt):
    chosen_cipher_text='txococtxyqxmcyvdniovtyjtpmltxocdiltoqknilittiqw'
    bob_decrypt=affine_cipher_decrypt_2(chosen_cipher_text) #bob already has the keys so he can decrypt by that
    a,b=find_keys(bob_decrypt,chosen_cipher_text)
    b=b-(a//2)
    print(a,b)
    dec_ptxt=affine_cipher_decrypt(cipher_txt,a,b)
    return dec_ptxt

msg='ivhnictzktvmttxynyictvmsillobyctxytlohyvtyhqxmcyvqodxyltyjtittiqwxyxy'
chosen_cipher_text_attack(msg)
︡4b20ac56-39b6-4580-bfb7-7f005f395f2a︡{"stdout":"17 8\n'andlastbutnottheleastnowarrivesthetridentedchosenciphertextattackhehe'\n"}︡{"done":true}
︠2db59dc6-455e-4cc7-b69f-b6672e562758︠









