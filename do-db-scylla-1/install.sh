#digital ocean scylla server 1 install script
sudo su

cd ~

NODE_ID='do-db-scylla-1'

mkfs.xfs /dev/sda
mkdir /scylla
chmod 777 /scylla 
mount /dev/sda /scylla
mount | grep /dev/sda
chmod 777 /scylla
mkdir /scylla/data
mkdir /scylla/commitlog

echo "/dev/sda                /shark         xfs	 defaults 0	 0">>/etc/fstab

yum -y remove -y abrt
yum -y update
yum -y install epel-release wget
yum -y install nano
wget -O /etc/yum.repos.d/scylla.repo http://downloads.scylladb.com/rpm/centos/scylla-1.2.repo
yum -y install epel-release wget
yum -y install scylla
/usr/lib/scylla/scylla_dev_mode_setup --developer-mode 1

find /scylla -type d -exec chmod 777 {} \;
find /scylla -type f -exec chmod 777 {} \;

yum -y install ftp://ftp.pbone.net/mirror/centos.karan.org/el5/extras/testing/i386/RPMS/jed-0.99.18-5.el5.kb.i386.rpm

#configure the cassandra service
rm -rf /etc/scylla/scylla.yaml
cp /provisioning/$NODE_ID/scylla.yaml /etc/scylla/scylla.yaml

echo "10.138.32.190 db.sharksync">>/etc/hosts
echo "10.138.32.190 db.sharksync">>/etc/cloud/templates/hosts.redhat.tmpl

#setup access to relevant servers
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-service=ssh --permanent
sudo firewall-cmd --reload
sudo firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address=10.138.32.190 accept' --permanent
sudo firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address=10.138.32.163 accept' --permanent
sudo systemctl stop firewalld
sudo systemctl start firewalld

#configure scylla to automatically start
sudo systemctl start scylla-server
sudo systemctl enable scylla-server
sudo systemctl start scylla-jmx
sudo systemctl enable scylla-jmx
