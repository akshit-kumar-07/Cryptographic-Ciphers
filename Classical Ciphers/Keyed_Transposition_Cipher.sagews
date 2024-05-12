︠679da4a5-07d0-489e-aa34-c36173b7e656s︠
import math
plain_text='thistextissupposedtobeencrypted'
len_pt=len(plain_text)
len_pt
︡fc988c20-8e8f-4db1-9952-d0fdf787f702︡{"stdout":"31\n"}︡{"done":true}
︠e2371c78-2fa0-4b9a-99be-49633d41a0a9s︠
key=43215 #we will use five columns
#now calculate the number of rows
rows=math.ceil(len_pt/5)
rows
︡cd30b190-0c98-4855-b51f-a73ec422da5f︡{"stdout":"7\n"}︡{"done":true}
︠8c28b334-6555-4d5f-b33a-1082cce4eb72︠
#calculate the value of padding characters
excess=rows*5-len_pt
for i in range(excess):
    plain_text+='x'
plain_text
︡6ddd2aff-933c-4404-9eec-e365a4ab7d59︡{"stdout":"'thistextissupposedtobeencryptedxxxx'\n"}︡{"done":true}
︠5ce77128-d73c-4eae-9179-48ea678be02e︠
#create the matrix
mat=[]
l=0
for i in range(rows):
    x=[]
    for j in range(5):
        x.append(plain_text[l])
        l+=1
    mat.append(x)
mat
︡39a94678-3f71-4f47-81bb-7c218fd0e863︡{"stdout":"[['t', 'h', 'i', 's', 't'], ['e', 'x', 't', 'i', 's'], ['s', 'u', 'p', 'p', 'o'], ['s', 'e', 'd', 't', 'o'], ['b', 'e', 'e', 'n', 'c'], ['r', 'y', 'p', 't', 'e'], ['d', 'x', 'x', 'x', 'x']]\n"}︡{"done":true}
︠97cd2b3b-357e-4608-bbe7-a6390cbc6146s︠
key_s=str(key)
key_s
︡ab9d1f75-8e90-4f76-bfe2-164474689cf5︡{"stdout":"'43215'\n"}︡{"done":true}
︠6f6a75db-511c-4342-968e-d08e1bb0ea9a︠
#create the ciphertext using the given key
#encryption
ciphertxt=''
for i in range(5):
    c=int(key_s[i])-1
    for j in range(rows):
        ciphertxt+=mat[j][c]
ciphertxt
︡59e6e3a2-179d-47f4-87a4-614c6e370c10︡{"stdout":"'siptntxitpdepxhxueeyxtessbrdtsoocex'\n"}︡{"done":true}
︠58494c63-2a59-488a-abc2-eacffd32d88fs︠

#decryption


#now we need to create 5*rows matrix and then use the key to regain the plaintext from the ciphertext

mat=[]
l=0

for i in range(5):
    x=[]
    for j in range(rows):
        x.append(ciphertxt[l])
        l+=1
    mat.append(x)
mat
︡74df0267-4a14-4a81-b371-e2f705d1bf7e︡{"stdout":"[['s', 'i', 'p', 't', 'n', 't', 'x'], ['i', 't', 'p', 'd', 'e', 'p', 'x'], ['h', 'x', 'u', 'e', 'e', 'y', 'x'], ['t', 'e', 's', 's', 'b', 'r', 'd'], ['t', 's', 'o', 'o', 'c', 'e', 'x']]\n"}︡{"done":true}
︠ad09ff7d-04e7-48f9-a6b3-830bff672199s︠
plain_text=''

for i in range(rows):
    for j in range(5):
        x=int(key_s[j])-1
        plain_text+=mat[x][i]

plain_text=plain_text[0:len_pt]
plain_text
︡3beebf01-8896-440e-a8b2-8072a6e17f61︡{"stdout":"'thistextissupposedtobeencrypted'\n"}︡{"done":true}
︠18b1e310-1968-4297-8ffd-3a23fd010d95︠
        









