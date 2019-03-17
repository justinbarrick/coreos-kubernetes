FROM justinbarrick/ansible-operator:no-leader

USER root

RUN pip install dopy

ENV ANSIBLE_INVENTORY=/etc/ansible/hosts
ENV OPERATOR_NAME=bootstrap
ENV ANSIBLE_PRIVATE_KEY_FILE=/etc/ansible/ssh_key

COPY ansible.cfg /etc/ansible/ansible.cfg

RUN ansible-galaxy install defunctzombie.coreos-bootstrap

COPY watches.yaml /opt/ansible/watches.yaml
COPY hosts /etc/ansible/hosts
COPY playbook.yaml /opt/ansible/playbook.yaml
COPY roles/kubernetes /opt/ansible/roles/kubernetes
