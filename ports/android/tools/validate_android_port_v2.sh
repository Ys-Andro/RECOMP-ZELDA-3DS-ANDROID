#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAIL=0
req(){ test -f "$ROOT/$1" && echo "[OK] $1" || { echo "[FAIL] $1"; FAIL=1; }; }
for f in settings.gradle.kts build.gradle.kts app/build.gradle.kts app/src/main/AndroidManifest.xml native/CMakeLists.txt app/src/main/java/org/triaevum/android/TriAevumActivity.java app/src/main/java/org/triaevum/android/TriAevumDownloadActivity.java app/src/main/java/org/triaevum/android/SpanishUi.java; do req "$f"; done

grep -q 'abiFilters += "arm64-v8a"' "$ROOT/app/build.gradle.kts" && echo '[OK] ARM64' || { echo '[FAIL] ARM64'; FAIL=1; }
grep -q 'targetSdk = 35' "$ROOT/app/build.gradle.kts" && echo '[OK] targetSdk 35' || { echo '[FAIL] targetSdk'; FAIL=1; }
grep -q -- '-Wl,-z,max-page-size=16384' "$ROOT/native/CMakeLists.txt" && echo '[OK] ELF 16 KiB' || { echo '[FAIL] ELF 16 KiB'; FAIL=1; }
grep -q 'nativeSurfaceDestroyed' "$ROOT/app/src/main/java/org/triaevum/android/TriAevumActivity.java" && grep -q 'nativeOnPause' "$ROOT/app/src/main/java/org/triaevum/android/TriAevumActivity.java" && echo '[OK] Lifecycle JNI' || { echo '[FAIL] Lifecycle JNI'; FAIL=1; }
if grep -RInE 'Configurações|Selecionar|Diretório|Desligado|Carregar|Salvar|Não foi|Falha ao|Pré-carregando' "$ROOT/app/src/main" --include='*.java' --include='*.kt' >/tmp/triaevum_pt.txt 2>/dev/null; then echo '[INFO] Cadenas portuguesas heredadas detectadas; SpanishUi debe traducirlas en runtime.'; head -40 /tmp/triaevum_pt.txt; fi
if [ "$FAIL" -ne 0 ]; then exit 1; fi
echo 'Validación estructural Android: OK'