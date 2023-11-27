#shellcheck shell=sh
Describe 'Map of active and inactivated traps'
  cleanup() { make clean; }

  Describe 'recipe for phony transform_xlsx_to_csv'
    BeforeAll 'cleanup'
    AfterAll 'cleanup'
    It 'generates file'
      When run clean_k9_data esfuerzo
      The stderr should include 'packages/agate/utils.py:285: UnnamedColumnWarning: Column 1'
      The file /workdir/esfuerzo_k9.csv should be exist
    End
    It 'With explicit file name'
      When run clean_k9_data esfuerzo --file=tests/data/IG_ESFUERZO_K9_03JUL2022.xlsx --hoja="Esfuerzo"
      The stderr should include 'packages/agate/utils.py:285: UnnamedColumnWarning: Column 1'
      The file /workdir/esfuerzo_k9.csv should be exist
    End
    It 'With explicit file name: check hash'
      When call md5sum /workdir/esfuerzo_k9.csv 
      The stdout should not include '3ee5f608acb5af6cd'
    End
    It 'The sheet Marcajes'
      When run clean_k9_data marcaje --hoja="Marcajes "
      The stderr should include 'packages/agate/utils.py:285: UnnamedColumnWarning: Column 1'
      The file /workdir/marcajes_k9.csv should be exist
    End
    It 'Marcajes: check columns'
      When call head /workdir/marcajes_k9.csv -n 1 
      The stdout should include 'Fecha,Manejador,Nombre_k9,ID-punto,Coordenada_Este,Coordenada_Norte,Altitud,Zona,Tipo_de_rastro,Clave muestra,Sitio_o_lugar,Observaciones'
    End
  End
  Describe 'Tranform xls to csv: camera traps'
    BeforeAll 'cleanup'
 #   AfterAll 'cleanup'
    It 'With explicit file name'
      When run clean_k9_data extra \
        tests/data/IG_CAMARA_TRAMPA_EXTRA_05NOV2023.xls \
        --salida-campo=/workdir/camaras_extra_revision_campo_for_tests.csv \
        --salida-memoria=/workdir/camaras_extra_revision_memoria.csv
      The file /workdir/camaras_extra_revision_campo_for_tests.csv should be exist
    End
    It 'With explicit file name: check hash'
      When call wc --lines /workdir/camaras_extra_revision_campo_for_tests.csv 
      The stdout should include '161'
    End
    It 'Check columns: Extra revision campo'
      When call head /workdir/camaras_extra_revision_campo_for_tests.csv -n 1 
      The stdout should include 'ID_camara,Zona,Coordenada_Este,Coordenada_Norte,Fecha_revision,Responsable,Revision,Estado_camara,Estado_memoria,Porcentaje_bateria,Observaciones'
    End
    It 'With explicit file name: revision memoria'
      When run clean_k9_data extra \
        tests/data/IG_CAMARA_TRAMPA_EXTRA_19NOV2023.xlsx \
        --salida-campo=/workdir/camaras_extra_revision_campo.csv \
        --salida-memoria=/workdir/camaras_extra_revision_memoria.csv
      The stderr should include 'UnnamedColumnWarning'
      The file /workdir/camaras_extra_revision_memoria.csv should be exist
    End
    It 'Remove empty rows'
      When call wc --lines /workdir/camaras_extra_revision_memoria.csv 
      The stdout should include '172'
    End
    It 'Include NA'
      When run cat /workdir/camaras_extra_revision_memoria.csv
      The stdout should include 'NA'
    End
    It 'Check columns: Extra revision memoria'
      When call head /workdir/camaras_extra_revision_memoria.csv -n 1 
      The stdout should include 'ID camara,RESPONSABLE,Fotos capturadas,Fecha foto captura,Hora captura,Cantidad individuos capturados,Observaciones'
    End
  End
End
