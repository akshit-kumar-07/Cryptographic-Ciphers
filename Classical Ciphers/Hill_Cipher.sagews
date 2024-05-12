︠974a10ab-3be8-4a1a-8d16-4816b2505f94s︠
from sympy import Matrix

#for hill cipher encryption is p*k mod 26 where p is matrix of plaintext and k is the key matrix

#encryption begins

#plain_text='thistextisforbeingusedinthehillscipherencryption'
plain_text='thisrandomtextisforcheckingifthehillcipherisworkingproperlywithrandomlength'

len_org=len(plain_text)

z=0

if len(plain_text)%4!=0:
    z=len(plain_text)//4
    z+=1
    z*=4
    z-=len(plain_text)
    for i in range(z):
        plain_text+='x'

len(plain_text)

#len(plain_text)
#this code will encrypt using polygraph with n=4



#create the matrix of plaintext



def make_ptm(plain_text):
    plaintext_mat=[] #will be later converted to n x 4 matrix
    temp=[] #will be used to store rows in the matrix
    for ch in plain_text:
        temp.append(ord(ch)%97)
        if len(temp)==4:
            plaintext_mat.append(temp) #append the row to the matrix
            temp=[] #make the temp row blank again
    return plaintext_mat
#convert the 2-d array to matrix object

plain_text_matrix=Matrix(make_ptm(plain_text))
plain_text_matrix
︡d99ad2ab-1af9-470d-acf8-621611dece28︡{"stdout":"76\n"}︡{"stdout":"Matrix([\n[19,  7,  8, 18],\n[17,  0, 13,  3],\n[14, 12, 19,  4],\n[23, 19,  8, 18],\n[ 5, 14, 17,  2],\n[ 7,  4,  2, 10],\n[ 8, 13,  6,  8],\n[ 5, 19,  7,  4],\n[ 7,  8, 11, 11],\n[ 2,  8, 15,  7],\n[ 4, 17,  8, 18],\n[22, 14, 17, 10],\n[ 8, 13,  6, 15],\n[17, 14, 15,  4],\n[17, 11, 24, 22],\n[ 8, 19,  7, 17],\n[ 0, 13,  3, 14],\n[12, 11,  4, 13],\n[ 6, 19,  7, 23]])\n"}︡{"done":true}
︠1f95ba6f-c724-40c1-a42d-8b6b03bcd42es︠
#create the key matrix



key='uixvmwqnzbfkdwno'
def make_km(key):
    key_mat=[]
    x=0
    for i in range(4):
        temp=[]
        for j in range(4):
            temp.append((ord(key[x]))%97)
            x+=1
        key_mat.append(temp)
    return key_mat

key_matrix=Matrix(make_km(key))
key_matrix
︡361aa15b-512a-443f-b4f9-15e0c5abcbe0︡{"stdout":"Matrix([\n[20,  8, 23, 21],\n[12, 22, 16, 13],\n[25,  1,  5, 10],\n[ 3, 22, 13, 14]])\n"}︡{"done":true}
︠a4d27a95-306a-48e1-a381-805c1e68f3a2s︠
#now we have both P and K. Hence, encryption will be P*K mod 26

#encryption

cipher_mat=(plain_text_matrix*key_matrix)%26

ciphertext=''
for i in list(cipher_mat):
    ciphertext+=chr((i%26)+97)
ciphertext
︡6f66bd44-f113-4bd4-b013-f0a223d8d00c︡{"stdout":"'qirqyhbjbplugspwxtiricbvwmgpvhmkyrtvmxceseonxtjsrktjlborucliqfqvnzpfrerturwl'\n"}︡{"done":true}
︠3f9b9a02-9ded-463a-b87c-befaee71db64s︠
#decryption starts

#for decryption we have p=(c*k^-1)mod 26
#hence we need to find the matrix for the ciphertext (can be done using the above code) and the inverse matrix

#find the C matrix

def make_ctm(ciphertext):
    ciphertext_mat=[] #will be later converted to 4 x 4 matrix
    temp=[] #will be used to store rows in the matrix

    for ch in ciphertext:
        temp.append(ord(ch)%97)
        if len(temp)==4:
            ciphertext_mat.append(temp) #append the row to the matrix
            temp=[] #make the temp row blank again
    return ciphertext_mat

#convert the 2-d array to matrix object

cipher_text_matrix=Matrix(make_ctm(ciphertext))
cipher_text_matrix
︡067a12bd-3578-4436-97f0-0584b31c89a3︡{"stdout":"Matrix([\n[16,  8, 17, 16],\n[24,  7,  1,  9],\n[ 1, 15, 11, 20],\n[ 6, 18, 15, 22],\n[23, 19,  8, 17],\n[ 8,  2,  1, 21],\n[22, 12,  6, 15],\n[21,  7, 12, 10],\n[24, 17, 19, 21],\n[12, 23,  2,  4],\n[18,  4, 14, 13],\n[23, 19,  9, 18],\n[17, 10, 19,  9],\n[11,  1, 14, 17],\n[20,  2, 11,  8],\n[16,  5, 16, 21],\n[13, 25, 15,  5],\n[17,  4, 17, 19],\n[20, 17, 22, 11]])\n"}︡{"done":true}
︠fe5f3e8f-85e3-4dec-b3a6-91fc0c2e6bbes︠
#Now we need to find the inverse of the key matrix which can be be found out by normal Gaussian elemination function of sympy

k_inverse=Matrix(key_mat).inv_mod(26) #the inverse mod function will calculate the mod 26 part of our calculation
k_inverse
︡ce7007b4-f3c5-4ea4-8c6e-78ac195f90d7︡{"stdout":"Matrix([\n[13,  7, 14,  3],\n[ 4, 14,  7, 15],\n[ 1, 17, 14,  8],\n[16,  9, 12,  0]])\n"}︡{"done":true}
︠7fc5b178-679e-4a66-91b3-043af33dfc47s︠
#now we apply the formula p=c*(k^-1)%26

ptxt=(cipher_text_matrix*k_inverse)%26
ptxt
︡b1f10110-eb39-46bc-ba29-707c2128eab4︡{"stdout":"Matrix([\n[19,  7,  8, 18],\n[17,  0, 13,  3],\n[14, 12, 19,  4],\n[23, 19,  8, 18],\n[ 5, 14, 17,  2],\n[ 7,  4,  2, 10],\n[ 8, 13,  6,  8],\n[ 5, 19,  7,  4],\n[ 7,  8, 11, 11],\n[ 2,  8, 15,  7],\n[ 4, 17,  8, 18],\n[22, 14, 17, 10],\n[ 8, 13,  6, 15],\n[17, 14, 15,  4],\n[17, 11, 24, 22],\n[ 8, 19,  7, 17],\n[ 0, 13,  3, 14],\n[12, 11,  4, 13],\n[ 6, 19,  7, 23]])\n"}︡{"done":true}
︠e09869a3-374d-4824-aac6-7b97d22c86bfs︠
list(ptxt)
︡a81f0438-53e3-419b-92b8-8fee6761c48b︡{"stdout":"[19, 7, 8, 18, 17, 0, 13, 3, 14, 12, 19, 4, 23, 19, 8, 18, 5, 14, 17, 2, 7, 4, 2, 10, 8, 13, 6, 8, 5, 19, 7, 4, 7, 8, 11, 11, 2, 8, 15, 7, 4, 17, 8, 18, 22, 14, 17, 10, 8, 13, 6, 15, 17, 14, 15, 4, 17, 11, 24, 22, 8, 19, 7, 17, 0, 13, 3, 14, 12, 11, 4, 13, 6, 19, 7, 23]\n"}︡{"done":true}
︠28bcf50d-1478-4024-97aa-8d00e3ed49e7s︠
#create the plaintext

plain_txt=''
for i in list(ptxt):
    plain_txt+=chr(i+97)
plain_txt=plain_txt[:len_org-z+1]
plain_txt
︡c6c7d62a-8c90-4a38-b2a1-51bc755ac9b7︡{"stdout":"'thisrandomtextisforcheckingifthehillcipherisworkingproperlywithrandomlength'\n"}︡{"done":true}
︠c8b68823-fac1-4cd6-a906-c304e149041es︠


#Cryptanalysis

'''
We know that for hill cipher C=PK mod 26
=> For K=CP^-1 mod 26
Hence for the cryptanalysis we need the ciphertext and plaintext.
Hence, we use the Known Plaintext Attack for the cryptanalysis of Hill Cipher
However, since we need to calculate the inverse of the plaintext matrix we need to asssure that the corresponding plaintext matrix is invertible.
Hence, for the purpose of this cryptananlysis we assume that the chosen plaintext is such that the determinant of the matrix is coprime to 26.

'''
︡527ff4e0-8e46-4d24-ad86-e716abc1c7e2︡{"stdout":"'\\nWe know that for hill cipher C=PK mod 26\\n=> For K=CP^-1 mod 26\\nHence for the cryptanalysis we need the ciphertext and plaintext.\\nHence, we use the Known Plaintext Attack for the cryptanalysis of Hill Cipher\\nHowever, since we need to calculate the inverse of the plaintext matrix we need to asssure that the corresponding plaintext matrix is invertible.\\nHence, for the purpose of this cryptananlysis we assume that the chosen plaintext is such that the determinant of the matrix is coprime to 26.\\n\\n'\n"}︡{"done":true}
︠5d16d916-022c-4850-a988-dd7d1c849f84︠

# Cryptanalysis

plaintext='edwujlkipaonrmzq'
ciphertext='yoqzogrynemnnxgz'

plain_text_matrix=Matrix(make_ptm(plaintext))
plain_text_matrix
︡1205f636-288e-4957-80fb-e2c42419ed29︡{"stdout":"'plaintext_mat=[] #will be later converted to n x 4 matrix\\ntemp=[] #will be used to store rows in the matrix\\n\\nfor ch in plaintext:\\n    temp.append(ord(ch)%97)\\n    if len(temp)==4:\\n        plaintext_mat.append(temp) #append the row to the matrix\\n        temp=[] #make the temp row blank again\\n\\n#convert the 2-d array to matrix object'\n"}︡{"stdout":"Matrix([\n[ 4,  3, 22, 20],\n[ 9, 11, 10,  8],\n[15,  0, 14, 13],\n[17, 12, 25, 16]])\n"}︡{"done":true}
︠41137d40-7b90-4c12-99c4-f47ffeabf021︠


cipher_text_matrix=Matrix(make_ctm(ciphertext))
cipher_text_matrix
︡0f65f3eb-dab8-44b4-9e66-f476b2af315e︡{"stdout":"'ciphertext_mat=[] #will be later converted to 4 x 4 matrix\\ntemp=[] #will be used to store rows in the matrix\\n\\nfor ch in ciphertext:\\n    temp.append(ord(ch)%97)\\n    if len(temp)==4:\\n        ciphertext_mat.append(temp) #append the row to the matrix\\n        temp=[] #make the temp row blank again\\n\\n#convert the 2-d array to matrix object'\n"}︡{"stdout":"Matrix([\n[24, 14, 16, 25],\n[14,  6, 17, 24],\n[13,  4, 12, 13],\n[13, 23,  6, 25]])\n"}︡{"done":true}
︠68668d49-28bc-4c82-955e-16e8186c79acs︠

pt_inv=plain_text_matrix.inv_mod(26)
pt_inv
︡e71de44e-4168-468d-85de-0f465219e0f7︡{"stdout":"Matrix([\n[11, 3,  2, 14],\n[23, 6, 10,  4],\n[17, 7, 10, 11],\n[ 3, 9, 17,  4]])\n"}︡{"done":true}
︠a73c9a4d-ca36-4e94-85c2-a5e16afadfe8s︠
key=(pt_inv*cipher_text_matrix)%26
key
︡fac1b97e-bab2-4a90-8635-4b13693f22af︡{"stdout":"Matrix([\n[20,  8, 23, 21],\n[12, 22, 16, 13],\n[25,  1,  5, 10],\n[ 3, 22, 13, 14]])\n"}︡{"done":true}
︠bb77ac2a-9a87-49c1-94b3-0e7aa3b452ef︠









