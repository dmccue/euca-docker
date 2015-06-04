IP=$(hostname -I | cut -d ' ' -f2)

echo SSH setup
mkdir -p ~/.ssh; chmod 700 ~/.ssh 
[ ! -f "~/.ssh/id_rsa" ] && ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''
grep -f ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys || cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H ${IP} >> ~/.ssh/known_hosts

echo Register API
euca_conf --register-service -T user-api -H ${IP} -N API_135
echo Register Walrus
euca_conf --register-walrusbackend --partition walrus --host ${IP} --component walrus-$(hostname -s)
echo Register Cloud Controller
euca_conf --register-cluster --partition cluster01 --host ${IP} --component cc-$(hostname -s)
echo Register Storage Controller
euca_conf --register-sc --partition cluster01 --host ${IP} --component sc-$(hostname -s)
echo Register Network Controller 
euca_conf --register-nodes ${IP}
# Skip arbitrators

#yum install -y eucalyptus-load-balancer-image eucalyptus-imaging-worker
cd ~; rm -f ~/admin.zip; euca_conf --get-credentials admin.zip; unzip -o admin.zip
source ~/eucarc &>/dev/null
echo Modify Storage Controller Partition
euca-modify-property -p cluster01.storage.blockstoragemanager=overlay
euca-describe-services | grep -c 'DISABLED|BROKEN'
#euca-install-imaging-worker --install-default
#euca-install-load-balancer --install-default
euare-useraddloginprofile --region localadmin@localhost --as-account eucalyptus -u admin -p password
euca-authorize -P tcp -p 22 default
euca-authorize -P tcp -p 80 default