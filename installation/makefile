SHELL = /bin/sh
USER = mlefevre

# Global install
full: vim git eclipse clone psql soapui alfresco

# Install of Alfresco environments
alfresco: alfresco-bos alfresco-xchange

# install vi improved
vim:
	sudo apt install vim
# install git client
git:
	sudo apt install git
# install maven
maven:
	wget http://apache.belnet.be/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
	sudo tar -zxf apache-maven-3.6.0-bin.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/apache-maven-3.6.0
	echo ============= WARNING : you may need to update your path to use mvn command ================
# install postgres
psql:
	sudo apt install postgresql
	sudo apt install pgadmin3
	wget https://jdbc.postgresql.org/download/postgresql-42.2.5.jre7.jar
	sudo cp configs/pg_hba.conf /etc/postgresql/10/main/
	sudo service postgresql restart
	# Require to provide password for alfresco DB user
	sudo -u postgres createuser -Sdr -P alfresco
	sudo -u postgres createdb -O alfresco alfresco
# install eclipse
eclipse:
	wget http://ftp.fau.de/eclipse/technology/epp/downloads/release/oxygen/3a/eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz
	sudo tar -zxf eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/eclipse/
	sudo ln -s /opt/eclipse/eclipse /usr/bin/eclipse
# install soapui
soapui:
	wget https://s3.amazonaws.com/downloads.eviware/soapuios/5.4.0/SoapUI-5.4.0-linux-bin.tar.gz
	sudo tar -zxf SoapUI-5.4.0-linux-bin.tar.gz -C /opt
	sudo chown $(USER):$(USER) -R /opt/SoapUI-5.4.0/
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
# Remove unnecessary file after installation
clean:
	rm eclipse-jee-oxygen-3a-linux-gtk-x86_64.tar.gz
	rm apache-maven-3.6.0-bin.tar.gz
	rm SoapUI-5.4.0-linux-bin.tar.gz
