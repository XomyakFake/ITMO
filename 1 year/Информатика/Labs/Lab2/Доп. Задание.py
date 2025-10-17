print("Введите r1 r2 i1 r3 i2 i3 i4")
arr = input()
res = list(arr)
names = ["r1", "r2", "i1", "r3", "i2", "i3", "i4"]
err = "Ошибок нет"
if len(arr) == 7 and all(s in "01" for s in arr):
    s1 = (int(arr[0]) + int(arr[2]) + int(arr[4]) + int(arr[6])) % 2
    s2 = (int(arr[1]) + int(arr[2]) + int(arr[5]) + int(arr[6])) % 2
    s3 = (int(arr[3]) + int(arr[4]) + int(arr[5]) + int(arr[6])) % 2
    a1 = [1,0,1,0,1,0,1]
    a2 = [0,1,1,0,0,1,1]
    a3 = [0,0,0,1,1,1,1]
    if s1 != 0 or s2 != 0 or s3 != 0:
        for i in range(7):
            if a1[i] == s1 and a2[i] == s2 and a3[i] == s3:
                err = names[i]
                if res[i] == '0':
                    res[i] = '1'
                else:
                    res[i] = '0'
                break
        print("Информационные биты:", res[2] + res[4] + res[5] + res[6])
        print("Ошибка в",err)
    else:
        print(err)
else:
    print("Неверный ввод")
