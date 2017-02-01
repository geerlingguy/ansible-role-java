#!/usr/bin/env bash

set -e

PULL=0
IDEM=0
REMOVE=0
ROLE=test
SYNTAX=0
VERBOSE=

while [[ $# -gt 1 ]]
    do
    key="$1"

    case $key in
        -o|--os)
        DISTRO="$2"
        shift
        ;;
        -p|--pull)
        PULL=1
        ;;
        -r|--role)
        ROLE="$2"
        shift
        ;;
        -i|--idempotency)
        IDEM=1
        ;;
        -d|--delete)
        REMOVE=1
        ;;
        -s|--syntax)
        SYNTAX=1
        ;;
        -v|--verbose)
        VERBOSE="-vvv"
        ;;
        *)
            # unknown option
        ;;
    esac
    shift
done

if [ "${DISTRO}" == "" ] ; then
    echo "usage: ./start.sh [OPTIONS]... -o|--os [DISTRO] "
    echo "   -o|-os            sets the distro to be used (ubuntu1604, ubuntu1404, ubuntu1204, centos7, fedora24, centos6, debian8)"
    echo "   -p|-pull          distro will be pulled from repo"
    echo "   -i|-idempotency   idempotency check will be run"
    echo "   -d|-delete        removes ALL current docker containers before running any checks"
    echo "   -r|-role          which role to execute, default 'test'"
    echo "   -s|-syntax        runs syntax check"
    exit 1;
fi

declare -A DISTROS
DISTROS[ubuntu1604]="geerlingguy/docker-ubuntu1604-ansible:latest"
DISTROS[ubuntu1404]="geerlingguy/docker-ubuntu1404-ansible:latest"
DISTROS[ubuntu1204]="geerlingguy/docker-ubuntu1204-ansible:latest"
DISTROS[centos6]="geerlingguy/docker-centos6-ansible:latest"
DISTROS[centos7]="geerlingguy/docker-centos7-ansible:latest"
DISTROS[debian8]="geerlingguy/docker-debian8-ansible:latest"
DISTROS[fedora24]="geerlingguy/docker-fedora24-ansible:latest"

declare -A INITS
INITS[ubuntu1604]="/lib/systemd/systemd"
INITS[ubuntu1404]="/sbin/init"
INITS[ubuntu1204]="/sbin/init"
INITS[centos6]="/sbin/init"
INITS[centos7]="/usr/lib/systemd/systemd"
INITS[debian8]="/lib/systemd/systemd"
INITS[fedora24]="/usr/lib/systemd/systemd"

declare -A OPTS
OPTS[ubuntu1604]="--privileged"
OPTS[ubuntu1404]=""
OPTS[ubuntu1204]=""
OPTS[centos6]=""
OPTS[centos7]="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
OPTS[debian8]="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
OPTS[fedora24]="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"

if [ "${DISTROS[${DISTRO}]}" == "" ] ; then
    echo "unkown distro, available: ubuntu1604, ubuntu1404, ubuntu1204, centos7, centos6, debian8"
    exit 1;
fi

if [ ${REMOVE} -eq 1 ] ; then
    echo "removing all docker containers..."
    docker rm -f $(sudo docker ps -a -q) || true
fi

if [ ${PULL} -eq 1 ] ; then
    echo "pulling distro..."
    docker pull ${DISTROS[${DISTRO}]}
fi

echo "creating docker image..."
container_id=$(mktemp)
docker run --detach -v /dev/urandom:/dev/random --volume="${PWD}":/etc/ansible/roles/role_under_test:ro ${OPTS[${DISTRO}]} ${DISTROS[${DISTRO}]} "${INITS[${DISTRO}]}" > "${container_id}"

echo "using container id: $(cat ${container_id})"

if [ ${SYNTAX} -eq 1 ] ; then
    echo "checking syntax..."
    docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/${ROLE}.yml --syntax-check
fi

echo "first test run..."
docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook ${VERBOSE} /etc/ansible/roles/role_under_test/tests/${ROLE}.yml

if [ ${IDEM} -eq 1 ] ; then
    idempotence=$(mktemp)
    echo "second test run for idempotency..."
    docker exec --tty "$(cat ${container_id})" env TERM=xterm ansible-playbook ${VERBOSE} --skip-tags "test" /etc/ansible/roles/role_under_test/tests/${ROLE}.yml | tee -a ${idempotence}
    tail ${idempotence} | grep -q 'changed=0.*failed=0' && (echo 'Idempotence test: pass' && exit 0) || (echo 'Idempotence test: fail' && exit 1)
fi

echo "used container id: $(cat ${container_id})"