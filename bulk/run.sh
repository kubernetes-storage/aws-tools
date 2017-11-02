#!/bin/bash

DEFAULT_DC=che
DEFAULT_TIMEOUT_SEC=3600
DEFAULT_NAMESPACE=bigfatapp

wait_app_availability () {
    dc_name=${DC_NAME:-${DEFAULT_DC}}
    timeout_sec=${START_TIMEOUT:-${DEFAULT_TIMEOUT_SEC}}

    available=$(oc get dc "${dc_name}" -o json | jq '.status.conditions[] | select(.type == "Available") | .status')

    POLLING_INTERVAL_SEC=5
    end=$((SECONDS+timeout_sec))
    while [ "${available}" != "\"True\"" ] && [ ${SECONDS} -lt ${end} ]; do
        available=$(oc get dc "${dc_name}" -o json | jq '.status.conditions[] | select(.type == "Available") | .status')
        # progressing=$(oc get dc "${dc_name}" -o json | jq '.status.conditions[] | select(.type == "Progressing") | .status')
        # timeout_in=$((end-SECONDS))
        # echo "[CHE] Deployment is in progress...(Available.status=${available}, Progressing.status=${progressing}, Timeout in ${timeout_in}s)"
        sleep ${POLLING_INTERVAL_SEC}
    done
}

wait_until_all_resources_are_deleted() {
    timeout_sec=3600
    POLLING_INTERVAL_SEC=3
    resources_num=$(oc get all -o json 2>/dev/null | jq '.items | length')
    end=$((SECONDS+timeout_sec))
    while [ "${resources_num}" -gt "0" ] && [ ${SECONDS} -lt ${end} ]; do
        resources_num=$(oc get all -o json 2>/dev/null | jq '.items | length')
        #timeout_in=$((end-SECONDS))
        sleep ${POLLING_INTERVAL_SEC}
    done
}
 

wait_until_all_pods_are_stopped() {
    timeout_sec=3600
    POLLING_INTERVAL_SEC=3
    resources_num=$(oc get pods -o json 2>/dev/null | jq '.items | length')
    end=$((SECONDS+timeout_sec))
    while [ "${resources_num}" -gt "0" ] && [ ${SECONDS} -lt ${end} ]; do
        resources_num=$(oc get pods -o json 2>/dev/null | jq '.items | length')
        #timeout_in=$((end-SECONDS))
        sleep ${POLLING_INTERVAL_SEC}
    done
}

# oc new-project $DEFAULT_NAMESPACE
# oc project $DEFAULT_NAMESPACE
 
oc get events -o json --watch-only | jq 'select (.type!="Normal") | .message' &
MYSELF=$!

SCRIPT_DURATION_SEC=60
end=$((SECONDS+${SCRIPT_DURATION_SEC}))
for number in {1..100} 
do
    start=${SECONDS}
    PROJECT_NAME=${DEFAULT_NAMESPACE}-${number}
echo "creating project named $PROJECT_NAME"
    oc new-project ${PROJECT_NAME}
    oc project ${PROJECT_NAME}
    
    echo "[INFO] Creating helloworld application on openshift.io with 2 PVCs"
    oc apply -f ./helloworld.yml  

    echo "[INFO] Waiting helloworld to be available"
    wait_app_availability 
    
    duration=$((SECONDS-start))
    echo "[INFO] helloworld is ready and available: it took $duration seconds"

    start=${SECONDS}

    # echo "[INFO] Now idling the application"
    # oc idle che-host >/dev/null 1>
    # wait_until_all_pods_are_stopped

 #   echo "[INFO] Now removing all resources"
 #   oc delete all --all -n "${NAMESPACE:-${DEFAULT_NAMESPACE}}" >/dev/null 2>&1
 #   oc delete pvc --all -n "${NAMESPACE:-${DEFAULT_NAMESPACE}}" >/dev/null 2>&1
#    echo "[INFO] Waiting for all resources to be deleted"
#    wait_until_all_resources_are_deleted

    duration=$((SECONDS-start))
    echo "[INFO] Done: it took $duration seconds"
    echo ""
    echo ""
    echo ""
done

# kill $MYSELF >/dev/null 2>&1

