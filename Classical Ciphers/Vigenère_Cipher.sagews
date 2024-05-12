︠9b43248a-aa75-4c00-a803-039de3896176s︠
#take the plaintext and the key

plain_text='thistextissupposedtobeencryptedbyvignerecipher'
#plain_text='letsseeifthevignereciphergetsbrokenbythechosenplaintextattack'
key='vignerecipher' #this key will be cyclically used to encrypt the charcters of the plaintext to create a polyalphabetic substitution encrypted ciphertext
lk=len(key)
ltxt=len(plain_text)

#encryption
def encrypt(plain_text):
    cipher_text=''
    for i in range(ltxt):
        char_a=ord(plain_text[i])%97 #from plaintext
        char_b=ord(key[i%lk])%97 #cyclic encryption using key
        cipher_text+=chr((char_a+char_b)%26+97) #polyalphabetic encryption
    return cipher_text

encrypt(plain_text)
︡acc3f8eb-a89a-42a4-883b-066db30ad30e︡{"stdout":"'opofxvbvqhzygkwyrhksdmtugitxzrhscxqvuiizkoclvv'\n"}︡{"done":true}
︠5c12ee23-32d0-47b4-bf13-8d3d6710bbc3s︠

#decryption

def decrypt(cipher_text):
  plain_text=''
  ltxt=len(cipher_text)
  for i in range(ltxt):
    char_a=ord(cipher_text[i])%97
    char_b=ord(key[i%lk])%97
    plain_text+=chr((char_a-char_b)%26+97)
  return plain_text

decrypt('opofxvbvqhzygkwyrhksdmtugitxzrhscxqvuiizkoclvv')
︡c999c8f3-8160-48e5-87bf-6af57e9cddc1︡{"stdout":"'thistextissupposedtobeencryptedbyvignerecipher'\n"}︡{"done":true}
︠e388d920-628c-4117-88f7-1d9ceb2c1161s︠


#Cryptanalysis
'''
The Cryptanalysis will be done by three different methods:
    1. Known Plaintext Attack
    2. Chosen Plaintext Attack
    3. Chosen Ciphertext Attack
'''

#Known Plaintext Attack

def decrypt_key(cipher_text,key):
  plain_text=''
  ltxt=len(cipher_text)
  for i in range(ltxt):
    char_a=ord(cipher_text[i])%97
    char_b=ord(key[i%lk])%97
    plain_text+=chr((char_a-char_b)%26+97)
  return plain_text
︡dca90235-36fc-4825-bf52-e155af73211b︡{"stdout":"'\\nThe Cryptanalysis will be done by three different methods:\\n    1. Known Plaintext Attack\\n    2. Chosen Plaintext Attack\\n    3. Chosen Ciphertext Attack\\n'\n"}︡{"done":true}
︠a48df347-8a47-4a70-8b53-1f8b52f804d1s︠
ct='opofxvbvqhzygkwyrhksdmtugitxzrhscxqvuiizkoclvv'
decrypt_key(ct,key)
︡944f345e-61e0-40b0-9dd4-5413e4483eca︡{"stdout":"'thistextissupposedtobeencryptedbyvignerecipher'\n"}︡{"done":true}
︠b464791c-5ec6-48a8-b924-c9f299a47f4bs︠
def find_key(ptxt,ctxt):
  alp='abcdefghijklmnopqrstuvwxyz'
  res=''
  for i in range(len(ptxt)):
    shift=(ord(ctxt[i])-(ord(ptxt[i])%26))%26
    res+=alp[shift%26]
  return res
︡4970eb58-a499-47f7-85a2-75a6797e09bb︡{"done":true}
︠35f323d5-3c53-4014-ba59-736f19ec147cs︠
def known_plaintext_attack():
  known_pt='thistextissupposedtobeencryptedbyvignerecipher'
  known_ct='opofxvbvqhzygkwyrhksdmtugitxzrhscxqvuiizkoclvv'
  key=find_key(known_pt,known_ct)
  return key
︡20113141-c97a-4c55-91ec-bf9e8bea80bb︡{"done":true}
︠49daface-ac0f-4bc3-b43e-08766366b247s︠
key=known_plaintext_attack()
decrypt_key('gmzfwviknioimdotrvvgkxwlvxzbyovfogvqfxyzknbwvrrtpprkzfznxkees',key)
︡df7827e9-3e49-4f98-aabb-6b25af8ee4c3︡{"stdout":"'letsseeifthevignereciphergetsbrokenbythechosenplaintextattack'\n"}︡{"done":true}
︠11468e33-14f0-44ab-b31b-452e905af04es︠


#Chosen Plaintext Attack

def chosen_plaintext_attack(cptxt):
    cipher=encrypt(cptxt)
    key=find_key(cptxt,cipher)
    return key
︡629fea07-ab68-47e5-9ccd-2c64478e0070︡{"done":true}
︠6230882a-3f64-41bf-bb8b-be20fa478d8ds︠
key=chosen_plaintext_attack('thistextissupposedtobeencryptedbyvignerecipher')
decrypt_key('gmzfwviknioimdotrvvgkxwlvxzbyovfogvqfxyzknbwvrrtpprkzfznxkees',key)
︡301f8566-3f2b-4dc7-90ab-b91b9ed8479f︡{"stdout":"'letsseeifthevignereciphergetsbrokenbythechosenplaintextattack'\n"}︡{"done":true}
︠e8fc997e-0019-4174-88c3-0a9134873489s︠

#chosen ciphertext attack

def chosen_ciphertext_attack(cctxt):
    plain=decrypt(cctxt)
    key=find_key(plain,cctxt)
    return key
︡76cecbdb-6b2b-4e40-974b-d107c82ef0f1︡{"done":true}
︠3b7f75cc-9788-4b68-be17-230b4d5d1574s︠
key=chosen_ciphertext_attack('opofxvbvqhzygkwyrhksdmtugitxzrhscxqvuiizkoclvv')
decrypt_key('gmzfwviknioimdotrvvgkxwlvxzbyovfogvqfxyzknbwvrrtpprkzfznxkees',key)
︡5f8d98b8-8d2c-4cf0-834d-dfd982bc9dec︡{"stdout":"'letsseeifthevignereciphergetsbrokenbythechosenplaintextattack'\n"}︡{"done":true}
︠c94ad3f7-45e0-4111-af2f-d6958c37c430︠









