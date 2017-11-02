#!/bin/sh
DEFAULT_NAMESPACE=fatapp
for number in {2..100} 
do
  PROJECT_NAME=${DEFAULT_NAMESPACE}-${number}
  echo "deleting namespace: $PROJECT_NAME"

  oc project $PROJECT_NAME
  oc delete pvc --all
  oc delete ns $PROJECT_NAME

done


oc delete -f ./helloworld.yml
