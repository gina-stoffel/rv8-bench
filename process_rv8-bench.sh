#!/bin/bash

source $TEST_CONFIG

for tst in riscv64/*; do
    tst=$(basename $tst)
    TEST_LOG_FILE=${TEST_LOG_DIR}/BASE_${tst}.log
    KTEST_LOG_FILE=${TEST_LOG_DIR}/KEYSTONE_${tst}.log
    rm -f ${TEST_LOG_FILE}
    rm -f ${KTEST_LOG_FILE}
    for RUN_N in $(seq $REPS); do

        BASE_LOG_FILE=${TEST_LOG_DIR}/base_${tst}_${RUN_N}.log
        KEYSTONE_LOG_FILE=${TEST_LOG_DIR}/keystone_${tst}_${RUN_N}.log

        if [[ $RUN_BASELINE == 1 ]]; then
            Breal=$(cat ${BASE_LOG_FILE} | grep "real" | cut -d$'\t' -f '2')
            Binter=$(cat ${BASE_LOG_FILE} | grep "iruntime" | cut -d' ' -f 2)
            printf "%s %s\n" "$Breal" "$Binter">> ${TEST_LOG_FILE}
        fi

        if [[ $RUN_KEYSTONE == 1 ]]; then
            # Grab anything useful
            Kreal=$(cat ${KEYSTONE_LOG_FILE} | grep "real" | cut -d$'\t' -f '2')
            Kinit=$(cat ${KEYSTONE_LOG_FILE} | grep "Init" | cut -d' ' -f 3)
            Kinter=$(cat ${KEYSTONE_LOG_FILE} | grep "iruntime" | cut -d' ' -f 2)
            Krun=$(cat ${KEYSTONE_LOG_FILE} | grep "Runtime" | cut -d ' ' -f 3)

            # Print only what we want
            printf "%s %s\n" "$Kreal" "$Kinter" >> ${KTEST_LOG_FILE}
        fi
    done;

    echo ${tst} >> ${TEST_LOG_DIR}/TESTLIST
done;
