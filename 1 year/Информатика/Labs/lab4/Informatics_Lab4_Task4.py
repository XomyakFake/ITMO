from Informatics_Lab4_Task1 import deserealisation

def serealisationXML(file):
    schedule = deserealisation("Inflabs/lab4/schedule.ini")
    days ={}
    for a,b in schedule.items():
        dayn = a.split("_")[0]
        if dayn not in days:
            days[dayn] = []
        days[dayn].append(b)

    def xml(obj):
        text = '<?xml version="1.0" encoding="UTF-8" ?>\n'
        text += "<schedule>\n"
        for day,classes in obj.items():
            text += f'  <day name="{day}">\n'
            text += f'    <classes>\n'
            for neterm in classes:
                text += f'      <class>\n'
                for k,v in neterm.items():
                    text += f'        <{k}>{v}</{k}>\n'
                text += f'      </class>\n\n'
            text += f"    </classes>\n"
            text += f"  </{day}>\n"
        text += "</schedule>\n"
        return text
    
    out = xml(days)
    with open(file, "w", encoding="utf-8") as f:
        f.write(out)

serealisationXML("Inflabs/lab4/schedule.xml")

