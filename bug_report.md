##### SUMMARY
In various scenarios (details below) when using the k8s group of modules requesting no certificate verification fails making self-signed certificate scenarios challenging.

##### ISSUE TYPE
- Bug Report

##### COMPONENT NAME

k8s
k8s_facts
k8s_auth

##### ANSIBLE VERSION

```
ansible 2.8.6
  config file = None
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/lib/python2.7/dist-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 2.7.15+ (default, Oct  7 2019, 17:39:04) [GCC 7.4.0]
```

##### CONFIGURATION

I'm running default Ansible config against localhost on a Ubuntu 18.04 Docker container.

```
nothing output from ansible-config dump --only-changed but a blank line
```

##### OS / ENVIRONMENT

I'm creating playbooks run from a clean Docker image. I have [a repo with my environment available](https://github.com/flickerfly/k8s_auth_tests) which should help replicate.

Basically, build and run against a specific test like this:
`docker build . -t ansible-test && docker run --rm ansible-test test1.yaml`


##### STEPS TO REPRODUCE
Run the playbook test1.yaml against an OpenShift cluster with self-signed certs.

```
git clone https://github.com/flickerfly/k8s_auth_tests
cd k8s_auth_tests
cp example.creds.yaml creds.yaml 
vim creds.yaml
docker build . -t ansible-test
docker run --rm ansible-test test1.yaml
```

##### EXPECTED RESULTS
When the Dockerfile passes the variable and Ansible is able to show it in the output as "K8S_AUTH_VERIFY_SSL: no", I expect self-signed certs to not be verifield.


##### ACTUAL RESULTS
I get the error `[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify` when I try to log into openshift.

```paste below
No config file found; using defaults
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that
the implicit localhost does not match 'all'

PLAY [test1] *******************************************************************

TASK [Test Information] ********************************************************
ok: [localhost] => (item=Ansible: 2.8.6) => {
    "msg": "Ansible: 2.8.6"
}
ok: [localhost] => (item=K8S_AUTH_VERIFY_SSL: no) => {
    "msg": "K8S_AUTH_VERIFY_SSL: no"
}
ok: [localhost] => (item=Test: test1 admin@https://ocp.example.com:8443) => {
    "msg": "Test: test1 admin@https://ocp.example.com:8443"
}
ok: [localhost] => (item=Expect Cert Verify Failure: Tests if ENV variable is functioning as expected) => {
    "msg": "Expect Cert Verify Failure: Tests if ENV variable is functioning as expected"
}

TASK [Log in] ******************************************************************
An exception occurred during task execution. To see the full traceback, use -vvv. The error was: SSLError: HTTPSConnectionPool(host='ocp.example.com', port=8443): Max retries exceeded with url: /.well-known/oauth-authorization-server (Caused by SSLError(SSLError(1, u'[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:727)'),))
fatal: [localhost]: FAILED! => {"changed": false, "msg": "HTTPSConnectionPool(host='ocp.example.com', port=8443): Max retries exceeded with url: /.well-known/oauth-authorization-server (Caused by SSLError(SSLError(1, u'[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:727)'),))"}

PLAY RECAP *********************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
