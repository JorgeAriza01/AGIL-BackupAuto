@echo off

REM Lee configuración desde el archivo .ini
for /f "usebackq tokens=1,* delims==" %%A in ("%~dp0config.ini") do (
    if "%%A"=="ORIGEN" set "ORIGEN=%%B"
    if "%%A"=="RUTA_DBF" set "RUTA_DBF=%%B"
    if "%%A"=="RUTA_SQL" set "RUTA_SQL=%%B"
    if "%%A"=="RUTA_COMPRIMIDOS" set "RUTA_COMPRIMIDOS=%%B"
    if "%%A"=="LOG_FOLDER" set "LOG_FOLDER=%%B"
    if "%%A"=="MYSQL_HOST" set "MYSQL_HOST=%%B"
    if "%%A"=="MYSQL_USER" set "MYSQL_USER=%%B"
    if "%%A"=="MYSQL_PASSWORD" set "MYSQL_PASSWORD=%%B"
    if "%%A"=="MYSQL_DB" set "MYSQL_DB=%%B"
)

REM Obt fec y hora actual para crear nombres únicos de archivos
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
    set "DATE=%%c%%a%%b"
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set "TIME=%%a%%b"
)
set "TIMESTAMP=%DATE%_%TIME%"

REM Obt la fec y hora en un formato legible
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do (
    set "LOG_DATE=%%a %%b del mes %%c"
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set "LOG_TIME=%%a:%%b"
)
set "LOG_TIMESTAMP=%LOG_DATE%"

REM Crear carpetas de destino si no existen
if not exist "%RUTA_DBF%" mkdir "%RUTA_DBF%"
if not exist "%RUTA_SQL%" mkdir "%RUTA_SQL%"
if not exist "%RUTA_COMPRIMIDOS%" mkdir "%RUTA_COMPRIMIDOS%"
if not exist "%LOG_FOLDER%" mkdir "%LOG_FOLDER%"

REM Copiar la carpeta de origen a la carpeta de destino con la fecha y hora actual, excluyendo todas las instancias de FacturacionElectronica y archivos con extensión .bak y otros
robocopy "%ORIGEN%" "%RUTA_DBF%\Copia_%TIMESTAMP%" /E /XD "*FacturacionElectronica*" /XF "*.bak" "*.pdf" "*.png" "*.xml" "*.json" "*.log" "*.xls" "*.xlsx" "*.txt" /W:0 /R:0

REM Copia de seguridad de la base de datos MySQL
set "BACKUP_FILENAME=%MYSQL_DB%_%TIMESTAMP%.sql"
set "BACKUP_FILE=%RUTA_SQL%\%BACKUP_FILENAME%"
mysqldump -h%MYSQL_HOST% -u%MYSQL_USER% -p%MYSQL_PASSWORD% %MYSQL_DB% > "%BACKUP_FILE%"

REM Comprimir las carpetas generadas y el respaldo de SQL en un archivo ZIP
set "ZIP_FILENAME=Copia_%TIMESTAMP%.zip"
set "ZIP_FILE=%RUTA_COMPRIMIDOS%\%ZIP_FILENAME%"

REM Archivos para comprimir
set "FILES_TO_COMPRESS=%RUTA_DBF%\Copia_%TIMESTAMP%\*","%BACKUP_FILE%"

REM Compress-Archive
powershell Compress-Archive -Path %FILES_TO_COMPRESS% -DestinationPath "%ZIP_FILE%"

REM Sobrescribir el archivo de registro de la última copia de seguridad con la fecha y hora formateadas
echo Última copia de seguridad realizada el día %LOG_TIMESTAMP% > "%LOG_FOLDER%\last_backup_log.txt"

REM Agregar una entrada al archivo de registro de todas las copias de seguridad anteriores con la fecha y hora formateadas
echo Copia de seguridad realizada el %LOG_TIMESTAMP% >> "%LOG_FOLDER%\all_backups_log.txt"

echo Copia de seguridad completada:
echo Carpeta de destino para la copia de seguridad de MySQL: %RUTA_SQL%
echo Carpeta de destino para las carpetas generadas: %RUTA_DBF%\Copia_%TIMESTAMP%
echo Carpeta de destino para los archivos comprimidos: %RUTA_COMPRIMIDOS%
echo Anexado al Historial
powershell.exe -ExecutionPolicy Bypass -File "%~dp0HistorialTarea.ps1"
echo Proceso Completado
