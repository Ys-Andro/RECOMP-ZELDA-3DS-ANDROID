#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REPO_ROOT="$(cd "$ROOT/../.." && pwd)"
STAGE_DIR="${TRIAEVUM_ANDROID_STAGE_DIR:-$ROOT/staged_native_libs}"
TITLE_DEST="${TRIAEVUM_TITLE_SOURCE_DEST:-$ROOT/title_sources}"
GRADLE_TASK="${TRIAEVUM_ANDROID_GRADLE_TASK:-assembleRelease}"

: "${ANDROID_NDK_HOME:?Define ANDROID_NDK_HOME to Android NDK r29+}"
: "${TRIAEVUM_TITLE_SOURCE_ARCHIVE:=${TRIAEVUM_TITLE_SOURCE_ARCHIVE:-}}"

if [[ -n "${TRIAEVUM_TITLE_SOURCE_ARCHIVE:-}" || -n "${TRIAEVUM_TITLE_SOURCE_DIR:-}" ]]; then
  TRIAEVUM_TITLE_SOURCE_DEST="$TITLE_DEST" \
    "$ROOT/tools/stage_translated_title_sources.sh"
fi

if [[ ! -f "$TITLE_DEST/TITLE_SOURCE_MANIFEST.json" ]]; then
  echo "Falta el inventario de fuentes AOT en $TITLE_DEST." >&2
  echo "Usa TRIAEVUM_TITLE_SOURCE_ARCHIVE=<archive> o TRIAEVUM_TITLE_SOURCE_DIR=<dir>." >&2
  exit 1
fi

export TRIAEVUM_TRANSLATED_TITLE_DIR="$TITLE_DEST"
export TRIAEVUM_ANDROID_STAGE_DIR="$STAGE_DIR/arm64-v8a"
"$ROOT/tools/build_android_native.sh"

# build_android_native.sh creates the exact ARM64 native stage consumed by Gradle.
# The Android module then packages the native runtime and translated title AOT.
cd "$ROOT"
./gradlew --no-daemon "$GRADLE_TASK" -PtriaevumNativeStage="$STAGE_DIR"

APK="$(find "$ROOT/app/build/outputs/apk/release" -maxdepth 1 -type f -name '*.apk' -print -quit)"
test -n "$APK" || { echo "Gradle terminó sin producir una APK release." >&2; exit 1; }
printf 'APK generada: %s\n' "$APK"
