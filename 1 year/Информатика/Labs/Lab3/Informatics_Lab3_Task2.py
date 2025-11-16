# Author = Efimov Anton Dmitrievich
# Group = P3118
# Date = 06.11.2025

import re

def correct(s):
    pattern = r'(\s)(-?\d+\b(?!\.\d))'
    def rep(match):
        space = match.group(1)
        x = int(match.group(2))
        return space + str(5*x**3 - 13)
    corr = re.sub(pattern, rep, s)
    print(corr)

correct("15 + 22 = 37")
correct("123.787+-")
correct("001*1")
correct("У меня будет 100% по 3 лабе")
correct("-28")
