# Author = Efimov Anton Dmitrievich
# Group = P3118
# Date = 06.11.2025

import re

def correct(s):
    pattern = r'\b\d+\b'
    def rep(match):
        x = int(match.group())
        return str(5*x**3 - 13)
    corr = re.sub(pattern, rep, s)
    print(corr)

correct("15 + 22 = 37")
correct("123.235+-")
correct("001*1")
correct("У меня будет 100% по 3 лабе")
correct("-28")
