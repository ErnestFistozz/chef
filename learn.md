firewall-cmd --permanent --zone public --add-service http -- open port 80 to run through the firewall
firewall-cmd --permanent --zone public --add-service https -- open port 443 to run through the firewall

firewall-cmd --reload


### Installing rpm files

rpm -ivh FILE_NAME*.rpm
