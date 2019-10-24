# Reason
I need my playbooks to work with self-signed certs. In certain scenarios, k8s group modules, run certification validation anyway. It is a bit hard to track down what so I'm trying to work through what doesn't work. When a kube.config file exists to be found it will override these problems so running in a docker container assures we're not getting authentication from unexpected places.

# Assumptions
1. Testing against an openshift 3.11 cluster that is using self-signed certs and so you need to authenticate with certificate verification turned off. 
2. Docker is available for a clean testing environment (this helps assure that kube.config isn't being found in the background)

# Usage
Clone this repo, then run this in the root to build:
# docker build . -t ansible-test 

Run this in the repo root to run a test (where # is a number):
docker run --rm ansible-test test#.yaml

# Expected Results:

## Fails
test1.yaml - [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed

# Successes

