[Unit]
Description=Alfresco backend for xchange
After=network.target
Requires=rabbitmq-server.service
Requires=idp-mock.service

[Service]
Type=forking
Environment=/home/mlefevre/DEVENV/alfresco-enterprise-3.4.7
WorkingDirectory=/home/mlefevre/DEVENV/alfresco-enterprise-3.4.7
ExecStart=/home/mlefevre/DEVENV/alfresco-enterprise-3.4.7/alfresco.sh start
ExecReload=/home/mlefevre/DEVENV/alfresco-enterprise-3.4.7/alfresco.sh restart
ExecStop=/home/mlefevre/DEVENV/alfresco-enterprise-3.4.7/alfresco.sh stop
User=mlefevre
ExecStopPost=/usr/bin/killall .soffice.bin
PIDFile=/home/mlefevre/DEVENV/alfresco-enterprise-3.4.7/tomcat/temp/catalina.pid

[Install]
WantedBy=multi-user.target
