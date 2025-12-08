from Informatics_Lab4_Task1 import deserealisation

def serealisationJSON(file):
    schedule = deserealisation("Inflabs/lab4/schedule.ini")
    scheduleJson = open(file, "w", encoding="utf-8")
    def json(obj, i=0):
        space = " " * i
        if type(obj) == dict:
            res = []
            for k, v in obj.items():
                res.append(f'{space}  "{k}": {json(v, i + 2)}')
            return "{\n" + ",\n".join(res) + "\n" + space + "}"
        elif type(obj) == list:
            res = [json(v, i+2) for v in obj]
            return "[\n" + ",\n".join(res) + "\n" + space + "]"
        else:
            return f'"{obj}"'
    
    scheduleJson.write(json(schedule))
    scheduleJson.close()
serealisationJSON("Inflabs/lab4/schedule.json")