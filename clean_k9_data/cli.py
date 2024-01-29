import os
import typer
from typing import Optional
from typing_extensions import Annotated


def extract_sheets(hoja: str = "Esfuerzo ", file: str = "tests/data/IG_ESFUERZO_28MAY2023.xls"):
    command = f"in2csv --blanks --sheet '{hoja}' {file} > aux.csv"
    os.system(command)


def csvcut_campo_command_string(output_path):
    return f"csvcut -c '1-13' aux.csv > {output_path}"


def csvcut_memoria_command_string(output_path):
    return f"csvcut -c '1-2,5-10' -x aux.csv > {output_path}"


app = typer.Typer(help="Tools to clean k9 data for the eradication Guadalupe Island project")


@app.command()
def esfuerzo(hoja: str = "Esfuerzo ", file: str = "tests/data/IG_ESFUERZO_28MAY2023.xls"):
    extract_sheets(hoja, file)
    command = "csvcut -c '1-9' -K 3 aux.csv > esfuerzo_k9.csv"
    os.system(command)


@app.command()
def marcaje(hoja: str = "Marcajes ", file: str = "tests/data/IG_ESFUERZO_28MAY2023.xls"):
    extract_sheets(hoja, file)
    command = "csvcut -c '1-10,12,13' -K 3 aux.csv > marcajes_k9.csv"
    os.system(command)


@app.command()
def extra(
    salida_campo: str = "",
    salida_memoria: str = "",
    file: Annotated[Optional[str], typer.Argument()] = None,
):
    extract_campo_sheet(salida_campo, file)
    extract_memoria_sheet(salida_memoria, file)


def extract_memoria_sheet(salida_memoria, file):
    hoja = "Revision_Memoria"
    extract_sheets(hoja, file)
    command = csvcut_memoria_command_string(salida_memoria)
    os.system(command)


def extract_campo_sheet(salida_campo, file):
    hoja = "Revision_Campo"
    extract_sheets(hoja, file)
    command = csvcut_campo_command_string(salida_campo)
    os.system(command)


@app.command()
def version():
    print("hola")
