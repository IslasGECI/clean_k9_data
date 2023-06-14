import os

command = "in2csv --sheet 'Esfuerzo ' $(ls IG_ESFUERZO*) > aux.csv"
os.system(command)
command = "csvcut -c '1-9' -K 3 aux.csv > esfuezo_k9.csv"
os.system(command)
