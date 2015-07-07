from eucalyptus/base:latest
#tag eucalyptus/nc:latest

run yum update -y
run yum install -y ntp eucalyptus-nc
run yum clean all

expose 8774/tcp

cmd sed -i 's/^server/#server/' /etc/ntp.conf; ntpd -u root:root -p /var/run/ntpd.pid; \
    service eucalyptus-nc start; \
    service ntpd stop; \
    tail -f /var/log/eucalyptus/*.log
