#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
: "${ANDROID_NDK_HOME:?Define ANDROID_NDK_HOME to an Android NDK r29+ installation}"
: "${TRIAEVUM_TRANSLATED_TITLE_DIR:?Define TRIAEVUM_TRANSLATED_TITLE_DIR with the verified translated OoT3D AOT sources}"

BUILD_DIR="${TRIAEVUM_ANDROID_BUILD_DIR:-$ROOT/.native-build-arm64}"
STAGE_DIR="${TRIAEVUM_ANDROID_STAGE_DIR:-$ROOT/staged_native_libs/arm64-v8a}"

cmake -S "$ROOT/native" -B "$BUILD_DIR" \
  -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-29 \
  -DANDROID_NDK="$ANDROID_NDK_HOME" \
  -DTRIAEVUM_TRANSLATED_TITLE_DIR="$TRIAEVUM_TRANSLATED_TITLE_DIR" \
  -DTRIAEVUM_ANDROID_BUILD_NRI=ON \
  -DTRIAEVUM_ANDROID_TITLE_OPTIMIZATION=2

cmake --build "$BUILD_DIR" --target triaevum_android_title -j "${CMAKE_BUILD_PARALLEL_LEVEL:-$(nproc)}"

mkdir -p "$STAGE_DIR"

copy_required() {
  local src="$1" dst="$2"
  test -f "$src" || { echo "Falta biblioteca nativa: $src" >&2; exit 1; }
  cp -f "$src" "$STAGE_DIR/$dst"
}

copy_required "$BUILD_DIR/libtriaevum_title_aot.so" "libtriaevum_title_aot.so"

# The remaining runtime libraries are produced by the repository's publisher/runtime build.
# Never fabricate placeholders: the Android Gradle build intentionally rejects incomplete stages.
for lib in libTriAevum.so libtriaevum_title_bootstrap.so libc++_shared.so; do
  if [[ ! -f "$STAGE_DIR/$lib" ]]; then
    echo "Falta $lib en $STAGE_DIR. Compílalo con el runtime Android/publisher build antes de assembleRelease." >&2
    exit 1
  fi
done

printf 'Native ARM64 stage listo: %s\n' "$STAGE_DIR"
