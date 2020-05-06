#!/bin/sh

find /ds/data/tomcat/logs/isilon-logs/catalina* -type f -mtime +3 -exec rm {} \;
find /ds/data/tomcat/logs/isilon-logs/localhost* -type f -mtime +3 -exec rm {} \;
find /ds/data/tomcat/logs/isilon-logs/manager* -type f -mtime +3 -exec rm {} \;

find /ds/data/httpd/logs -maxdepth 1 -mtime +1 -type f -exec mv "{}" /ds/data/httpd/logs/isilon-logs/ \;
find /ds/data/tomcat/logs -maxdepth 1 -mtime +1 -type f -exec mv "{}" /ds/data/tomcat/logs/isilon-logs/ \;
find /ds/data/dspace/log -maxdepth 1 -mtime +1 -type f -exec mv "{}" /ds/data/dspace/log/isilon-log/ \;
