#!/bin/sh
DEFAULT_NAMESPACE=fatapp
for number in {1..2} 
do
  PROJECT_NAME=${DEFAULT_NAMESPACE}-${number}
  echo "deleting namespace: $PROJECT_NAME"
  oc delete ns $PROJECT_NAME
done
  oc delete -f ./helloworld.yml
