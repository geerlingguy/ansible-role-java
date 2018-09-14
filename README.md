# Ansible Role: OpenJDK Java

[![Build Status](https://travis-ci.org/peopledoc/ansible-role-java.svg?branch=master)](https://travis-ci.org/peopledoc/ansible-role-java)

Installs OpenJDK Java for RedHat/CentOS and Debian/Ubuntu linux servers.

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values:

    # The defaults provided by this role are specific to each distribution.
    java_packages:
      - java-1.7.0-openjdk

Set the version/development kit of Java to install, along with any other necessary Java packages.
By default, it will try to install OpenJDK 8, even if it is not feasible (it will fail, in that case).

CA certificates can be added to the java keystore with the following variables:

```yaml
    ca-certificates:
      certificates:
        - alias: cert
          path: /usr/local/share/ca-certificates/cert.crt
        - url: google.com
      password: changeit
```

```yaml
    keep_oracle_jdk: false
    add_bouncycastle: true
```

This role uninstall OracleJDK by default. You can change the
`keep_oracle_jdk` variable to keep it. This is only available on
Debian distributions. `add_bouncycastle` can be used to add
bouncycastle libs to the JDK.

## Dependencies

None.

## Dependencies for tests

The dependencies are `ansible`, `molecule` and `docker-py` Python packages.

## Tests

Tests can be executed using:

```
$ molecule --debug test --driver-name docker
```

## License

MIT / BSD

## Author Information

This role was originally created in 2014 by [Jeff Geerling](https://www.jeffgeerling.com/), author of [Ansible for DevOps](https://www.ansiblefordevops.com/).
