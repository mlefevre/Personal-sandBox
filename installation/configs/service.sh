[Unit]
Description=Alfresco ECM repository
After=network.target

[Service]
Type=forking
Environment=/home/mlefevre/DEVENV/alfresco-4.2.7
ExecStart=/home/mlefevre/DEVENV/alfresco-4.2.7/alfresco.sh start
ExecReload=/home/mlefevre/DEVENV/alfresco-4.2.7/alfresco.sh restart
ExecStop=/home/mlefevre/DEVENV/alfresco-4.2.7/alfresco.sh stop
User=mlefevre
ExecStopPost=/usr/bin/killall .soffice.bin
PIDFile=/home/mlefevre/DEVENV/alfresco-4.2.7/tomcat/temp/catalina.pid

[Install]
WantedBy=multi-user.target
