#!/bin/bash
CLUSTER_NAME=$(kubectl config view --minify --output 'jsonpath={.clusters[0].name}'| awk -F'/' '{print $2}')
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
NAMESPACE="kube-system"

helm delete metrics-server -n ${NAMESPACE}

helm delete aws-load-balancer-controller -n ${NAMESPACE}
eksctl delete iamserviceaccount \
  --cluster=${CLUSTER_NAME} \
  --namespace=${NAMESPACE} \
  --name=aws-load-balancer-controller \

helm delete karpenter -n ${NAMESPACE}
eksctl delete iamidentitymapping \
    --cluster=${CLUSTER_NAME} \
    --arn="arn:aws:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}"
eksctl delete iamserviceaccount \
  --cluster=${CLUSTER_NAME} \
  --namespace=${NAMESPACE} \
  --name=karpenter