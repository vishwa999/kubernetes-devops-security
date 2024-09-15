#!/bin/bash

# using kubesec v2 api
scan_result=$(curl -sS POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan)
scan_message=$(curl -sS POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq .[].message -r)
scan_score=$(curl -sS POST --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan | jq .[].score)

# Kubesec scan result processing
echo "Scan Score: $scan_score"

if [[ "${scan_score}" -ge 5 ]]; then
  echo "Score is $scan_score"
  echo "Kubesec Scan $scan_message"
else
  echo "Score is $scan_score, which is less than or equal to 5."
  echo "Scanning Kubernetes Resource has Failed"
  exit 1;
fi;