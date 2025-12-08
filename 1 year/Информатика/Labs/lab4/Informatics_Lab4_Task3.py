import configparser
import json

def bibl():
    config = configparser.ConfigParser() 
    config.read("Inflabs/lab4/schedule.ini", encoding="utf-8")
    schedule = {section: dict(config[section]) for section in config.sections()} 

    with open("Inflabs/lab4/schedule.json", "w", encoding="utf-8") as f:
        json.dump(schedule,f,ensure_ascii=False, indent = 2)

bibl()