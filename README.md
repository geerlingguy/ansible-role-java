# Ansible Role: Java

[![Build Status](https://travis-ci.org/geerlingguy/ansible-role-java.svg?branch=master)](https://travis-ci.org/geerlingguy/ansible-role-java)

Installs Java for RedHat/CentOS and Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values:

    # The defaults provided by this role are specific to each distribution.
    java_packages:
      - java-1.7.0-openjdk

Set the version/development kit of Java to install, along with any other necessary Java packages. Some other options include are included in the distribution-specific files in this role's 'defaults' folder.

    java_home: ""

If set, the role will set the global environment variable `JAVA_HOME` to this value.

    # Ubuntu/Debian specific:
    java_ppa_repos: <undefined>

If set, the role will add the given custom ppa repository before installing the Java packages.
For example to install openjdk-8 on Ubuntu 14.x, set the following:

    java_ppa_repos: "ppa:openjdk-r/ppa"
    java_packages:
       - openjdk-8-jdk


## Dependencies

None.

## Example Playbook (using default package, usually OpenJDK 7)

    - hosts: servers
      roles:
        - geerlingguy.java

## Example Playbook (install OpenJDK 8)

For RHEL / CentOS:

    - hosts: server
      roles:
        - role: geerlingguy.java
          when: "ansible_os_family == 'RedHat'"
          java_packages:
            - java-1.8.0-openjdk

For Ubuntu:

    - hosts: server
      roles:
        - role: geerlingguy.java
          when: "ansible_os_family == 'Debian'"
          java_packages:
            - openjdk-8-jdk
          #ppa repos only required for Ubuntu < 16.04
          java_openjdk_ppa_repos_support: true

## License

MIT / BSD

## Author Information

This role was created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
