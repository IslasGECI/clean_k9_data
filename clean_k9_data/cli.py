import os
import typer


app = typer.Typer(help="Tools to clean k9 data for the eradication Guadalupe Island project")


@app.command()
def transform_xlsx():
    """
    Transform data `IG_ESFUERZO_K9_{date}.xls[x]` \n
    """
    command = "docker run -v $PWD:/workdir islasgeci/clean_k9 make transform_xlsx_2_csv"
    os.system(command)
