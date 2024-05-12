︠735e597a-0187-4df8-aa2b-5749b6627aads︠
#encrypt

plain_text='thistextissupposedtobeencryptedbysubstitutioncipher'
#plain_text='areyouwillingtotrythisampletexttobreakthesubstitutioncipher'

key='qwertyuiopzxcvbnmlkjhgfdsa'
def encrypt(plain_text,key):
  cipher_text=''
  for i in plain_text:
      cipher_text+=key[ord(i)%97]
  return cipher_text
cipher_text=encrypt(plain_text,key)
cipher_text
︡0463e70c-6803-4797-b833-50d5fd7e36db︡{"stdout":"'jiokjtdjokkhnnbktrjbwttvelsnjtrwskhwkjojhjobveonitl'\n"}︡{"done":true}
︠90cdadc2-803b-4d64-bb6c-6a02321807acs︠
#decrypt

def decrypt(cipher_text,key):
  plain_text=''
  for i in cipher_text:
      plain_text+=chr(97+key.index(str(i)))
  return plain_text
decrypt(cipher_text,key)
︡a5e921ea-3291-4b64-80b9-d3c29690ba4b︡{"stdout":"'thistextissupposedtobeencryptedbysubstitutioncipher'\n"}︡{"done":true}
︠f289fc9f-648d-4c37-8c9c-034e7385ee8as︠
def shift_cipher_cryptanalysis():
  kptxt='mnbvcxzasdfghjklpoiuytrewq'
  kctxt='qwertyuioplkjhgzxcvfdsabnm'
  if(len(set(kptxt))!=26):
    print("Cannot find the complete key")
    return
  if(len(kptxt)==len(kctxt)) and len(set(kptxt))==len(set(kctxt)):
    key={}
    j=0
    for i in kptxt:
      key[i]=kctxt[j]
      j+=1
    return key
shift_cipher_cryptanalysis()
︡40205f75-7ecc-46bc-9159-6f5b9bd520b1︡{"stdout":"{'m': 'q', 'n': 'w', 'b': 'e', 'v': 'r', 'c': 't', 'x': 'y', 'z': 'u', 'a': 'i', 's': 'o', 'd': 'p', 'f': 'l', 'g': 'k', 'h': 'j', 'j': 'h', 'k': 'g', 'l': 'z', 'p': 'x', 'o': 'c', 'i': 'v', 'u': 'f', 'y': 'd', 't': 's', 'r': 'a', 'e': 'b', 'w': 'n', 'q': 'm'}\n"}︡{"done":true}
︠eb748207-3cd0-4c05-8bb6-bd85a74e2d45︠









