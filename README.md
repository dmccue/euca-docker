# euca-docker

Setup
---
git clone https://github.com/dmccue/euca-docker
cd euca-docker
./setup.sh


Deploy
---
vagrant destroy -f
vagrant up


Test
---
bats tests/services.bats


GUI
---
./docker_eucaconsole.sh