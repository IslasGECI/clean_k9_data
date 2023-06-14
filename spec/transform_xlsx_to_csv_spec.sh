#shellcheck shell=sh
Describe 'Map of active and inactivated traps'
  cleanup() { make clean; }

  Describe 'recipe for phony transform_xlsx_to_csv'
    BeforeAll 'cleanup'
    AfterAll 'cleanup'
    It 'generates file'
      When run make transform_xlsx_to_csv
      The stdout should include 'python src/transform_xlsx_to_csv.py'
      The file /workdir/esfuerzo_k9.csv should be exist
    End
  End
End
