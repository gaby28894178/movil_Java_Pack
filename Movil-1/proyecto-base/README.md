# Proyecto Base - Hola Mundo Android

Proyecto Android base con un "Hola Mundo" listo para correr en el emulador.

> **Proyecto con fines educativos** para los compañeros de **UPATECO** (Universidad Provincial de Administración, Tecnología y Comercio) — Salta, Argentina.
>
> Realizado por el alumno **Gabriel Gabrielli**.

## Requisitos

- Android Studio o editor con soporte Android (VS Code + extensiones)
- Java JDK 17+
- Android SDK (API 34)
- Emulador Android configurado (AVD)

## Estructura del proyecto

```
proyecto-base/
├── app/
│   ├── build.gradle                    # Configuración del módulo app
│   ├── proguard-rules.pro
│   └── src/main/
│       ├── AndroidManifest.xml         # Manifest de la app
│       ├── java/com/ejemplo/proyectobase/
│       │   └── MainActivity.java       # Activity principal
│       └── res/
│           ├── layout/
│           │   └── activity_main.xml   # Layout con el Hola Mundo
│           └── values/
│               ├── strings.xml         # Textos
│               └── themes.xml          # Tema de la app
├── gradle/wrapper/
│   ├── gradle-wrapper.jar
│   └── gradle-wrapper.properties       # Versión de Gradle: 8.6
├── build.gradle                        # Build raíz (AGP 8.4.0)
├── settings.gradle                     # Configuración del proyecto
├── gradle.properties                   # Propiedades de Gradle
├── gradlew                             # Wrapper Linux/Mac
├── gradlew.bat                         # Wrapper Windows
└── README.md
```

## Versiones utilizadas

| Componente | Versión |
|---|---|
| Gradle | 8.6 |
| Android Gradle Plugin (AGP) | 8.4.0 |
| compileSdk | 34 |
| minSdk | 24 |
| targetSdk | 34 |
| Java | 17 |

## Cómo correr en el emulador

### 1. Abrir un emulador

Listar emuladores disponibles:
```bash
emulator -list-avds
```

Iniciar un emulador (reemplazar NOMBRE_AVD por el nombre de tu emulador):
```bash
emulator -avd NOMBRE_AVD
```

### 2. Compilar el proyecto

```bash
.\gradlew.bat assembleDebug
```

### 3. Instalar en el emulador

```bash
.\gradlew.bat installDebug
```

### 4. Abrir la app

```bash
adb shell am start -n com.ejemplo.proyectobase/.MainActivity
```

O simplemente buscá "Proyecto Base" en el launcher del emulador.

## Solución de problemas

### Error "Minimum supported Gradle version is X.X"

El archivo `gradle/wrapper/gradle-wrapper.properties` ya tiene configurada la versión correcta (8.6). Si el error persiste en el editor:

1. Ejecutá `.\gradlew.bat --version` para verificar que usa Gradle 8.6
2. En VS Code: Ctrl+Shift+P → "Java: Clean Java Language Server Workspace" → Restart

### Error de compilación

Verificá que tenés Java 17:
```bash
java -version
```

Limpiá y recompilá:
```bash
.\gradlew.bat clean assembleDebug
```

## Menú interactivo (menu.bat / proyect.bat)

El proyecto incluye un menú interactivo por terminal que simplifica las tareas de compilación, emulación e instalación.

### Archivos

| Archivo | Descripción |
|---------|-------------|
| `proyect.bat` | Lanzador del menú. Ejecutar desde la terminal de VS Code. |
| `menu.bat` | Menú principal con todas las opciones. |

### Cómo usar

Desde la terminal de VS Code (en la carpeta del proyecto):

```bash
proyect
```

Esto abre el menú interactivo directamente en la terminal.

### Opciones del menú

| # | Opción | Qué hace |
|---|--------|----------|
| 1 | Compilar proyecto | Ejecuta `gradlew assembleDebug` y genera el APK en `app/build/outputs/apk/debug/` |
| 2 | Listar emuladores disponibles | Muestra los AVD (Android Virtual Device) creados en tu sistema |
| 3 | Crear emulador (AVD) | Descarga la imagen de sistema API 34 y crea un nuevo emulador con el nombre que elijas |
| 4 | Iniciar emulador | Muestra un submenú numerado con los emuladores disponibles, elegís uno y se lanza en una ventana separada. Verifica que ADB esté activo antes de iniciar. |
| 5 | Instalar APK | Instala el APK compilado en el dispositivo/emulador conectado. Si no existe el APK, compila primero. Verifica ADB automáticamente. |
| 6 | Correr app | Hace todo junto: compila → instala → abre la app en el dispositivo/emulador. Verifica ADB automáticamente. |
| 7 | Limpiar proyecto | Ejecuta `gradlew clean` para borrar archivos de compilación |
| 8 | Borrar APK generado | Elimina el archivo APK de `app/build/outputs/apk/debug/` |
| 9 | Limpiar cache de la app | Borra cache y datos de la app en el dispositivo/emulador conectado (`pm clear`) |
| 10 | Listar dispositivos conectados | Muestra los dispositivos/emuladores que detecta `adb devices` |
| 0 | Salir | Cierra el menú |

### Notas

- El menú verifica automáticamente que el servidor ADB esté corriendo antes de las operaciones que lo necesitan (opciones 4, 5, 6).
- El emulador se lanza en una ventana CMD separada para no bloquear la terminal principal.
- Necesitás tener en el PATH: `emulator`, `sdkmanager`, `avdmanager`, `adb` (vienen con el Android SDK).

## Cómo modificar

- **Cambiar el texto**: Editá `app/src/main/res/layout/activity_main.xml`
- **Agregar lógica**: Editá `app/src/main/java/com/ejemplo/proyectobase/MainActivity.java`
- **Cambiar nombre de la app**: Editá `app/src/main/res/values/strings.xml`
- **Cambiar colores/tema**: Editá `app/src/main/res/values/themes.xml`

## Instalación global (variable de entorno PATH)

Para poder ejecutar `proyect` desde cualquier terminal sin estar en la carpeta del proyecto:

### Instalar

Ejecutá `instalar.bat` (doble clic o desde terminal):

```bash
instalar.bat
```

Esto agrega la carpeta del proyecto al PATH de tu usuario. Después de cerrar y volver a abrir la terminal, podés escribir `proyect` desde cualquier ubicación.

### Desinstalar

Si querés remover el comando del PATH:

```bash
desinstalar.bat
```

### Archivos

| Archivo | Descripción |
|---------|-------------|
| `instalar.bat` | Agrega la carpeta del proyecto al PATH del usuario |
| `desinstalar.bat` | Remueve la carpeta del proyecto del PATH |

### Nota

- Solo necesitás ejecutar `instalar.bat` una vez.
- Después de instalar, cerrá y abrí la terminal para que tome efecto.
- No requiere permisos de administrador (modifica solo el PATH del usuario actual).
