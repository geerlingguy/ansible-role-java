# Ansible Role: Java

Installs Java for RHEL/CentOS 6.x.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `vars/main.yml`):

    java_packages:
      - java-1.6.0-openjdk

Set the version/development kit of Java to install, along with any other necessary Java packages. Some other options include `java` or `java-1.7.0-openjdk`.

## Dependencies

None.

## Example Playbook

    - hosts: servers
      roles:
        - { role: geerlingguy.java }

## License

MIT / BSD

## Author Information

This role was created in 2014 by Jeff Geerling (@geerlingguy), author of Ansible for DevOps. You can find out more about the book at http://ansiblefordevops.com/, and learn about the author at http://jeffgeerling.com/.
