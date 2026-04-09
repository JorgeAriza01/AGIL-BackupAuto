# AGIL-BackupAuto
Copia de Seguridad Automatica Administrada en el Programador de Tareas de Windows para AGIL Software y Otros


BackupAuto es un script que permite realizar una copia de seguridad de una carpeta en especifico con exclusión de archivos, y adicionalmente realiza una copia de seguridad de la base de datos de MySQL, está pensado para realizar copias de seguridad en AGIL Software y sistemas similares que usen una BD hibrida con SQL. 

El objetivo de este script era generar un sistema de copias con el mínimo de requerimientos.

Crea una copia de la carpeta del sistema en la carpeta BackupDBF excluyendo archivos: "*.bak" "*.pdf" "*.png" "*.xml" "*.json" "*.log" "*.xls" "*.xlsx" "*.txt"
Crea una copia de seguridad de la base de datos de MySQL en BackupSQL
Finalmente almacena ambas copias en un archivo comprimido en BackupZip

No cuenta con eliminación automática de las copias generadas almacenadas en BackupDBF y BackupSQL. 

La razón por la cual hace una copia y luego genera compresión es por que la compresión directa de archivos no se ejecuta cuando hay archivos en funcionamiento. 

BackupAuto ha demostrado hasta 3 mayor veces velocidad de ejecución en copias de seguridad y optimización del almacenamiento de copias 10 veces a la regular principalmente por que la copia excluye archivos no necesarios para el funcionamiento normal del sistema. 

Ejemplo:

Archivos de 8 GB se han covertido en 300 MB mediante compresión. 

El archivo de BackupAuto se debe configurar en el programador de tareas de windows.
