VAGRANTIP=$(vagrant ssh-config | grep HostName | cut -d' ' -f4)
CLOUDCONTROLLER_HOST=${VAGRANTIP}
WALRUS_HOST=${VAGRANTIP}
STORAGECONTROLLER_HOST=${VAGRANTIP}
CLUSTERCONTROLLER_HOST=${VAGRANTIP}
NETWORKCONTROLLER_HOST=${VAGRANTIP}

# The CLC is listening on ports 8443 and 8773
@test "clc - 8443" {
  nc -zw1 $CLOUDCONTROLLER_HOST 8443
}
@test "clc - 8773" {
  nc -zw1 $CLOUDCONTROLLER_HOST 8773
}

# Walrus is listening on port 8773
@test "walrus - 8773" {
  nc -zw1 $WALRUS_HOST 8773
}

# The SC is listening on port 8773
@test "sc - 8773" {
  nc -zw1 $STORAGECONTROLLER_HOST 8773
}

# The CC is listening on port 8774
@test "cc - 8774" {
  nc -zw1 $CLUSTERCONTROLLER_HOST 8774
}

# The NCs are listening on port 8775
@test "nc - 8775" {
  nc -zw1 $NETWORKCONTROLLER_HOST 8775
}


# Log files are being written to /var/log/eucalyptus/
# If you are using the subscription only VMware Broker, it is listening on port 8773