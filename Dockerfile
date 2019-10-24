FROM ubuntu:18.04
VOLUME /app
WORKDIR /app

# Ansible will not use ansible.cfg in a world writeable directory
RUN ["chmod", "o-w", "/app"]

# install some apt dependencies and clean up after ourselves
RUN apt-get -q update && \
    apt-get -q -y install python-pip unzip wget openssh-client && \
    apt-get -q clean

# install some python dependencies including ansible
ADD requirements.txt /tmp/requirements.txt
RUN pip install -q -r /tmp/requirements.txt

ENTRYPOINT ["ansible-playbook","-v"]
COPY *.yaml /app/

# We're using self-signed certificates
ENV K8S_AUTH_VERIFY_SSL False
#ENV ANSIBLE_HOST_KEY_CHECKING False
