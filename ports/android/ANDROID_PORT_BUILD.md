# TriAevum Android: compilación del port ARM64

Esta carpeta produce el host Android del port nativo de Ocarina of Time 3D. No es un emulador: el ejecutable del título se integra como una biblioteca AOT ARM64 y el runtime Android proporciona superficie Vulkan, lifecycle, entrada, almacenamiento y controles táctiles.

## Requisitos

- Android SDK API 35.
- Android NDK r29 o posterior.
- CMake 3.30 o posterior.
- JDK 17.
- ABI `arm64-v8a`.
- Fuentes AOT traducidas y verificadas del título proporcionadas por el publicador.

El proyecto exige API 29 como mínimo. El binario nativo debe compilarse con alineación ELF de 16 KiB. Android 15 admite dispositivos con páginas de 16 KiB y las aplicaciones con código NDK deben reconstruir sus bibliotecas nativas para soportarlos.

## Flujo

1. Generar u obtener las fuentes AOT ARM64 verificadas del título.
2. Configurar `ports/android/native` con el NDK de Android.
3. Definir `TRIAEVUM_TRANSLATED_TITLE_DIR` apuntando exclusivamente a esas fuentes.
4. Compilar `triaevum_android_title`.
5. Colocar las bibliotecas resultantes en `ports/android/staged_native_libs/arm64-v8a/` con estos nombres:

- `libTriAevum.so`
- `libtriaevum_title_bootstrap.so`
- `libtriaevum_title_aot.so`
- `libc++_shared.so`

6. Ejecutar `./gradlew assembleRelease` dentro de `ports/android`.
7. Instalar la APK ARM64 en un dispositivo Vulkan.

## Validación

Antes del build:

```bash
cd ports/android
bash tools/validate_android_port_v2.sh
```

La validación comprueba ARM64, API objetivo, lifecycle nativo, configuración Vulkan/Android y alineación ELF de 16 KiB.

El APK final debe comprobarse también con `llvm-readelf -lW` para confirmar que todos los segmentos `LOAD` de las bibliotecas nativas están alineados a 16384 bytes.

## Android / Vulkan

El host usa una superficie Android nativa y mantiene el renderer Vulkan existente. No debe reemplazarse el backend Vulkan por OpenGL ES como parte del port Android.

La destrucción de la ventana debe detener y sincronizar el hilo de juego antes de liberar la superficie. No se debe usar `Process.killProcess()` como mecanismo normal de cierre o rotación.

## Idioma

La interfaz Android aplica `SpanishUi` desde `TriAevumApplication`. Las cadenas heredadas en inglés o portugués se normalizan a español en la capa host sin modificar la superficie gráfica nativa del juego.

## Contenido del juego

El repositorio no debe contener una ROM, `code.bin`, `romfs.bin`, fuentes propietarias ni una biblioteca AOT obtenida de una copia no autorizada. El propietario/publicador proporciona las fuentes AOT verificadas durante la compilación.
