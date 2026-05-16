@echo off
chcp 65001 >nul
title Menu - ProyectoBase Android
setlocal enabledelayedexpansion

:MENU
cls
echo ╔══════════════════════════════════════════════╗
echo ║       MENU - ProyectoBase Android           ║
echo ╠══════════════════════════════════════════════╣
echo ║  1. Compilar proyecto (assembleDebug)       ║
echo ║  2. Listar emuladores disponibles           ║
echo ║  3. Crear emulador (AVD)                    ║
echo ║  4. Iniciar emulador                        ║
echo ║  5. Instalar APK en dispositivo/emulador    ║
echo ║  6. Correr app (compilar + instalar + abrir)║
echo ║  7. Limpiar proyecto (clean)                ║
echo ║  8. Borrar APK generado                     ║
echo ║  9. Limpiar cache de la app (dispositivo)   ║
echo ║ 10. Listar dispositivos conectados (adb)    ║
echo ║  0. Salir                                   ║
echo ╚══════════════════════════════════════════════╝
echo.
set /p opcion="Selecciona una opcion: "

if "%opcion%"=="1" goto COMPILAR
if "%opcion%"=="2" goto LISTAR_AVD
if "%opcion%"=="3" goto CREAR_AVD
if "%opcion%"=="4" goto INICIAR_AVD
if "%opcion%"=="5" goto INSTALAR
if "%opcion%"=="6" goto CORRER
if "%opcion%"=="7" goto LIMPIAR
if "%opcion%"=="8" goto BORRAR_APK
if "%opcion%"=="9" goto LIMPIAR_CACHE
if "%opcion%"=="10" goto DISPOSITIVOS
if "%opcion%"=="0" goto SALIR

echo Opcion no valida.
pause
goto MENU

:COMPILAR
cls
echo === Compilando proyecto (assembleDebug) ===
call gradlew.bat assembleDebug
echo.
if %ERRORLEVEL%==0 (
    echo [OK] Compilacion exitosa.
    echo APK generado en: app\build\outputs\apk\debug\app-debug.apk
) else (
    echo [ERROR] La compilacion fallo.
)
echo.
pause
goto MENU

:LISTAR_AVD
cls
echo === Emuladores disponibles ===
call emulator -list-avds
echo.
pause
goto MENU

:CREAR_AVD
cls
echo === Crear nuevo emulador (AVD) ===
echo.
echo Paquetes de sistema disponibles (API 34):
call sdkmanager --list 2>nul | findstr "system-images;android-34"
echo.
echo Descargando imagen del sistema (si no existe)...
call sdkmanager "system-images;android-34;google_apis;x86_64"
echo.
set /p avd_nombre="Nombre para el emulador (ej: Pixel_API34): "
echo Creando AVD: %avd_nombre%
call avdmanager create avd -n %avd_nombre% -k "system-images;android-34;google_apis;x86_64" -d "pixel"
echo.
if %ERRORLEVEL%==0 (
    echo [OK] Emulador "%avd_nombre%" creado correctamente.
) else (
    echo [ERROR] No se pudo crear el emulador.
)
echo.
pause
goto MENU

:INICIAR_AVD
cls
echo === Iniciar emulador ===
echo.
REM Verificar si adb esta corriendo, si no, iniciarlo
echo Verificando servidor ADB...
adb devices >nul 2>&1
if not %ERRORLEVEL%==0 (
    echo [INFO] Iniciando servidor ADB...
    adb start-server
)
echo [OK] Servidor ADB activo.
echo.
echo Emuladores disponibles:
echo.
set avd_count=0
for /f "delims=" %%a in ('emulator -list-avds 2^>nul') do (
    set /a avd_count+=1
    set "avd_!avd_count!=%%a"
    echo   !avd_count!. %%a
)
echo.
if !avd_count!==0 (
    echo [ERROR] No hay emuladores creados. Usa la opcion 3 para crear uno.
    echo.
    pause
    goto MENU
)
set /p avd_opcion="Selecciona el numero del emulador: "
if !avd_opcion! LSS 1 (
    echo Opcion no valida.
    pause
    goto MENU
)
if !avd_opcion! GTR !avd_count! (
    echo Opcion no valida.
    pause
    goto MENU
)
set "avd_nombre=!avd_%avd_opcion%!"
echo.
echo Iniciando !avd_nombre! en una nueva ventana...
start "Emulador Android - !avd_nombre!" cmd /c "emulator -avd !avd_nombre!"
echo.
echo [OK] Emulador lanzado en una ventana separada.
echo Espera a que termine de arrancar antes de instalar la app.
echo.
pause
goto MENU

:INSTALAR
cls
echo === Instalar APK en dispositivo/emulador ===
REM Verificar ADB
echo Verificando servidor ADB...
adb devices >nul 2>&1
if not %ERRORLEVEL%==0 (
    echo [INFO] Iniciando servidor ADB...
    adb start-server
)
echo [OK] Servidor ADB activo.
echo.
if not exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo [AVISO] No se encontro el APK. Compilando primero...
    call gradlew.bat assembleDebug
    echo.
)
echo Instalando APK...
call adb install -r app\build\outputs\apk\debug\app-debug.apk
echo.
if %ERRORLEVEL%==0 (
    echo [OK] APK instalado correctamente.
) else (
    echo [ERROR] No se pudo instalar el APK. Verifica que haya un dispositivo conectado.
)
echo.
pause
goto MENU

:CORRER
cls
echo === Compilar + Instalar + Abrir App ===
echo.
REM Verificar ADB
echo Verificando servidor ADB...
adb devices >nul 2>&1
if not %ERRORLEVEL%==0 (
    echo [INFO] Iniciando servidor ADB...
    adb start-server
)
echo [OK] Servidor ADB activo.
echo.
echo [1/3] Compilando...
call gradlew.bat assembleDebug
if not %ERRORLEVEL%==0 (
    echo [ERROR] La compilacion fallo. Abortando.
    pause
    goto MENU
)
echo.
echo [2/3] Instalando APK...
call adb install -r app\build\outputs\apk\debug\app-debug.apk
if not %ERRORLEVEL%==0 (
    echo [ERROR] No se pudo instalar. Verifica dispositivo/emulador.
    pause
    goto MENU
)
echo.
echo [3/3] Abriendo app...
call adb shell am start -n com.ejemplo.proyectobase/.MainActivity
echo.
if %ERRORLEVEL%==0 (
    echo [OK] App ejecutandose en el dispositivo.
) else (
    echo [ERROR] No se pudo abrir la app.
)
echo.
pause
goto MENU

:LIMPIAR
cls
echo === Limpiando proyecto ===
call gradlew.bat clean
echo.
if %ERRORLEVEL%==0 (
    echo [OK] Proyecto limpiado.
) else (
    echo [ERROR] Fallo al limpiar.
)
echo.
pause
goto MENU

:BORRAR_APK
cls
echo === Borrar APK generado ===
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    del /f "app\build\outputs\apk\debug\app-debug.apk"
    echo [OK] APK eliminado: app\build\outputs\apk\debug\app-debug.apk
) else (
    echo [INFO] No hay APK generado para borrar.
)
echo.
pause
goto MENU

:LIMPIAR_CACHE
cls
echo === Limpiar cache de la app en dispositivo/emulador ===
echo.
echo Verificando servidor ADB...
adb devices >nul 2>&1
if not %ERRORLEVEL%==0 (
    echo [INFO] Iniciando servidor ADB...
    adb start-server
)
echo [OK] Servidor ADB activo.
echo.
echo Limpiando cache de com.ejemplo.proyectobase...
call adb shell pm clear com.ejemplo.proyectobase
echo.
if %ERRORLEVEL%==0 (
    echo [OK] Cache y datos de la app eliminados del dispositivo.
) else (
    echo [ERROR] No se pudo limpiar. Verifica que la app este instalada y haya un dispositivo conectado.
)
echo.
pause
goto MENU

:DISPOSITIVOS
cls
echo === Dispositivos conectados ===
call adb devices
echo.
pause
goto MENU

:SALIR
echo Hasta luego!
exit /b 0
