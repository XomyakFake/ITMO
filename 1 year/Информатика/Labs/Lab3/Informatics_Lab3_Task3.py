# Author = Efimov Anton Dmitrievich
# Group = P3118
# Date = 06.11.2025

import re

def check(s):
    pattern1 = r'.{5,}'
    pattern2 = r'\d'
    pattern3 = r'[А-ЯЁA-Z]'
    pattern4 = r'[^a-zA-Z0-9а-яА-ЯёЁ]'
    pattern6 = r'(january|february|march|april|may|june|july|august|september|october|november|december)'
    if not re.search(pattern1,s):
        print("Требование 1 не выполнено")
    if not re.search(pattern2,s):
        print("Требование 2 не выполнено")
    if not re.search(pattern3,s):
        print("Требование 3 не выполнено")
    if not re.search(pattern4,s):
        print("Требование 4 не выполнено")
    pattern5 = re.findall(pattern2,s)
    nums = sum(int(d) for d in pattern5)
    if nums != 25:
        print("Требование 5 не выполнено")
    if not re.search(pattern6,s,flags=re.IGNORECASE):
        print("Требование 6 не выполнено")

    if (nums == 25 and 
        re.search(pattern1, s) and
        re.search(pattern2, s) and
        re.search(pattern3, s) and
        re.search(pattern4, s) and
        re.search(pattern6, s, re.IGNORECASE)):
            print("Пароль подходит условиям")

check("Антон2008July77 100%")
check("Этот пароль не работает!february2")
check("нет")
check("Тут нет цифры! june55555")
check("Тут нет месяца!55555")


