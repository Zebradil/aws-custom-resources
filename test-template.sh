#!/usr/bin/env bash

function cleanup() {
	aws cloudformation delete-stack --stack-name ${STACK_NAME}
}

trap 'exit 1' ERR

TEMPLATE=$1
shift

STACK_NAME=$(basename ${TEMPLATE})
STACK_NAME=${STACK_NAME%.*}

aws cloudformation validate-template \
	--template-body file://${TEMPLATE} \
	--output table

aws cloudformation deploy \
	--template-file ${TEMPLATE} \
	--stack-name ${STACK_NAME} \
	--capabilities CAPABILITY_IAM

cleanup
