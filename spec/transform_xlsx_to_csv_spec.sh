#shellcheck shell=sh
Describe 'Map of active and inactivated traps'
  cleanup() { make clean; }

  Describe 'recipe for phony transform_xlsx_to_csv'
    BeforeAll 'cleanup'
    AfterAll 'cleanup'
    It 'generates file'
      When run python src/transform_xlsx_to_csv.py esfuerzo
      The stderr should include 'packages/agate/utils.py:285: UnnamedColumnWarning: Column 1'
      The file /workdir/esfuerzo_k9.csv should be exist
    End
    It 'With explicit file name'
      When run python src/transform_xlsx_to_csv.py esfuerzo --file=tests/data/IG_ESFUERZO_K9_03JUL2022.xlsx --hoja="Esfuerzo"
      The stderr should include 'packages/agate/utils.py:285: UnnamedColumnWarning: Column 1'
      The file /workdir/esfuerzo_k9.csv should be exist
    End
    It 'With explicit file name: check hash'
      When call md5sum /workdir/esfuerzo_k9.csv 
      The stdout should not include '3ee5f608acb5af6cd'
    End
    It 'The sheet Marcajes'
      When run python src/transform_xlsx_to_csv.py marcaje --hoja="Marcajes "
      The stderr should include 'packages/agate/utils.py:285: UnnamedColumnWarning: Column 1'
      The file /workdir/marcajes_k9.csv should be exist
    End
    It 'Marcajes: check columns'
      When call head /workdir/marcajes_k9.csv -n 1 
      The stdout should include 'Fecha,Manejador,Nombre_k9,ID-punto,Coordenada_Este,Coordenada_Norte,Altitud,Zona,Tipo_de_rastro,Clave muestra,Sitio_o_lugar,Observaciones'
    End
  End
End
