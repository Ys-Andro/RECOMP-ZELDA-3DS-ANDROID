#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0

require_file() {
  if [[ ! -f "$ROOT/$1" ]]; then
    echo "[FAIL] Falta: $1"
    FAIL=1
  else
    echo "[OK] $1"
  fi
}

require_file "settings.gradle.kts"
require_file "build.gradle.kts"
require_file "app/build.gradle.kts"
require_file "app/src/main/AndroidManifest.xml"
require_file "native/CMakeLists.txt"
require_file "app/src/main/java/org/triaevum/android/TriAevumActivity.java"
require_file "app/src/main/java/org/triaevum/android/TriAevumDownloadActivity.java"
require_file "app/src/main/java/org/triaevum/android/SpanishUi.java"

ABI_LINE=$(grep -F 'abiFilters += "arm64-v8a"' "$ROOT/app/build.gradle.kts" || true)
if [[ -z "$ABI_LINE" ]]; then
  echo "[FAIL] La APK no está limitada a arm64-v8a."
  FAIL=1
else
  echo "[OK] ABI arm64-v8a"
fi

if grep -q 'targetSdk = 35' "$ROOT/app/build.gradle.kts"; then
  echo "[OK] targetSdk 35"
else
  echo "[FAIL] targetSdk distinto de 35"
  FAIL=1
fi

if grep -q -- '-Wl,-z,max-page-size=16384' "$ROOT/native/CMakeLists.txt"; then
  echo "[OK] Enlace ELF compatible con páginas de 16 KiB"
else
  echo "[FAIL] Falta alineación ELF de 16 KiB"
  FAIL=1
fi

if grep -q 'nativeSurfaceDestroyed' "$ROOT/app/src/main/java/org/triaevum/android/TriAevumActivity.java" && \
   grep -q 'nativeOnPause' "$ROOT/app/src/main/java/org/triaevum/android/TriAevumActivity.java"; then
  echo "[OK] API de lifecycle nativo declarada"
else
  echo "[FAIL] Falta API de lifecycle nativo"
  FAIL=1
fi

# Detectar accidentalmente texto portugués de interfaz en fuentes Android.
if grep -RInE 'Configurações|Selecionar|Diretório|Desligado|Carregar|Salvar|Não foi|Falha ao|Jogo pronto|Pré-carregando' \
    "$ROOT/app/src/main" --include='*.java' --include='*.kt' >/tmp/triaevum_pt.txt 2>/dev/null; then
  echo "[WARN] Se detectó texto portugués en la interfaz Android:"
  cat /tmp/triaevum_pt.txt
  FAIL=1
else
  echo "[OK] No se detectaron cadenas portuguesas conocidas"
fi

if [[ "$FAIL" -ne 0 ]]; then
  echo "Validación Android: FALLÓ"
  exit 1
fi

echo "Validación Android: OK"
