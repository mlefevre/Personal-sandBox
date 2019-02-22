SHELL = /bin/sh
USER = mlefevre

# Global install
full: vim git eclipse clone psql apiTools alfresco tomcat

# Install of Alfresco environments
alfresco: alfresco-bos alfresco-xchange

# Install various console utilities tools
consoleTools: vim git zsh

# install vi improved
vim:
	sudo apt install vim
# install git client
git:
	sudo apt install git
# install zsh as default command line interpret
zsh:
	sudo apt install zsh
	chsh -s /bin/zsh
# install maven
maven:
	wget http://apache.belnet.be/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
	sudo tar -zxf apache-maven-3.6.0-bin.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/apache-maven-3.6.0
	echo ============= WARNING : you may need to update your path to use mvn command ================

# install tomcat
tomcat:
	wget http://apache.cu.be/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
	tar -zxf apache-tomcat-8.5.37.tar.gz -C ~/DEVENV/
	mv ~/DEVENV/apache-tomcat-8.5.37/ ~/DEVENV/apache-tomcat/
	mkdir -p ~/DEVENV/apache-tomcat/shared/classes/
# install postgres
psql:
	sudo apt install postgresql
	wget https://jdbc.postgresql.org/download/postgresql-42.2.5.jre7.jar
	sudo cp configs/pg_hba.conf /etc/postgresql/10/main/
	sudo service postgresql restart
	# Require to provide password for alfresco DB user
	sudo -u postgres createuser -Sdr -P alfresco
	sudo -u postgres createdb -O alfresco alfresco
	wget https://kent.dl.sourceforge.net/project/squirrel-sql/1-stable/3.9.0/squirrel-sql-3.9.0-standard.jar
	sudo java -jar squirrel-sql-3.9.0-standard.jar
mysql:
	sudo apt install mysql-server
	sudo systemctl start mysql
	sudo systemctl enable mysql
	sudo mysql -e "CREATE USER alfresco@127.0.0.1 identified by 'alfresco';"
	sudo mysql -e "CREATE DATABASE alfresco ; GRANT ALL PRIVILEGES ON alfresco.* TO alfresco@localhost; FLUSH PRIVILEGES"
	# The password of root user must be set to 'root' : UPDATE mysql.user SET authentication_string=PASSWORD('root') WHERE user="root";
rabbitmq:
	sudo apt install rabbitmq-server
	sudo rabbitmq-plugins enable rabbitmq_management
	sudo rabbitmqctl add_user admin admin
	sudo rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
	sudo rabbitmqctl set_user_tags admin administrator
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
alfresco-bos:
	wget http://repo.irisnet.be/apps/com.alfresco/alfresco-enterprise-4.2.7-installer-linux-x64.bin
	sudo chmod 0755 alfresco-enterprise-4.2.7-installer-linux-x64.bin
	./alfresco-enterprise-4.2.7-installer-linux-x64.bin --optionfile configs/installOptions
	cp configs/alfresco-global.properties ~/DEVENV/alfresco-4.2.7/tomcat/shared/classes/
	sudo chmod 0644 ~/DEVENV/alfresco-4.2.7/tomcat/shared/classes/alfresco-global.properties
	rm ~/DEVENV/alfresco-4.2.7/tomcat/lib/postgresql*
	cp postgresql-42.2.5.jre7.jar ~/DEVENV/alfresco-4.2.7/tomcat/lib/
	# gestion license =TODO
	cp configs/setenv.sh ~/DEVENV/alfresco-4.2.7/tomcat/bin/
	sudo chmod 0774 ~/DEVENV/alfresco-4.2.7/tomcat/bin/setenv.sh
	sudo cp configs/service.sh /etc/systemd/system/bosecr-back.service
	sudo systemctl daemon-reload
	# time for a first start
	sudo systemctl start bosecr-back
	sleep 100
	sudo apt install wkhtmltopdf
	cp configs/openoffice-document-formats.xml ~/DEVENV/alfresco-4.2.7/tomcat/webapps/alfresco/WEB-INF/classes/alfresco/mimetype/
	cp configs/html2pdf-transform-context.xml ~/DEVENV/alfresco-4.2.7/tomcat/shared/classes/alfresco/extension/
	rm -rf ~/DEVENV/alfresco-4.2.7/alf_data/solr/
	rm -rf ~/DEVENV/alfresco-4.2.7/tomcat/webapps/solr/
	rm ~/DEVENV/alfresco-4.2.7/tomcat/conf/Catalina/localhost/solr.xml
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/share-extras/javascript-console-0.5.1.zip
	unzip javascript-console-0.5.1.zip -d jsConsole
	cp jsConsole/4.0.x/javascript-console-repo-0.5.1.jar ~/DEVENV/alfresco-4.2.7/tomcat/webapps/alfresco/WEB-INF/lib/
	cp jsConsole/4.0.x/javascript-console-share-0.5.1.jar  ~/DEVENV/alfresco-4.2.7/tomcat/webapps/share/WEB-INF/lib/
	rm -rf jsConsole/
	cp configs/local-bric-bosecr.properties ~/DEVENV/alfresco-4.2.7/tomcat/shared/classes/
	cp configs/local-bric-bosecr-back.properties ~/DEVENV/alfresco-4.2.7/tomcat/shared/classes/
	cp configs/local-log4j.properties ~/DEVENV/alfresco-4.2.7/tomcat/shared/classes/alfresco/extension/

# install alfresco for BosXchange
alfresco-xchange:
	wget http://repo.irisnet.be/apps/com.alfresco/alfresco-enterprise-3.4.7.zip
	unzip -q alfresco-enterprise-3.4.7.zip -d ~/DEVENV/
	wget http://repo.irisnet.be/apps/com.alfresco/mysql-connector-java-5.1.18-bin.jar
	cp mysql-connector-java-5.1.18-bin.jar ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/lib/
	wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/share-extras/javascript-console-0.4.2.jar
	mkdir ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/lib
	mv javascript-console-0.4.2.jar ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/lib/
	mkdir ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco/extension/license
	cp configs/CIRB-ent34.lic ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco/extension/license/
	cp configs/setenv.sh ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/bin/
	sed -i -e 's/alfresco-4.2.7/alfresco-enterprise-3.4.7/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/bin/setenv.sh
	sed -i -e 's/jmxremote.port=18500/jmxremote.port=18501/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/bin/setenv.sh
	sed -i -e 's/address=8888/address=8889/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/bin/setenv.sh
	cp configs/alfresco-global.properties ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/
	sed -i -e 's/alfresco-4.2.7/alfresco-enterprise-3.4.7/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -e 's/port=8080/port=8082/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.driver=).*/\1com.mysql.jdbc.Driver/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.username=).*/\1alfresco/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.password=).*/\1alfresco/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.name=).*/\1alfresco/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -E 's/(^db.url=).*/\1jdbc:mysql:\/\/localhost:3306\/alfresco/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/shared/classes/alfresco-global.properties
	sed -i -e 's/8080/8082/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/conf/server.xml
	sed -i -e 's/8005/8007/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/conf/server.xml
	sed -i -e 's/8443/8444/g' ~/DEVENV/alfresco-enterprise-3.4.7/tomcat/conf/server.xml
	rgrep -l /data/alfresco ~/DEVENV/alfresco-enterprise-3.4.7/ | xargs sed -i 's/\/data\/alfresco/\/home\/mlefevre\/DEVENV/g'
	sudo cp configs/serviceTxchback.sh /etc/systemd/system/txchback.service
	sudo systemctl daemon-reload

# Remove unnecessary file after installation
clean:
	rm eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz
	rm apache-maven-3.6.0-bin.tar.gz
	rm SoapUI-5.4.0-linux-bin.tar.gz
	rm lombok.jar
	rm squirrel-sql-3.9.0-standard.jar
