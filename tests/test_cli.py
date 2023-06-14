from clean_k9_data import transform_xlsx_2_csv

import os


def tests_transform_xlsx_2_csv():
    output_path = "esfuerzos_k9.csv"
    if os.path.exists(output_path):
        os.remove(output_path)
    transform_xlsx_2_csv()
    assert os.path.exists(output_path)
