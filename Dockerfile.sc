from eucalyptus/base:latest
#tag eucalyptus/sc:latest

run yum update -y
run yum install -y ntp eucalyptus-sc
run yum clean all

expose 8777/tcp
expose 22/tcp

cmd sed -i 's/^server/#server/' /etc/ntp.conf; ntpd -p /var/run/ntpd.pid; \
    service eucalyptus-cloud start; \
    service ntpd stop; \
    tail -f /var/log/eucalyptus/*.log
