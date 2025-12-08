"""
Вариант 128
INI ---> JSON
день недели: Понедельник, Суббота
"""

def deserealisation(file):
    scheduleIni = open(file, "r", encoding="utf-8")
    lines = [line.rstrip() for line in scheduleIni]

    schedule = {}
    currsection = None
    currclass = {}

    for line in lines:
        line = line.strip()
        if not line:
            continue  

        if line[0] == "[" and line[-1] == "]":
            if currsection and currclass:
                schedule[currsection] = currclass
                currclass = {}
            currsection = line[1:-1]
            continue

        if "=" in line:
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip()
            currclass[key] = value

    if currsection and currclass:
        schedule[currsection] = currclass

    scheduleIni.close()
    return schedule

deserealisation("Inflabs/lab4/schedule.ini")
