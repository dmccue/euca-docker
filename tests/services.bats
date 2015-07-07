#!/usr/bin/env bats
WALRUS_HOST=${VAGRANTIP}
CLOUDCONTROLLER_HOST=${VAGRANTIP}
STORAGECONTROLLER_HOST=${VAGRANTIP}
CLUSTERCONTROLLER_HOST=${VAGRANTIP}
NETWORKCONTROLLER_HOST=${VAGRANTIP}

#nc -vzw1 ${VAGRANTIP} 8000-9000 2>&1| grep open$
#nc -vzw1 ${VAGRANTIP} 53 8443 8773 8774 8777 8779 2>&1| grep open$

@test "22/tcp - ssh connectivity" {
  nc -zw1 $VAGRANTIP 22
}
@test "53/tcp - eucalpytus-cloud dns" {
  nc -zw1 $VAGRANTIP 53
}
@test "8777/tcp - postgres" {
  nc -zw1 $VAGRANTIP 8777
}
@test "8779/tcp - eucalyptus-cloud" {
  nc -zw1 $VAGRANTIP 8779
}



@test "8443/tcp - clc" {
  nc -zw1 $CLOUDCONTROLLER_HOST 8443
}
@test "8773/tcp - clc" {
  nc -zw1 $CLOUDCONTROLLER_HOST 8773
}

@test "8773/tcp - walrus" {
  nc -zw1 $WALRUS_HOST 8773
}

@test "8773/tcp - sc" {
  nc -zw1 $STORAGECONTROLLER_HOST 8773
}

@test "8774/tcp - cc" {
  nc -zw1 $CLUSTERCONTROLLER_HOST 8774
}

@test "8775/tcp - nc" {
  nc -zw1 $NETWORKCONTROLLER_HOST 8775
}


# Log files are being written to /var/log/eucalyptus/
# If you are using the subscription only VMware Broker, it is listening on port 8773
