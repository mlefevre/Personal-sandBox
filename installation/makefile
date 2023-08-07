SHELL = /bin/sh
USER = mlefevre
HOME_FOLDER = /home/$(USER)
ENV_FOLDER = $(HOME_FOLDER)/DEVENV

# Global install
full: vim git eclipse clone psql apiTools alfresco tomcat7

# Install of Alfresco environments
alfresco: alfresco-bos alfresco-xchange

# Install various console utilities tools
consoleTools: vim git zsh gdebi

# install CIRB intern certificate
certif:
	wget http://repo.irisnet.be/certs/CIRB_CIBG_ROOT_PKI.crt
	sudo mv CIRB_CIBG_ROOT_PKI.crt /usr/local/share/ca-certificates/
	sudo update-ca-certificates
	# add certificate in cacerts of the installed jre (must be done for each jre)
	keytool -importcert -alias cirbsslinspection -keystore /opt/jdk1.8.0_202/jre/lib/security/cacerts -storepass changeit -file /usr/local/share/ca-certificates/CIRB_CIBG_ROOT_PKI.crt
# install vi improved
vim:
	sudo apt install vim
gdebi:
	sudo apt install gdebi
# install git client
git:
	sudo apt install git
# install zsh as default command line interpret
zsh:
	sudo apt install zsh
	chsh -s /bin/zsh
cicd-tools:
	# install nix
	bash <(curl https://nixos.org/nix/install)
	echo 'if [ -e $(HOME)/.nix-profile/etc/profile.d/nix.sh ]; then . $(HOME)/.nix-profile/etc/profile.d/nix.sh; fi' >> ~/.bashrc # use .bashrc or .bash_profile or .profile depending of your shell installation
	source ~/.bashrc
	nix-env -iA cachix -f https://github.com/NixOS/nixpkgs/tarball/1d4de0d552ae9aa66a5b8dee5fb0650a4372d148
	sudo mkdir /etc/nix
	cachix use cicd-shell
	nix-env -i -f https://github.com/CIRB/cicd-shell/tarball/v2.5.11
	curl -o ~/.config/cicd/shell.dhall https://raw.githubusercontent.com/CIRB/devbox/master/config/shell.dhall
	sudo su -c "echo LOGINID=$(USER) >> /etc/environment"
	mkdir -p ~/.config/nixpkgs ; cd ~/.config/nixpkgs/ ; git clone ssh://git@stash.cirb.lan:7999/devb/nixpkgs-config.git ; mv nixpkgs-config/* . ; rm -rf nixpkgs-config
# install maven
maven:
	wget https://downloads.apache.org/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz
	sudo tar -zxf apache-maven-3.8.1-bin.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/apache-maven-3.8.1
	echo ============= WARNING : you may need to update your path to use mvn command ================

# install ant (old version compatible with jdk < 1.8)
ant:
	wget https://apache.cu.be//ant/binaries/apache-ant-1.9.14-bin.tar.gz
	sudo tar -zxf apache-ant-1.9.14-bin.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/apache-ant-1.9.14

wkhtmltopdf:
	wget http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
	sudo dpkg -i libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
	wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
	sudo dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb

# install tomcat
tomcat8:
	wget http://apache.cu.be/tomcat/tomcat-8/v8.5.45/bin/apache-tomcat-8.5.45.tar.gz
	tar -zxf apache-tomcat-8.5.45.tar.gz -C $(ENV_FOLDER)/
	mv $(ENV_FOLDER)/apache-tomcat-8.5.45/ $(ENV_FOLDER)/apache-tomcat/
	mkdir -p $(ENV_FOLDER)/apache-tomcat/shared/classes/
	# add shared/classes to the classpath
	sed -i -E 's/(^common.loader=.*)/\1,\"${catalina.home}\/shared\/classes\"/g' $(ENV_FOLDER)/apache-tomcat/conf/catalina.properties
tomcat7:
	wget https://apache.cu.be/tomcat/tomcat-7/v7.0.93/bin/apache-tomcat-7.0.93.tar.gz
	tar -xzf apache-tomcat-7.0.93.tar.gz -C $(ENV_FOLDER)
	mkdir -p $(ENV_FOLDER)/apache-tomcat-7.0.93/shared/classes/
# install postgres
psql:
	sudo apt install postgresql
	wget https://jdbc.postgresql.org/download/postgresql-42.2.5.jre7.jar
	sudo cp configs/pg_hba.conf /etc/postgresql/10/main/
	sudo service postgresql restart
	# Require to provide password for alfresco DB user
	sudo -u postgres createuser -Sdr -P alfresco
	sudo -u postgres createdb -O alfresco alfresco
	sudo -u postgres createuser -Sdr -P bos_front
	sudo -u postgres createdb -O bos_front PGBOS_FRONT
	wget https://kent.dl.sourceforge.net/project/squirrel-sql/1-stable/3.9.0/squirrel-sql-3.9.0-standard.jar
	sudo java -jar squirrel-sql-3.9.0-standard.jar
mysql:
	#cannot install last mysql version: doesn't work with java 6 (driver not compatible).
	# must install mysql 5.7 which is not available in Ubuntu >=20.04
	wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb	# add mysql repo
	sudo dpkg -i mysql-apt-config_0.8.12-1_all.deb
	sudo apt update # may provoke an error with NO PUBKEY message and a key id
	# sudo apt-key list	# to check the available key, see if a key is outdated for mysql
	# add the missing key from ubuntu key server and its id (provided in error message)
	# sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
	# sudo apt-key list	# check the result
	# sudo apt-key del 'A4A9 4068 76FC BD3C 4567  70C8 8C71 8D3B 5072 E1F5' #	if needed, remove the outdated key
	# sudo apt update
	sudo apt-cache policy mysql-server	# check available mysql versions
	sudo apt install -f mysql-client=5.7.42-1ubuntu18.04
	sudo apt install -f mysql-server=5.7.42-1ubuntu18.04
	sudo systemctl start mysql
	sudo systemctl enable mysql
	sudo mysql -e "CREATE USER 'alfresco'@'localhost' identified by 'alfresco';"
	sudo mysql -e "CREATE USER 'txch'@'localhost' identified by 'txch';"
	sudo mysql -e "CREATE DATABASE alfresco ; GRANT ALL PRIVILEGES ON alfresco.* TO alfresco@localhost; FLUSH PRIVILEGES"
	sudo mysql -e "CREATE DATABASE txch ; GRANT ALL PRIVILEGES ON txch.* TO txch@localhost; FLUSH PRIVILEGES"
	# The password of root user must be set to 'root' : sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'";
rabbitmq:
	sudo apt install rabbitmq-server
	sudo rabbitmq-plugins enable rabbitmq_management
	sudo rabbitmqctl add_user admin admin
	sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
	sudo rabbitmqctl set_user_tags admin administrator

# install idp mock
idp-mock:
	wget http://nexus.cirb.lan/repository/maven-releases/brussels/bric/iam/mujina-idp/1.0.2/mujina-idp-1.0.2-assembly.zip
	unzip -q mujina-idp-1.0.2-assembly.zip -d $(ENV_FOLDER)/
	sudo chmod 0744 $(ENV_FOLDER)/idp-1.0.2/*
	sudo cp configs/idp-mock /etc/init.d/
	sudo chmod 0755 /etc/init.d/idp-mock
	sudo sed -i -E 's/(^USER=).*/\1$(USER)/g' /etc/init.d/idp-mock
	# set java 7 to be used as jre
	sudo sed -i -E 's/(^JAVA_PATH=).*/\1\/opt\/jdk1.7.0_80\/bin/g' /etc/init.d/idp-mock
	sudo sed -i -E 's/(^APPLICATION_ROOT=).*/\1\/home\/mlefevre\/DEVENV\/idp-1.0.2/g' /etc/init.d/idp-mock
	# get the config of the DEV environment
	scp $(USER)@dev-txchweb:/srv/idp-mock/config/default.json $(ENV_FOLDER)/idp-1.0.2/config/

	echo "You must edit idp-1.0.2/config/server.xml"

# install eclipse
eclipse:
	wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/oxygen/3a/eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz
	sudo tar -zxf eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/eclipse/
	sudo ln -s /opt/eclipse/eclipse /usr/bin/eclipse
	wget https://projectlombok.org/downloads/lombok.jar
	java -jar lombok.jar
# install test api tools : soapUI and rest client
apiTools:
	wget https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-5.4.0-linux-bin.tar.gz
	sudo tar -zxf SoapUI-5.4.0-linux-bin.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/SoapUI-5.4.0/
	wget https://github.com/wiztools/rest-client/releases/download/3.7.1/restclient-ui-fat-3.7.1.jar
	# soapUI must run with a java 8
	sed -i -E 's/^java/\/opt\/jdk1.8.0_202\/bin\/java/g' /opt/SoapUI-5.4.0/bin/soapui.sh
# install onedrive (not working with business account)
onedrive: 
	git clone https://github.com/xybu92/onedrive-d.git
	cd onedrive-d ; ./install.sh
	mkdir ~/onedrive
	onedrive-pref
# clone dev projects
clone:
	mkdir -p ~/DEV/BOS/ ; cd ~/DEV/BOS/ ; git clone ssh://git@stash.cirb.lan:7999/bos/bosecr-back.git; git clone ssh://git@stash.cirb.lan:7999/bos/bosecr-common.git	; git clone ssh://git@stash.cirb.lan:7999/bos/bosecr-front.git ; git clone ssh://git@stash.cirb.lan:7999/bos/bosecr-rollout.git
	mkdir -p ~/DEV/devops ; cd ~/DEV/devops ; git clone ssh://git@stash.cirb.lan:7999/bos/puppet-stack-bos.git ; git clone ssh://git@stash.cirb.lan:7999/bos/salt-stack-bos.git ; git clone ssh://git@stash.cirb.lan:7999/txchan/rpm-build-bosxchange-kgs.git ; git clone ssh://git@stash.cirb.lan:7999/txchan/puppet-stack-bosxchange.git ; git clone ssh://git@stash.cirb.lan:7999/bos/rpm-build-bos-kgs.git
	cd ~/DEV/devops/puppet-stack-bos/ ; git submodule sync ; cd hieradata/ ; git submodule update --init ; git checkout master ; git pull
	cd ~/DEV/devops/puppet-stack-bos/modules ; git submodule update --init ; git checkout master ; git pull 
	cd ~/DEV/devops/puppet-stack-bosxchange ; git submodule sync ; cd hieradata/ ; git submodule update --init ; git checkout master ; git pull
	cd ~/DEV/devops/puppet-stack-bosxchange/modules ; git submodule update --init ; git checkout master ; git pull
	mkdir -p ~/DEV/bosXchange/ ; cd ~/DEV/bosXchange ; git clone ssh://git@stash.cirb.lan:7999/txchan/txchbackend.git ; git clone ssh://git@stash.cirb.lan:7999/txchan/txchin.git ; git clone ssh://git@stash.cirb.lan:7999/txchan/txchout.git ; git clone ssh://git@stash.cirb.lan:7999/txchan/txchweb.git

# install alfresco for BOS
alfresco-bos: wkhtmltopdf
	wget http://repo.irisnet.be/apps/com.alfresco/alfresco-enterprise-4.2.7-installer-linux-x64.bin
	sudo chmod 0755 alfresco-enterprise-4.2.7-installer-linux-x64.bin
	./alfresco-enterprise-4.2.7-installer-linux-x64.bin --optionfile configs/installOptions
	mkdir -p $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/
	cp configs/alfresco-global.properties $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/
	sudo chmod 0644 $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/alfresco-global.properties
	rm $(ENV_FOLDER)/alfresco-4.2.7/tomcat/lib/postgresql*
	cp postgresql-42.2.5.jre7.jar $(ENV_FOLDER)/alfresco-4.2.7/tomcat/lib/
	mkdir -p $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/alfresco/extension/license
	cp configs/Alfresco-ent42-CIRB.lic $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/alfresco/extension/license/
	cp configs/setenv.sh $(ENV_FOLDER)/alfresco-4.2.7/tomcat/bin/
	sudo chmod 0774 $(ENV_FOLDER)/alfresco-4.2.7/tomcat/bin/setenv.sh
	sudo cp configs/service.sh /etc/systemd/system/bosecr-back.service
	sudo systemctl daemon-reload
	# time for a first start
	sudo systemctl start bosecr-back
	sleep 100
	cp configs/openoffice-document-formats.xml $(ENV_FOLDER)/alfresco-4.2.7/tomcat/webapps/alfresco/WEB-INF/classes/alfresco/mimetype/
	cp configs/html2pdf-transform-context.xml $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/alfresco/extension/
	rm -rf $(ENV_FOLDER)/alfresco-4.2.7/alf_data/solr/
	rm -rf $(ENV_FOLDER)/alfresco-4.2.7/tomcat/webapps/solr/
	rm $(ENV_FOLDER)/alfresco-4.2.7/tomcat/conf/Catalina/localhost/solr.xml
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/share-extras/javascript-console-0.5.1.zip
	unzip javascript-console-0.5.1.zip -d jsConsole
	cp jsConsole/4.0.x/javascript-console-repo-0.5.1.jar $(ENV_FOLDER)/alfresco-4.2.7/tomcat/webapps/alfresco/WEB-INF/lib/
	cp jsConsole/4.0.x/javascript-console-share-0.5.1.jar  $(ENV_FOLDER)/alfresco-4.2.7/tomcat/webapps/share/WEB-INF/lib/
	rm -rf jsConsole/
	cp configs/local-bric-bosecr.properties $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/
	cp configs/local-bric-bosecr-back.properties $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/
	cp configs/local-log4j.properties $(ENV_FOLDER)/alfresco-4.2.7/tomcat/shared/classes/alfresco/extension/
	# NOTICE : you need now to deploy the project and set the reindex parameter to FULL in alfresco-global.properties 

# install alfresco for BosXchange
alfresco-xchange:
	wget http://repo.irisnet.be/apps/com.alfresco/alfresco-enterprise-3.4.7.zip
	unzip -q alfresco-enterprise-3.4.7.zip -d $(ENV_FOLDER)/
#	wget https://cdn.mysql.com/archives/mysql-connector-java-8.0/mysql-connector-j-8.0.33.tar.gz
#	tar -zxf mysql-connector-j-8.0.33.tar.gz
#	cp mysql-connector-j-8.0.33/mysql-connector-j-8.0.33.jar ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/lib/
	wget http://repo.irisnet.be/apps/com.alfresco/mysql-connector-java-5.1.18-bin.jar
	cp mysql-connector-java-5.1.18-bin.jar $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/lib/
	wget https://repo.irisnet.be/apps/com.alfresco/javascript-console-0.4.2.jar
	mkdir $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/lib
	mv javascript-console-0.4.2.jar $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/lib/
	mkdir $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco/extension/license
	cp configs/CIRB-ent34.lic $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco/extension/license/
	cp configs/setenv.sh $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/bin/
	sed -i -e 's/alfresco-4.2.7/alfresco-enterprise-3.4.7/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/bin/setenv.sh
	sed -i -e 's/jmxremote.port=18500/jmxremote.port=18501/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/bin/setenv.sh
	sed -i -e 's/address=8888/address=8889/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/bin/setenv.sh
	cp configs/alfresco-global.properties $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/
	sed -i -e 's/alfresco-4.2.7/alfresco-enterprise-3.4.7/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -e 's/port=8080/port=8082/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.driver=).*/\1com.mysql.jdbc.Driver/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.username=).*/\1alfresco/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.password=).*/\1alfresco/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.name=).*/\1alfresco/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.url=).*/\1jdbc:mysql:\/\/localhost:3306\/alfresco/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/8080/8082/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco/web-extension/share-config-custom.xml
	sed -i -e 's/8080/8082/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/conf/server.xml
	sed -i -e 's/8005/8007/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/conf/server.xml
	sed -i -e 's/8443/8444/g' $(ENV_FOLDER)/alfresco-enterprise-3.4.7/tomcat/conf/server.xml
	rgrep -l /data/alfresco $(ENV_FOLDER)/alfresco-enterprise-3.4.7/ | xargs sed -i 's/\/data\/alfresco/\/home\/mlefevre\/DEVENV/g'
	sudo cp configs/serviceTxchback.sh /etc/systemd/system/txchback.service
	sudo systemctl daemon-reload

#install eid software
eid:
	wget https://eid.belgium.be/sites/default/files/software/eid-archive_2019.1_all.deb
	sudo gdebi eid-archive_2019.1_all.deb
	sudo apt update
	sudo apt install eid-viewer
# Install the last available version of Docker community
docker:
	sudo apt-get update
	sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
	sudo apt-get update
	sudo apt-get install docker-ce docker-ce-cli containerd.io
	sudo usermod -aG docker $(USER)

# Remove unnecessary file after installation
clean:
	rm eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz
	rm apache-maven-3.6.0-bin.tar.gz
	rm SoapUI-5.4.0-linux-bin.tar.gz
	rm lombok.jar
	rm squirrel-sql-3.9.0-standard.jar
