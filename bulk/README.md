## What this test does

Executes a loop while logging warning that appears in the OpenShift events:
- creates the OpenShift [Hello World app](https://github.com/openshift/origin/tree/master/examples/hello-openshift) (`oc apply -f helloworld.yml`)
- waits until the application is available
- deletes all resources created by the application (`oc delete all --all; oc delete pvc --all`)
- waits until the resources are deleted

and logs any warning that is logged in the OpenShift events.

## How to run it

```bash
export NAMESPACE=<your-openshift-namespace>
bash ./run.sh
```

