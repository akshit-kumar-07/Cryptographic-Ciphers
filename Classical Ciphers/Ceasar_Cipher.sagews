︠edfb37fe-9cee-4cc4-84e3-924ff4e5d881s︠
#encryption

plain_text='thisistheplaintextthatwillbeusedforbruteforceattack'
#plain_text='thistextissupposedtobeencryptedbyshiftcipher'
#plain_text='letstestthisknownptxtattackwiththisstring'
cipher_text=''
n=7 #denotes the shift amt
def shift_encrypt(plain_text):
  cipher_text=''
  for i in plain_text:
      cipher_text+=chr((ord(i)%97+n)%26+97)
  return cipher_text
cipher_text=shift_encrypt(plain_text)
cipher_text
︡b64863bd-5d05-40c2-8bd5-d42f281d0db3︡{"stdout":"'aopzpzaolwshpualeaaohadpssilbzlkmvyiybalmvyjlhaahjr'\n"}︡{"done":true}
︠3c9fa05e-390a-4214-9be3-3046c92ed5a1s︠
#encrypt key

def encrypt_key(ptxt,n):
  cipher_text=''
  for i in plain_text:
      cipher_text+=chr((ord(i)%97+n)%26+97)
  return cipher_text
encrypt_key(plain_text,5)

#decryption

def decrypt(ctxt):
  plain_text=''
  for i in cipher_text:
      plain_text+=chr((ord(i)%97-n)%26+97)
  return plain_text
decrypt(cipher_text)
︡c1c0e7c4-e3eb-406e-8f95-d8d0a08a0c6c︡{"stdout":"'ymnxnxymjuqfnsyjcyymfybnqqgjzxjiktwgwzyjktwhjfyyfhp'\n"}︡{"stdout":"'thisistheplaintextthatwillbeusedforbruteforceattack'\n"}︡{"done":true}
︠cd7cd4ba-3dad-4252-a55d-db6ddc323cfbs︠

def shift_decrypt(ctxt,n):
  plain_text=''
  for i in cipher_text:
      plain_text+=chr((ord(i)%97-n)%26+97)
  return plain_text
shift_decrypt(cipher_text,5)
︡e1ff8d55-e485-4092-a364-3c74d5679e22︡{"stdout":"'vjkukuvjgrnckpvgzvvjcvyknndgwugfhqtdtwvghqtegcvvcem'\n"}︡{"done":true}
︠02a82b16-d090-4756-81a1-b63248ba6886s︠
#Cryptanalysis:

'''
    This cryptanalysis will be done by four methods:
        1. Known Plaintext Attack
        2. Chosen Plaintext Attack
        3. chosen Ciphertext Attack
        4. statistical attack using sage
'''


︡92d898a6-4d59-4d05-b02f-c22fa6e7e009︡{"stdout":"'\\n    This cryptanalysis will be done by four methods:\\n        1. Known Plaintext Attack\\n        2. Chosen Plaintext Attack\\n        3. chosen Ciphertext Attack\\n        4. statistical attack using sage\\n'\n"}︡{"done":true}
︠e80718bf-8532-4134-86d4-c9934df84b8fs︠

# Known Plaintext Attack

def known_plaintext_attack(msg):
  kpt='thistextissupposedtobeencryptedbyshiftcipher'
  kct='ymnxyjcynxxzuutxjiytgjjshwduyjigdxmnkyhnumjw'
  key=chr(97+(ord(kct[0])-ord(kpt[0])))
  ans=shift_decrypt(msg,n)
  return ans
known_plaintext_attack('qjyxyjxyymnxpstbsuycyfyyfhpbnymymnxxywnsl')
︡36ce5b09-5364-4bb6-88f2-37d69988a2b9︡{"stdout":"'thisistheplaintextthatwillbeusedforbruteforceattack'\n"}︡{"done":true}
︠02ec5d0c-3b27-4c91-b509-bc9592fdd70bs︠

# chosen Plaintext Attack

def chosen_plaintext_attack(msg):
  cpt='thistextissupposedtobeencryptedbyshiftcipher'
  alice_encrypt=shift_encrypt(cpt)
  key=chr(97+(ord(alice_encrypt[0])-ord(cpt[0])))
  ans=shift_decrypt(msg,n)
  return ans
chosen_plaintext_attack('qjyxyjxyymnxpstbsuycyfyyfhpbnymymnxxywnsl')
︡a1dd25e1-a521-4e2d-a2af-9ba93fb20716︡{"stdout":"'thisistheplaintextthatwillbeusedforbruteforceattack'\n"}︡{"done":true}
︠4ef90c06-2553-424e-bfa1-c9af760bc5d3s︠

#Chosen Ciphertext Attack

def chosen_ciphertext_attack(msg):
  cct='ymnxyjcynxxzuutxjiytgjjshwduyjigdxmnkyhnumjw'
  bob_decrypt=decrypt(cct)
  key=chr(97+(ord(cct[0])-ord(bob_decrypt[0])))
  ans=shift_decrypt(msg,n)
  return ans
chosen_ciphertext_attack('qjyxyjxyymnxpstbsuycyfyyfhpbnymymnxxywnsl')
︡1ca3728a-6783-492b-9b54-42e48a1f296f︡{"stdout":"'thisistheplaintextthatwillbeusedforbruteforceattack'\n"}︡{"done":true}
︠9c15ac14-ea51-46e0-8113-9bb7b8092903s︠

#Brute Force Attack

S=ShiftCryptosystem(AlphabeticStrings())
S
︡ccdde77f-9026-4847-bd3d-bd4609f68d13︡{"stdout":"Shift cryptosystem on Free alphabetic string monoid on A-Z\n"}︡{"done":true}
︠7ae2c8d5-2071-477a-9f53-130b38a6d742s︠
P=S.encoding("This is the plaintext that will be used for brute force attack on the shift cryptosystem")
P
︡e07417ca-409a-4f6b-bff0-36549f81d3ed︡{"stdout":"THISISTHEPLAINTEXTTHATWILLBEUSEDFORBRUTEFORCEATTACKONTHESHIFTCRYPTOSYSTEM\n"}︡{"done":true}
︠d2a9581b-b200-4294-aa57-f6aeb590a676s︠
K=7 #key
C=S.enciphering(K,P) #encryption
C
︡85aab7c6-a2d2-4d24-a383-5bb08320b7f6︡{"stdout":"AOPZPZAOLWSHPUALEAAOHADPSSILBZLKMVYIYBALMVYJLHAAHJRVUAOLZOPMAJYFWAVZFZALT\n"}︡{"done":true}
︠86e79be5-3c2f-46fa-94fa-fbb4e23a2800s︠
S.deciphering(K,C)==P #decryption
︡cb3c1ede-bceb-49b6-9841-e8458b405b56︡{"stdout":"True\n"}︡{"done":true}
︠805614ec-d4d2-4d95-ac88-31b707c1cda3s︠

dict=S.brute_force(C,ranking='none')
dict
︡46028d8e-2531-491c-9ced-2ec07e38e5dc︡{"stdout":"{0: AOPZPZAOLWSHPUALEAAOHADPSSILBZLKMVYIYBALMVYJLHAAHJRVUAOLZOPMAJYFWAVZFZALT, 1: ZNOYOYZNKVRGOTZKDZZNGZCORRHKAYKJLUXHXAZKLUXIKGZZGIQUTZNKYNOLZIXEVZUYEYZKS, 2: YMNXNXYMJUQFNSYJCYYMFYBNQQGJZXJIKTWGWZYJKTWHJFYYFHPTSYMJXMNKYHWDUYTXDXYJR, 3: XLMWMWXLITPEMRXIBXXLEXAMPPFIYWIHJSVFVYXIJSVGIEXXEGOSRXLIWLMJXGVCTXSWCWXIQ, 4: WKLVLVWKHSODLQWHAWWKDWZLOOEHXVHGIRUEUXWHIRUFHDWWDFNRQWKHVKLIWFUBSWRVBVWHP, 5: VJKUKUVJGRNCKPVGZVVJCVYKNNDGWUGFHQTDTWVGHQTEGCVVCEMQPVJGUJKHVETARVQUAUVGO, 6: UIJTJTUIFQMBJOUFYUUIBUXJMMCFVTFEGPSCSVUFGPSDFBUUBDLPOUIFTIJGUDSZQUPTZTUFN, 7: THISISTHEPLAINTEXTTHATWILLBEUSEDFORBRUTEFORCEATTACKONTHESHIFTCRYPTOSYSTEM, 8: SGHRHRSGDOKZHMSDWSSGZSVHKKADTRDCENQAQTSDENQBDZSSZBJNMSGDRGHESBQXOSNRXRSDL, 9: RFGQGQRFCNJYGLRCVRRFYRUGJJZCSQCBDMPZPSRCDMPACYRRYAIMLRFCQFGDRAPWNRMQWQRCK, 10: QEFPFPQEBMIXFKQBUQQEXQTFIIYBRPBACLOYORQBCLOZBXQQXZHLKQEBPEFCQZOVMQLPVPQBJ, 11: PDEOEOPDALHWEJPATPPDWPSEHHXAQOAZBKNXNQPABKNYAWPPWYGKJPDAODEBPYNULPKOUOPAI, 12: OCDNDNOCZKGVDIOZSOOCVORDGGWZPNZYAJMWMPOZAJMXZVOOVXFJIOCZNCDAOXMTKOJNTNOZH, 13: NBCMCMNBYJFUCHNYRNNBUNQCFFVYOMYXZILVLONYZILWYUNNUWEIHNBYMBCZNWLSJNIMSMNYG, 14: MABLBLMAXIETBGMXQMMATMPBEEUXNLXWYHKUKNMXYHKVXTMMTVDHGMAXLABYMVKRIMHLRLMXF, 15: LZAKAKLZWHDSAFLWPLLZSLOADDTWMKWVXGJTJMLWXGJUWSLLSUCGFLZWKZAXLUJQHLGKQKLWE, 16: KYZJZJKYVGCRZEKVOKKYRKNZCCSVLJVUWFISILKVWFITVRKKRTBFEKYVJYZWKTIPGKFJPJKVD, 17: JXYIYIJXUFBQYDJUNJJXQJMYBBRUKIUTVEHRHKJUVEHSUQJJQSAEDJXUIXYVJSHOFJEIOIJUC, 18: IWXHXHIWTEAPXCITMIIWPILXAAQTJHTSUDGQGJITUDGRTPIIPRZDCIWTHWXUIRGNEIDHNHITB, 19: HVWGWGHVSDZOWBHSLHHVOHKWZZPSIGSRTCFPFIHSTCFQSOHHOQYCBHVSGVWTHQFMDHCGMGHSA, 20: GUVFVFGURCYNVAGRKGGUNGJVYYORHFRQSBEOEHGRSBEPRNGGNPXBAGURFUVSGPELCGBFLFGRZ, 21: FTUEUEFTQBXMUZFQJFFTMFIUXXNQGEQPRADNDGFQRADOQMFFMOWAZFTQETURFODKBFAEKEFQY, 22: ESTDTDESPAWLTYEPIEESLEHTWWMPFDPOQZCMCFEPQZCNPLEELNVZYESPDSTQENCJAEZDJDEPX, 23: DRSCSCDROZVKSXDOHDDRKDGSVVLOECONPYBLBEDOPYBMOKDDKMUYXDROCRSPDMBIZDYCICDOW, 24: CQRBRBCQNYUJRWCNGCCQJCFRUUKNDBNMOXAKADCNOXALNJCCJLTXWCQNBQROCLAHYCXBHBCNV, 25: BPQAQABPMXTIQVBMFBBPIBEQTTJMCAMLNWZJZCBMNWZKMIBBIKSWVBPMAPQNBKZGXBWAGABMU}\n"}︡{"done":true}
︠f2cf55aa-4dbe-4c0e-a8a2-501cae2b7287s︠
#Now that we have the dictionary of the possible plaintexts using the shifting values from 0 to 25, we can use the statistical method of chi square ranking to rank these:

S.brute_force(C,ranking='chisquare')
︡128e0602-2e61-4eaf-a78f-ff3f7d55e4c3︡{"stdout":"[(7, THISISTHEPLAINTEXTTHATWILLBEUSEDFORBRUTEFORCEATTACKONTHESHIFTCRYPTOSYSTEM), (23, DRSCSCDROZVKSXDOHDDRKDGSVVLOECONPYBLBEDOPYBMOKDDKMUYXDROCRSPDMBIZDYCICDOW), (20, GUVFVFGURCYNVAGRKGGUNGJVYYORHFRQSBEOEHGRSBEPRNGGNPXBAGURFUVSGPELCGBFLFGRZ), (13, NBCMCMNBYJFUCHNYRNNBUNQCFFVYOMYXZILVLONYZILWYUNNUWEIHNBYMBCZNWLSJNIMSMNYG), (11, PDEOEOPDALHWEJPATPPDWPSEHHXAQOAZBKNXNQPABKNYAWPPWYGKJPDAODEBPYNULPKOUOPAI), (4, WKLVLVWKHSODLQWHAWWKDWZLOOEHXVHGIRUEUXWHIRUFHDWWDFNRQWKHVKLIWFUBSWRVBVWHP), (19, HVWGWGHVSDZOWBHSLHHVOHKWZZPSIGSRTCFPFIHSTCFQSOHHOQYCBHVSGVWTHQFMDHCGMGHSA), (6, UIJTJTUIFQMBJOUFYUUIBUXJMMCFVTFEGPSCSVUFGPSDFBUUBDLPOUIFTIJGUDSZQUPTZTUFN), (22, ESTDTDESPAWLTYEPIEESLEHTWWMPFDPOQZCMCFEPQZCNPLEELNVZYESPDSTQENCJAEZDJDEPX), (18, IWXHXHIWTEAPXCITMIIWPILXAAQTJHTSUDGQGJITUDGRTPIIPRZDCIWTHWXUIRGNEIDHNHITB), (8, SGHRHRSGDOKZHMSDWSSGZSVHKKADTRDCENQAQTSDENQBDZSSZBJNMSGDRGHESBQXOSNRXRSDL), (0, AOPZPZAOLWSHPUALEAAOHADPSSILBZLKMVYIYBALMVYJLHAAHJRVUAOLZOPMAJYFWAVZFZALT), (9, RFGQGQRFCNJYGLRCVRRFYRUGJJZCSQCBDMPZPSRCDMPACYRRYAIMLRFCQFGDRAPWNRMQWQRCK), (5, VJKUKUVJGRNCKPVGZVVJCVYKNNDGWUGFHQTDTWVGHQTEGCVVCEMQPVJGUJKHVETARVQUAUVGO), (15, LZAKAKLZWHDSAFLWPLLZSLOADDTWMKWVXGJTJMLWXGJUWSLLSUCGFLZWKZAXLUJQHLGKQKLWE), (24, CQRBRBCQNYUJRWCNGCCQJCFRUUKNDBNMOXAKADCNOXALNJCCJLTXWCQNBQROCLAHYCXBHBCNV), (25, BPQAQABPMXTIQVBMFBBPIBEQTTJMCAMLNWZJZCBMNWZKMIBBIKSWVBPMAPQNBKZGXBWAGABMU), (16, KYZJZJKYVGCRZEKVOKKYRKNZCCSVLJVUWFISILKVWFITVRKKRTBFEKYVJYZWKTIPGKFJPJKVD), (14, MABLBLMAXIETBGMXQMMATMPBEEUXNLXWYHKUKNMXYHKVXTMMTVDHGMAXLABYMVKRIMHLRLMXF), (12, OCDNDNOCZKGVDIOZSOOCVORDGGWZPNZYAJMWMPOZAJMXZVOOVXFJIOCZNCDAOXMTKOJNTNOZH), (21, FTUEUEFTQBXMUZFQJFFTMFIUXXNQGEQPRADNDGFQRADOQMFFMOWAZFTQETURFODKBFAEKEFQY), (2, YMNXNXYMJUQFNSYJCYYMFYBNQQGJZXJIKTWGWZYJKTWHJFYYFHPTSYMJXMNKYHWDUYTXDXYJR), (17, JXYIYIJXUFBQYDJUNJJXQJMYBBRUKIUTVEHRHKJUVEHSUQJJQSAEDJXUIXYVJSHOFJEIOIJUC), (3, XLMWMWXLITPEMRXIBXXLEXAMPPFIYWIHJSVFVYXIJSVGIEXXEGOSRXLIWLMJXGVCTXSWCWXIQ), (1, ZNOYOYZNKVRGOTZKDZZNGZCORRHKAYKJLUXHXAZKLUXIKGZZGIQUTZNKYNOLZIXEVZUYEYZKS), (10, QEFPFPQEBMIXFKQBUQQEXQTFIIYBRPBACLOYORQBCLOZBXQQXZHLKQEBPEFCQZOVMQLPVPQBJ)]\n"}︡{"done":true}
︠c44bbe28-2d52-4efd-9ab9-fb050c559e72s︠
#The top ranking is the actual plaintext that we have encrypted.

#the brute force dictionary can be easily generated as follows:

def my_brute_force(msg,key):
    ans=[]
    for i in range (26):
        ans.append((i,shift_decrypt(msg,i)))
    return ans
msg=encrypt_key('thisistheplaintextthatwillbeusedforbruteforceattack',7)
my_brute_force(msg,7)
︡782f2cfb-e9b4-46fa-a924-a37ec7fe0a91︡{"stdout":"[(0, 'aopzpzaolwshpualeaaohadpssilbzlkmvyiybalmvyjlhaahjr'), (1, 'znoyoyznkvrgotzkdzzngzcorrhkaykjluxhxazkluxikgzzgiq'), (2, 'ymnxnxymjuqfnsyjcyymfybnqqgjzxjiktwgwzyjktwhjfyyfhp'), (3, 'xlmwmwxlitpemrxibxxlexamppfiywihjsvfvyxijsvgiexxego'), (4, 'wklvlvwkhsodlqwhawwkdwzlooehxvhgirueuxwhirufhdwwdfn'), (5, 'vjkukuvjgrnckpvgzvvjcvyknndgwugfhqtdtwvghqtegcvvcem'), (6, 'uijtjtuifqmbjoufyuuibuxjmmcfvtfegpscsvufgpsdfbuubdl'), (7, 'thisistheplaintextthatwillbeusedforbruteforceattack'), (8, 'sghrhrsgdokzhmsdwssgzsvhkkadtrdcenqaqtsdenqbdzsszbj'), (9, 'rfgqgqrfcnjyglrcvrrfyrugjjzcsqcbdmpzpsrcdmpacyrryai'), (10, 'qefpfpqebmixfkqbuqqexqtfiiybrpbacloyorqbclozbxqqxzh'), (11, 'pdeoeopdalhwejpatppdwpsehhxaqoazbknxnqpabknyawppwyg'), (12, 'ocdndnoczkgvdiozsoocvordggwzpnzyajmwmpozajmxzvoovxf'), (13, 'nbcmcmnbyjfuchnyrnnbunqcffvyomyxzilvlonyzilwyunnuwe'), (14, 'mablblmaxietbgmxqmmatmpbeeuxnlxwyhkuknmxyhkvxtmmtvd'), (15, 'lzakaklzwhdsaflwpllzsloaddtwmkwvxgjtjmlwxgjuwsllsuc'), (16, 'kyzjzjkyvgcrzekvokkyrknzccsvljvuwfisilkvwfitvrkkrtb'), (17, 'jxyiyijxufbqydjunjjxqjmybbrukiutvehrhkjuvehsuqjjqsa'), (18, 'iwxhxhiwteapxcitmiiwpilxaaqtjhtsudgqgjitudgrtpiiprz'), (19, 'hvwgwghvsdzowbhslhhvohkwzzpsigsrtcfpfihstcfqsohhoqy'), (20, 'guvfvfgurcynvagrkggungjvyyorhfrqsbeoehgrsbeprnggnpx'), (21, 'ftueueftqbxmuzfqjfftmfiuxxnqgeqpradndgfqradoqmffmow'), (22, 'estdtdespawltyepieeslehtwwmpfdpoqzcmcfepqzcnpleelnv'), (23, 'drscscdrozvksxdohddrkdgsvvloeconpyblbedopybmokddkmu'), (24, 'cqrbrbcqnyujrwcngccqjcfruukndbnmoxakadcnoxalnjccjlt'), (25, 'bpqaqabpmxtiqvbmfbbpibeqttjmcamlnwzjzcbmnwzkmibbiks')]\n"}︡{"done":true}
︠927616da-409e-4c4f-a622-e0b024ae0ed9︠
#However, for ranking since we need the mathematical chi square function, we will use the in built version to avoid wrting custom code for chi square function.S









