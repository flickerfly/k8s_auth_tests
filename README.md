# Reason
I need my playbooks to work with self-signed certs. In certain scenarios, k8s group modules, run certification validation anyway. I found myself confused trying to track down what so I'm trying to work through what doesn't work. When a kube.config file exists to be found it will override these problems so running in a docker container assures we're not getting authentication from unexpected places.

Many of my issues were resolved by upgrading from Ansible 2.8.0 ot 2.8.6. but the K8S_AUTH_VERIFY_SSL variable still seems not useful.

# Assumptions
1. Testing against an openshift 3.11 cluster that is using self-signed certs and so you need to authenticate with certificate verification turned off. 
2. Docker is available for a clean testing environment (this helps assure that kube.config isn't being found in the background)
3. A creds.yaml file is in the root configured like the example.creds.yaml, but with real data.


# Usage
Clone this repo, then run this in the root to build:
`# docker build . -t ansible-k8s-test `

Run this in the repo root to run a test (where # is a number):
`# docker run --rm ansible-k8s-test test#.yaml`

# Expected Results:

## Fails
[test1.yaml](test1.yaml) - [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed
 - Only uses the ENV variable to permit self-signed certs: K8S_AUTH_VERIFY_SSL shows "False" in debug output, but still tries to verify.

## Successes
* [test2.yaml](test2.yaml) - Uses `validate_certs: no` in module_defaults
* [test3.yaml](test3.yaml) - Uses `validate_certs: no` in task
* [test4.yaml](test4.yaml) - Like test2, but with k8s_facts lookup task
* [test5.yaml](test5.yaml) - Like test2, but with k8s route creation & deletion task
* [test6.yaml](test6.yaml) - Uses a code block

