#digital ocean install script

yum -y update
yum -y install nano
yum -y install epel-release wget
yum -y install nano
yum -y install git
yum -y install epel-release wget
yum -y install nano
wget -O /etc/yum.repos.d/scylla.repo http://downloads.scylladb.com/rpm/centos/scylla-1.2.repo
yum -y install epel-release wget
yum -y install scylla
/usr/lib/scylla/scylla_dev_mode_setup --developer-mode 1


systemctl start firewalld
systemctl enable firewalld
firewall-cmd --zone=public --add-service=ssh --permanent
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent

#allow all traffic from specific hosts
firewall-cmd --zone=public --add-rich-rule 'rule family="ipv4" source address=10.138.32.190 accept' --permanent
firewall-cmd --reload
systemctl stop firewalld
systemctl start firewalld

echo "10.138.32.190 db.sharksync">>/etc/hosts
echo "10.138.32.190 db.sharksync">>/etc/cloud/templates/hosts.redhat.tmpl

yum -y install nodejs
yum -y install npm 

rm -rf /shark
mkdir /shark

yum -y install ftp://ftp.pbone.net/mirror/centos.karan.org/el5/extras/testing/i386/RPMS/jed-0.99.18-5.el5.kb.i386.rpm
yum -y install git 

cd /shark
git clone https://sharkorm:TigerNias1@github.com/sharksync/sharktank.git
cd /shark/sharktank

curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

#
# exit, to reload npm
#
exit








