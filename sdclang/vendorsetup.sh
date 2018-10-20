# Set SDClang defaults
export SDCLANG=false
export SDCLANG_PATH=vendor/qcom/sdclang/dragontc-7.0/bin
export SDCLANG_LTO_DEFS=vendor/xtended/sdclang/sdllvm-lto-defs.mk
export SDCLANG_COMMON_FLAGS="-Ofast -g0 -mcpu=cortex-a57 -Wno-user-defined-warnings -Wno-vectorizer-no-neon -Wno-unknown-warning-option \
-Wno-deprecated-register -Wno-tautological-type-limit-compare -Wno-sign-compare -Wno-gnu-folding-constant \
-Wno-inline-asm -Wno-unused-command-line-argument -Wno-unused-variable \
-mllvm -polly -mllvm -polly-process-unprofitable -ffp-contract=fast \
-mllvm -polly-optimized-scops -mllvm -polly-tiling=false"

# Enable based on host OS/availablitiy
case $(uname -s) in
    Linux)
        if [ -d "$SDCLANG_PATH" ]; then
            export SDCLANG=true
        fi
        ;;
    Darwin)
        ;;
    *)
        ;;
esac
