## 1. Install chef-client on a node

a) download chef-client from chef website.

## 2. Create Chef directory

a) Linux / Unix Environment
	pre-requisite: chef_server_url
	i) Create /etc/chef/client.rb
	chef_server_url           "https://CHEF_SERVER.myorg.com/organizations/myorg"
	validation_client_name    "ORG_FULL_NAME-validator"
	validation_key            "/etc/chef/ORG_FULL_NAME-validator.pem"
	log_level                 :info

b) Windows
	pre-requisite: chef_server_url
	i) Create a directory C:\chef
	ii) Create C:\users\chef\client.rb or C:\chef\client.rb
	chef_server_url           "https://CHEF_SERVER.myorg.com/organizations/myorg"
	validation_client_name    "ORG_FULL_NAME-validator"
	validation_key            "C:\chef\ORG_FULL_NAME-validator.pem"
	log_level                 :info
	trusted_certs_dir 		  "C:\chef\trusted_certs"

	iii) Add the following to ENVIRONMENT VARIABLE
	C:\opscode\chef\bin
	C:\opscode\chef\embedded\bin

## 3. Copy Validation key
a) Linux

	The key you got after running `chef-server-ctl org-create`. If lost you can generate a new one from Chef Manage.

	Copy the key to /etc/chef/ORG_FULL_NAME-validator.pem (to what is configured as validation_key in client.rb)
b) Windows
	
	The key you got after running `chef-server-ctl org-create`. If lost you can generate a new one from Chef Manage.

	Copy the key to C:\users\chef\ORG_FULL_NAME-validator.pem otC:\chef\ORG_FULL_NAME-validator.pem (to what is configured as validation_key in client.rb)

## 4. Fetch SSL Cert
	a) Unix/Linux

	Optionally, if the SSL certificate on your Chef server isn't signed (it probably isn't), you must manually fetch it so that knife/chef-client will trust the certificate.
	i) create - mkdir /etc/chef/trusted_certs
	ii) knife ssl fetch -c /etc/chef/client.rb

	b)Windows

	Optionally, if the SSL certificate on your Chef server isn't signed (it probably isn't), you must manually fetch it so that knife/chef-client will trust the certificate.
	i) create - mkdir C:\chef\trusted_certs or C:\users\chef\trusted_certs
	ii) knife ssl fetch -c C:\chef\client.rb C:\users\chef\client.rb


## For More Information

https://serverfault.com/questions/761167/how-to-manually-set-up-a-chef-node
http://jtimberman.housepub.org/blog/2014/12/11/chef-12-fix-untrusted-self-sign-certs/