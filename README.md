# euca-docker

Tested against MACOS Yosemite 10.10.3 with Parallels 10.1.3

Setup
===========
Install dependencies

```bash
git clone https://github.com/dmccue/euca-docker
cd euca-docker; ./setup.sh
```

Deploy
===========
Startup eucalyptus cloud using ansible provisioner

```bash
vagrant destroy -f
vagrant up
```

Test
===========
Test all subcomponents are responding

```bash
VAGRANTIP=$(vagrant ssh-config | sed -En 's/.*HostName (.*)$/\1/p') ./tests/services.bats
```

Startup GUI
===========
Start eucaconsole within a docker container

```bash
./docker_eucaconsole.sh
```
