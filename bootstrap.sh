# David McCue 2015

IP=$(hostname -I | cut -d ' ' -f2)
clustername=cluster01

echo NTPD setup
service ntpd stop
ntpdate pool.ntp.org
service ntpd start
chkconfig ntpd on

echo SSH setup
mkdir -p ~/.ssh; chmod 700 ~/.ssh
[ ! -f "~/.ssh/id_rsa" ] && ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''
grep -f ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys &>/dev/null || cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H ${IP} >> ~/.ssh/known_hosts
nc -zw15 localhost 8773


echo Register Walrus
until euca_conf --register-walrusbackend --partition walrus --host ${IP} --component walrus-$(hostname -s); do
  sleep 1
done
echo Register Cloud Controller
euca_conf --register-cluster --partition ${clustername} --host ${IP} --component cc-$(hostname -s)
echo Register Storage Controller
euca_conf --register-sc --partition ${clustername} --host ${IP} --component sc-$(hostname -s)
echo Register Network Controller
euca_conf --register-nodes ${IP}
echo Register API
euca_conf --register-service -T user-api -H ${IP} -N API_135
# Skip arbitrators
echo "Info: Disabled or broken services: $(euca-describe-services | grep -c 'DISABLED|BROKEN')"



echo Source API credentials
cd ~; rm -f ~/admin.zip; euca_conf --get-credentials admin.zip; unzip -o admin.zip
source ~/eucarc &>/dev/null
echo Modify Storage Controller Partition
euca-modify-property -p objectstorage.providerclient=walrus
euca-modify-property -p ${clustername}.storage.blockstoragemanager=overlay
euca_conf --deregister-service -T user-api -H ${IP} -N API_135
euca_conf --register-service -T user-api -H ${IP} -N API_135
cd ~; rm -f ~/admin.zip; euca_conf --get-credentials admin.zip; unzip -o admin.zip
source ~/eucarc &>/dev/null
euare-usercreatecert --user-name admin --out euca2-cert.pem --keyout euca2-pk.pem
echo "export EC2_PRIVATE_KEY=${EUCA_KEY_DIR}/euca2-pk.pem" >> ~/eucarc
echo "export EC2_CERT=${EUCA_KEY_DIR}/euca2-cert.pem" >> ~/eucarc
source ~/eucarc &>/dev/null

echo Setup admin account and security group
euare-useraddloginprofile --region localadmin@localhost --as-account eucalyptus -u admin -p password
euca-authorize -P tcp -p 22 default
euca-authorize -P tcp -p 80 default

echo Install and upload centos AMI
curl -L http://cloud.centos.org/centos/6.6/images/CentOS-6-x86_64-GenericCloud.qcow2.xz | xz -d > centos.qcow2
qemu-img convert -f qcow2 -O raw centos.qcow2 centos.raw && rm -f centos.qcow2
euca-install-image -b ami-bucket -r x86_64 -i centos.raw -n centos6.6 --virtualization-type hvm

echo Listing AMIs
euca-describe-images | grep ami-bucket

echo Install dependencies
yum install -y eucalyptus-load-balancer-image #eucalyptus-imaging-worker
echo Install Loadbalancer
euca-install-load-balancer --install-default
#echo Install imaging worker
#euca-install-imaging-worker --install-default
