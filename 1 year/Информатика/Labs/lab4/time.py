import time
from Informatics_Lab4_Task1 import deserealisation
from Informatics_Lab4_Task2 import serealisationJSON
from Informatics_Lab4_Task3 import bibl
from Informatics_Lab4_Task4 import serealisationXML

def serealisationJSON_noargs():
    serealisationJSON("Inflabs/lab4/schedule.json")
def serealisationXML_noargs():
    serealisationXML("Inflabs/lab4/schedule.xml")

def benchmark(script):
    start_time = time.time()
    for i in range(100):
        script()
    print("--- %s seconds ---" % (time.time() - start_time))


print('JSON')
benchmark(serealisationJSON_noargs)

print('BIBL')
benchmark(bibl)

print('XML')
benchmark(serealisationXML_noargs)
