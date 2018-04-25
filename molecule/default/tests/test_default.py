import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_packages(host):
    assert (host.package('openjdk-8-jdk').is_installed
            or host.package('java-1.8.0-openjdk').is_installed)


def test_binaries(host):

    # Check java availability and the default version
    run1 = host.run('java -version')

    assert run1.rc == 0

    # Check 'javac' and 'java' must be the same version
    javac = host.run('javac -version')
    assert javac.rc == 0

    javac_version = javac.stderr.split()[1]

    java_version = run1.stderr.split('\n')[0]

    assert java_version == 'openjdk version "%s"' % javac_version


def test_jce(host):
    cmd = "jrunscript -e 'print "
    cmd += "(javax.crypto.Cipher.getMaxAllowedKeyLength(\"RC5\") >= 256);'"
    run = host.run(cmd)
    assert 'true' in run.stdout
