# Author = Efimov Anton Dmitrievich
# Group = P3118
# Date = 06.11.2025

import re

def correct(s):
    pattern = r'\b([01]\d|2[0-3]):[0-5]\d(:[0-5]\d)?\b'
    corr = re.sub(pattern,'(TBD)', s)
    print(corr)

correct("Уважаемые студенты! В эту субботу в 15:00 планируется доп. занятие на 2 часа. То есть в 17:00:01 оно уже точно кончится")
correct("156:124:1 100%")
correct("15-12:10 100%")
correct("20:60:00 100%")
correct("23:23:100 100%")
