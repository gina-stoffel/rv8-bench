#!/bin/bash

# Output logs

source $TEST_CONFIG

set -e

for tst in riscv64/*; do
    tst=$(basename $tst)

    echo "Running $tst"
    for RUN_N in $(seq $REPS); do

        BASE_LOG_FILE=${TEST_LOG_DIR}/base_${tst}_${RUN_N}.log
        KEYSTONE_LOG_FILE=${TEST_LOG_DIR}/keystone_${tst}_${RUN_N}.log

        if [[ $RUN_BASELINE == 1 ]]; then
            { time ./riscv64/${tst}; } &> ${BASE_LOG_FILE}
        fi

        if [[ $RUN_KEYSTONE == 1 ]]; then
            { time ${TEST_RUNNER} ./riscv64/${tst} ${EYRIE_FULL_SUPPORT} ${DEFAULT_USZ} ${XLARGE_FSZ} 1 0; } &> ${KEYSTONE_LOG_FILE}
        fi
    done
done
