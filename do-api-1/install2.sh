yum -y install npm 
nvm install 5
npm install hapi
npm install good
npm install calibrate
npm install joi
npm install async
npm install boom
npm install moment
npm install cassandra-driver
npm install good-squeeze
npm install good-console

cp /provisioning/$NODE_ID/sharksync /etc/init.d/sharksync
chmod +x /etc/init.d/sharksync
chkconfig --add sharksync
