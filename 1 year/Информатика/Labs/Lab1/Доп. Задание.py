def fib(m):
    if m <= 1:
        return m
    return fib(m-1) + fib(m-2)

print("Программа перевода из СС Цекендорфа в десятичную")
x = input("Введите число в СС Цекендорфа: ")
n = len(x)
res = 0
if x.isdigit() and n == x.count('1') + x.count('0') and '11' not in x:
    for i in range(n):
        if x[i] == '1':
            res += fib(n-i+1)
    print(f'Результат:{res}')
else:
    print("Число не в СС Цекендорфа или две единицы стоят рядом")
