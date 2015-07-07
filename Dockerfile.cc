from eucalyptus/base:latest
#tag eucalyptus/cc:latest

run yum update -y
run yum install -y nc eucalyptus-cc ntp
run yum clean all

expose 8774/tcp
expose 22/tcp

cmd sed -i 's/^VNET_MODE.*/VNET_MODE="EDGE"/' /etc/eucalyptus/eucalyptus.conf; \
    sed -i 's/^server/#server/' /etc/ntp.conf; ntpd -p /var/run/ntpd.pid; \
    service eucalyptus-cc start; \
    service ntpd stop; \
    tail -f /var/log/eucalyptus/*.log
