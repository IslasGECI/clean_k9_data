import os
import typer


def extract_sheets(hoja: str = "Esfuerzo ", file: str = "tests/data/IG_ESFUERZO_28MAY2023.xls"):
    command = f"in2csv --blanks --sheet '{hoja}' {file} > aux.csv"
    os.system(command)


COMMAND_FOR_EXTRAS = {
    "Revision_Campo": "csvcut -c '1-11' aux.csv > camaras_extra_revision_campo.csv",
    "Revision_Memoria": "csvcut -c '1-2,5-9' -x aux.csv > camaras_extra_revision_memoria.csv",
}
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
    hoja: str = "Revision_Campo ", file: str = "tests/data/IG_CAMARA_TRAMPA_EXTRA_05NOV2023.xls"
):
    extract_sheets(hoja, file)
    command = COMMAND_FOR_EXTRAS[hoja]
    os.system(command)


@app.command()
def version():
    print("hola")
