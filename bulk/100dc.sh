#!/bin/sh
DEFAULT_NAMESPACE=fatapp
for number in {1..100} 
do
  PROJECT_NAME=${DEFAULT_NAMESPACE}-${number}
  echo "creating project named $PROJECT_NAME"
  oc new-project ${PROJECT_NAME} >/dev/null 2>&1
  oc apply -f ./helloworld.yml
done
