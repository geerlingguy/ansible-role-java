# Ansible Role: Java

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-java.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-java)

Installs Java for RedHat/CentOS and Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values:

    # The defaults provided by this role are specific to each distribution.
    java_packages:
      - java-1.8.0-openjdk

Set the version/development kit of Java to install, along with any other necessary Java packages. Some other options include are included in the distribution-specific files in this role's 'defaults' folder.

    java_repos: []

If set, the role will install the corresponding repositories according to the distribution. Options include `zulu`.

    java_home: ""

If set, the role will set the global environment variable `JAVA_HOME` to this value.

## Dependencies

None.

## Example Playbook (using default package)

```yaml
- hosts: servers
  become: true
  roles:
    - role: geerlingguy.java
```

## Example Playbook (install OpenJDK 8)

For RHEL / CentOS:

```yaml
- hosts: servers
  become: true
  roles:
    - role: geerlingguy.java
      when: ansible_os_family == 'RedHat'
      vars:
        java_packages:
          - java-1.8.0-openjdk
```

For Ubuntu < 16.04:

```yaml
- hosts: servers
  become: true
  pre_tasks:
    - name: installing repo for Java 8 in Ubuntu
      apt_repository:
        repo: ppa:openjdk-r/ppa
      when: ansible_distribution == 'Ubuntu'
  roles:
    - role: geerlingguy.java
      when: ansible_os_family == 'Debian'
      vars:
        java_packages:
          - openjdk-8-jdk
```

## Example Playbook (install Zulu OpenJDK 8)

For RHEL / CentOS / Fedora / Debian / Ubuntu:

```yaml
- hosts: servers
  become: true
  roles:
    - role: geerlingguy.java
      when: ansible_os_family in ['RedHat', 'Debian']
      vars:
          java_repos:
            - zulu
          java_packages:
            - zulu-8
```

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
