@echo off
chcp 65001 >nul
echo ╔══════════════════════════════════════════════╗
echo ║  Instalador - ProyectoBase Android Menu     ║
echo ║  Por: Gabriel Gabrielli - UPATECO Salta     ║
echo ╚══════════════════════════════════════════════╝
echo.
echo Este script agrega la carpeta del proyecto al PATH del usuario
echo para que puedas ejecutar "proyect" desde cualquier terminal.
echo.
echo Carpeta a agregar: %~dp0
echo.
set /p confirmar="Deseas continuar? (S/N): "
if /i not "%confirmar%"=="S" (
    echo Cancelado.
    pause
    exit /b 0
)

REM Obtener el PATH actual del usuario
for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USER_PATH=%%b"

REM Verificar si ya esta en el PATH
echo %USER_PATH% | findstr /i /c:"%~dp0" >nul 2>&1
if %ERRORLEVEL%==0 (
    echo.
    echo [INFO] La carpeta ya esta en el PATH. No se necesita hacer nada.
    echo.
    pause
    exit /b 0
)

REM Agregar al PATH del usuario
if defined USER_PATH (
    setx PATH "%USER_PATH%;%~dp0"
) else (
    setx PATH "%~dp0"
)

echo.
if %ERRORLEVEL%==0 (
    echo [OK] Carpeta agregada al PATH correctamente.
    echo.
    echo IMPORTANTE: Cerra y volve a abrir la terminal para que tome efecto.
    echo Despues podes escribir "proyect" desde cualquier ubicacion.
) else (
    echo [ERROR] No se pudo modificar el PATH.
)
echo.
pause
exit /b 0
