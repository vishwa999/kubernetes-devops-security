#!/bin/bash

# Using Kubesec v2 API to scan the Kubernetes YAML file
scan_result=$(curl -sS --data-binary @"k8s_deployment_service.yaml" https://v2.kubesec.io/scan)

# Extract the message and score from the scan result using jq
scan_message=$(echo "$scan_result" | jq '.[0].message' -r)
scan_score=$(echo "$scan_result" | jq '.[0].score')

# Kubesec scan result processing
echo "Scan Score: $scan_score"

# Ensure that the score is a valid number before comparison
if [[ "$scan_score" =~ ^[0-9]+$ ]]; then
  if [[ "$scan_score" -ge 5 ]]; then
    echo "Score is $scan_score"
    echo "Kubesec Scan Message: $scan_message"
  else
    echo "Score is $scan_score, which is less than or equal to 5."
    echo "Scanning Kubernetes Resource has Failed"
    exit 1
  fi
else
  echo "Error: Scan score is not a valid number: $scan_score"
  exit 1
fi
