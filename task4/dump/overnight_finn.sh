#!/bin/bash
set -u  # catch unset-variable typos in this script (not -e: we want to continue after a failed build)

cd "$(dirname "$0")" || exit 1

MAIN_LOG="./finn_runs_log.txt"
SCRIPT_LOG="./run_all_builds_script.log"

# Send all of this script's own stdout/stderr (echoes, bash errors, set -u warnings)
# to SCRIPT_LOG, while still printing to the terminal if run interactively.
exec > >(tee -a "$SCRIPT_LOG") 2>&1

mkdir -p ./finn_out/gtsrb_12x12_w2a2_c12x24x36/logs
mkdir -p ./finn_out/gtsrb_12x12_w2a3_c12x24x36/logs
mkdir -p ./finn_out/gtsrb_12x12_w2a3_c16x32x64/logs
mkdir -p ./finn_out/gtsrb_12x12_w2a3_c8x16x32/logs

SUCCESS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0
FAILED_BUILDS=()

echo "===== FINN RUN STARTED $(date) =====" | tee -a "$MAIN_LOG"

# run_build <config_yaml> <output_log> <label>
run_build() {
    local cfg="$1"
    local out_log="$2"
    local label="$3"

    if [ ! -f "$cfg" ]; then
        echo "[SKIP]  $label — config not found: $cfg" | tee -a "$MAIN_LOG"
        SKIP_COUNT=$((SKIP_COUNT + 1))
        return
    fi

    local start_ts=$(date +%s)
    echo "[START] $label at $(date)" | tee -a "$MAIN_LOG"

    finn build "$cfg" > "$out_log" 2>&1
    local exit_code=$?

    local end_ts=$(date +%s)
    local elapsed=$((end_ts - start_ts))
    local elapsed_fmt=$(printf '%02d:%02d:%02d' $((elapsed/3600)) $((elapsed%3600/60)) $((elapsed%60)))

    if [ $exit_code -eq 0 ]; then
        echo "[SUCCESS] $label finished in ${elapsed_fmt} at $(date) — log: $out_log" | tee -a "$MAIN_LOG"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "[FAILURE] $label FAILED (exit code $exit_code) after ${elapsed_fmt} at $(date) — see $out_log" | tee -a "$MAIN_LOG"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        FAILED_BUILDS+=("$label")
        # show the last few lines of the failing log inline, so you don't have to
        # go hunting through finn_out/ to see why it died
        echo "  --- last 15 lines of $out_log ---" | tee -a "$MAIN_LOG"
        tail -n 15 "$out_log" | sed 's/^/  /' | tee -a "$MAIN_LOG"
        echo "  ---------------------------------" | tee -a "$MAIN_LOG"
    fi
}

# 1) 12x12_w2a3_c12x24x36
run_build "./build_gtsrb_12x12_w2a3_c12x24x36_fps400000.yaml"  "./finn_out/gtsrb_12x12_w2a3_c12x24x36/logs/log_400000.txt"  "12x12_w2a3_c12x24x36_fps400000"
run_build "./build_gtsrb_12x12_w2a3_c12x24x36_fps800000.yaml"  "./finn_out/gtsrb_12x12_w2a3_c12x24x36/logs/log_800000.txt"  "12x12_w2a3_c12x24x36_fps800000"
run_build "./build_gtsrb_12x12_w2a3_c12x24x36_fps1200000.yaml" "./finn_out/gtsrb_12x12_w2a3_c12x24x36/logs/log_1200000.txt" "12x12_w2a3_c12x24x36_fps1200000"

# 2) 12x12_w2a3_c8x16x32
run_build "./build_gtsrb_12x12_w2a3_c8x16x32_fps400000.yaml"  "./finn_out/gtsrb_12x12_w2a3_c8x16x32/logs/log_400000.txt"  "12x12_w2a3_c8x16x32_fps400000"
run_build "./build_gtsrb_12x12_w2a3_c8x16x32_fps800000.yaml"  "./finn_out/gtsrb_12x12_w2a3_c8x16x32/logs/log_800000.txt"  "12x12_w2a3_c8x16x32_fps800000"
run_build "./build_gtsrb_12x12_w2a3_c8x16x32_fps1200000.yaml" "./finn_out/gtsrb_12x12_w2a3_c8x16x32/logs/log_1200000.txt" "12x12_w2a3_c8x16x32_fps1200000"

# 3) 12x12_w2a3_c16x32x64
run_build "./build_gtsrb_12x12_w2a3_c16x32x64_fps400000.yaml"  "./finn_out/gtsrb_12x12_w2a3_c16x32x64/logs/log_400000.txt"  "12x12_w2a3_c16x32x64_fps400000"
run_build "./build_gtsrb_12x12_w2a3_c16x32x64_fps800000.yaml"  "./finn_out/gtsrb_12x12_w2a3_c16x32x64/logs/log_800000.txt"  "12x12_w2a3_c16x32x64_fps800000"
run_build "./build_gtsrb_12x12_w2a3_c16x32x64_fps1200000.yaml" "./finn_out/gtsrb_12x12_w2a3_c16x32x64/logs/log_1200000.txt" "12x12_w2a3_c16x32x64_fps1200000"

# 4) 12x12_w2a2_c12x24x36
run_build "./build_gtsrb_12x12_w2a2_c12x24x36_fps400000.yaml"  "./finn_out/gtsrb_12x12_w2a2_c12x24x36/logs/log_400000.txt"  "12x12_w2a2_c12x24x36_fps400000"
run_build "./build_gtsrb_12x12_w2a2_c12x24x36_fps800000.yaml"  "./finn_out/gtsrb_12x12_w2a2_c12x24x36/logs/log_800000.txt"  "12x12_w2a2_c12x24x36_fps800000"
run_build "./build_gtsrb_12x12_w2a2_c12x24x36_fps1200000.yaml" "./finn_out/gtsrb_12x12_w2a2_c12x24x36/logs/log_1200000.txt" "12x12_w2a2_c12x24x36_fps1200000"

echo "===== FINN RUN COMPLETED $(date) =====" | tee -a "$MAIN_LOG"
echo "Summary: ${SUCCESS_COUNT} succeeded, ${FAIL_COUNT} failed, ${SKIP_COUNT} skipped" | tee -a "$MAIN_LOG"
if [ ${#FAILED_BUILDS[@]} -gt 0 ]; then
    echo "Failed builds:" | tee -a "$MAIN_LOG"
    for b in "${FAILED_BUILDS[@]}"; do
        echo "  - $b" | tee -a "$MAIN_LOG"
    done
fi

if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
fi
exit 0