'bootstrap a windows machine'

##Linux Environment
knife bootstrap [ipaddress] -U [username] -P [password] -N [servername] 
--bootstrap-install-command "sudo curl -s http://dump.dfl.nednet.co.za/oldies/archives/scripts/bootstrap.sh | sudo bash"

##Windows Environment
knife bootstrap  -o winrm [ipaddress] -U [username] -P [password] -N [servername] 
--bootstrap-install-command "curl -s http://dump.dfl.nednet.co.za/oldies/archives/scripts/bootstrap.ps1 | powershell -Command Start-Process PowerShell -Verb RunAs or powershell or cmd"


knife bootstrap  -o winrm [ipaddress] -U [username] -P [password] -N [servername] 
--bootstrap-install-command "curl -s http://dump.dfl.nednet.co.za/oldies/archives/scripts/bootstrap.ps1 | runas /noprofile /user:Administrator cmd or Start-Process -Verb RunAs cmd.exe "

#Ohai
'is a tool that captures details/attributes about a node'

#Node Object
'The Node Object is representation of our system / server/ VM'
'The node object is stores all the attributes of our system/node'

## Some of the Attributes maintained by OHAI

a) Ipaddress = node['ipaddress']
b) Hostname = node['hostname']
c) Memory = node['memory']['total']

'String Interpolation is only possible with double quotes'

Semantic Versions
Given Major.Minor.Patch
'Major' --  Version when you make incompatible API changes
'Minor' -- Version when you add functionality in a backwards-compatible manner•
'Patch' -- Version when you make backwards-compatible bug fixes

'Cookbooks use semantic version. The version number helps represent the state or feature set of the cookbook.
Semantic versioning allows us three fields to describe our changes: major; minor; and patch'

'file resource' ---> to manage files directly on a node
'remote_file resource' ---> to transfer a file from a remote location using file specificity
'cookbook_file resource' ---> to transfer files from a sub-directory of COOKBOOK_NAME/files/ to a 
					specified path located on a host that is running the chef-cliet

‎					i.e allows us to store a file within our cookbook and then have that file transferred to a specified file path on the system.

'template' ---> cookbook template is an Embedded Ruby (ERB) template that is used to generate files.
				Templates may contain Ruby expressions and statements and are a great way to
				Use the template resource to add cookbook templates to recipes.

				A template can be placed in a particular directory within the cookbook and it will be delivered to a specified file path on the system.
				'difference between #{Templates} and #{Cookbook file}'
				The biggest difference is that it says templates can contain ruby expressions and statements. This sounds like what we wanted: 
				A native file format with the ability to insert information about our node.

'Embedded Ruby (ERB)' ---> An Embedded Ruby (ERB) template allows Ruby code to be embedded inside a text file within specially formatted tags. 
						   Ruby code can be embedded using expressions and statements.

				ERB template files are special files because they are the native file format we want to deploy but we are allowed to 
				include special tags to execute ruby code to insert values or logically build the contents

NB: in order to put RUBY CODE or EXPRESSIONS ---> '<%  some_random _ruby_code %>'
	To Output the ruby result the expression must be stored as '<%= ' --> Angry Squid

String interpolation only works in ruby files
	
				<%= node['ipaddress'] %>
				<%= node['hostname'] %>


'Checking the client'
knife client list

ORGNAME-validator ---> should be returned
	'This is a special key that has access to the Chef Server.'

have a .chef directory, within the chef repository, which contains the knife configuration file (knife.rb),
 'personal key', and 'organizational key'

#Upload a cookbook to chef server
'To upload a cookbook to the Chef Server you need to be within the directory of the cookbook.'

#Berkshelf
'Berkshelf' ---> is a cookbook management tool that allows us to upload your cookbooks and all of its dependencies to the Chef Server.

Berksfile.lock ---> is a receipt of all the cookbooks and dependencies found at the exact moment that you ran 'berks install'

A node can only join one organization

To be a node means that it has Chef installed, has configuration files in place, and when you run the chef-client
application with no parameters it will successfullycontact the Chef Server and ask it for the run list that it 
should apply and the cookbooks required to execute that run list

BOOTSTRAPPING A NODE
'knife bootstrap IP_Address -U Username -P Password --SUDO -N NODE_NAME' ---> Applies to a Unix based machine/node
'knife bootstrap -o winrm IPADDRESS -x Administrator -P super_secret_password -N NODE_NAME' ---> for bootstraping a windows machine/node

Note:: WinRM HTTP port to attempt to connect to the remote WinRM endpoint - 5985

Adding a cookbook to a runlist

'knife node run_list add NODE_NAME COOKBOOK_NAME'
#Example
knife node run_list add xdvmamba1 learn_chef_httpd
		#OR
knife node run_list add xdvmamba1 "recipe[COOKBOOK_NAME::RECIPE_NAME]"

Removing a cookbook to a run_list

'knife node run_list removed NODE_NAME "recipe[COOKBOOK_NAME::RECIPE_NAME]" '


#Attributes
'Attributes defined in a cookbook are not considered automatic. They are simply default values that we may change.'

#Wrapper Cookbook
'wrapper cookbook is a new cookbook that encapsulates the functionality of the original cookbook.'
It defines new default values for the recipes.

'This is a common method for overriding cookbooks because it allows us to leave the original cookbook untouched. 
We simply provide new default values that we want and then include the recipes that we want to run.'

#Naming Cookbooks and Wrapper Cookbooks
Traditionally we would name the cookbook with a prefix of the name of our company and then follow it by the cookbook name 'company-cookbook'.
Example: Nedbank-IIS Or Nedbank-Wrapper-Haproxy or Nedbank-Postilion-Patch

#For a cookbook to be a a wrapper cookbook it has to include another cookbook as a dependency and override its 
#Attributes while preserving its functionality
depends 'COOKBOOK_NAME', '~> VERSION' --> version must correspond with a version with exist

#The default of the wrapper cookbook has to include the recipes required to be run
#Typically includes the default cookbook

include_recipe 'COOKBOOK_NAME::RECIPE_NAME'
#Example 
include_recipe 'COOKBOOK_NAME::default'

#To override values in the original cookbook, new defaults need to be put in the default recipe of the 
# wrapper cookbook, before including the recipe

'
	node['COOKBOOK_NAME']['ATTRIBUTE_NAME'] = NEW_VALUES #--->Overriding values
	include_recipe 'COOKBOOK_NAME::default'

'

To have the dependency cookbook included

Inside the cookbook execute/run 'berks install' ---> Ensure  Berksfile is there
upload cookbook to the chef server 'berks upload' ---> Ensure Berksfile is there

#Running commands againts multiple commands

knife ssh ---> 'ssh that allows us to execute a command across multiple nodes that match a specified search query.'

#Run commands accross all nodes that are part of organisation
knife ssh " *:* " -U Username -P Password "sudo chef-client"

knife node run_list add NODE_NAME "recipe[COOKBOOK_NAME::RECIPE_NAME]"

#ROLES

'role' ---> describes a run list of recipes that are executed on the node. A role may also define new defaults 
			or overrides for existing cookbook attribute values.
			When you assign a role to a node you do so in its run list. This allows you to configure many nodes in a similar fashion.

# Defining a ROLE
This is a ruby file that contains specific methods that allow you to express details about the role. 
Youll see that the role has a name, a description, and run list.

The name of the role as a practice will share the name of the ruby file unless it cannot for some reason. 
The name of the role should clearly describe what it attempts accomplish.


The run list defines the list of recipes that give the role its purpose. 
Example ---> Currently the load_balancer role defines a single recipe - the myhaproxy cookbook~s default recipe.

#UPLOADING ROLE TO CHEF SERVER

knife role from file ROLE_FILE_NAME

'To show role details'

knife role show ROLE_NAME

#setting a role to a node

knife node run_list set NODE_NAME "role[ROLE_NAME]"

#The above command replaces the existing runlist

This is a command that allows us to set the run list to a value provided.
This will replace the existing run list with a new one that we provide.

'For a node existing in the cloud, the actual EXTERNAL IPADDRESS of a node are stored in a variable called::cloud'
knife node show NODE_NAME -a cloud

'To replace a default attribute in a recipe'
you use:
		node.default['COOKBOOK_NAME']['ATTRIBUTE_NAME'] instead of node['COOKBOOK_NAME']['ATTRIBUTE_NAME']

#NOT chef related
runas /user:admin username powershell


#Creating a USER
chef-server-ctl user-create USER_NAME FIRST_NAME LAST_NAME EMAIL 'PASSWORD' -f PATH_FILE_NAME

#Creating an organization
chef-server-ctl org-create short_name 'full_organization_name' --association_user user_name --filename ORGANIZATION-validator.pem

'After installing chef server --> reconfigure the chef-server so all components can work together'
chef-server-ctl reconfigure

'Check status of reconfiguration'
chef-server-ctl status

#DELETING A NODE FROM A CHEF-SERVER
'Two steps involved in deleting a client node'
a) deleting the 'node object'
		knife node delete NODE_NAME
b) deleting the 'client object'
		knife client delete NODE_NAME
'Bootstrapping a node not only installs Chef on that node but also creates a client object on the Chef Server as well.
The client object is used by the Chef Client to authenticate against the Chef Server on each run.
Additionally to registering a client, a node object is created. The node object is the main data structure,
which is used by the Chef Client to converge the node to the desired state.'

#knife-playground plugin can delete both client and node object at one go
	knife pg clientnode delete NODE_NAME

#RUNNING CHEF CLIENT LOCALLY WITH COOKBOOK IN RUN_LIST
	chef-client -z -o COOKBOOK_NAME

# Book
Chef: Powerful Infrastructure Automation























5284 9730 3715 7736
03/26
CCV 326

ssh -i temp.key ec2-user@172.18.161.11

temp.key

-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAv+H9kfPaaUA0yrQI8NZCfb6w/m/8AW5k5wnj8QZyf5cmuFKV/Uj7MSKGJjVG
vw++joGI8EMwUy5b2nDYMUM0+fqXPSIEtAKRbNoHjlSIPpGjsebCEGACncDOpZ11NdlJyoLK2XOb
mfNde9gYGBCnX2fcZKyV3/+YMHEv9sSmU4QXBddhGE2mxS3IQkux2KIVGSb4yQX90jVGr4ngA8fX
JodX7rmWX/Jpol6GdHRTdS2WJmrUUr6N4+2dzZOB04tAv45YQIM0AoiU4gNZ3Y2CzJGqFa1o4cie
dZR00RLZO6eieWt/vSUulFhDN1MJSBdn7XwC4nzLZ3Owr4cCEoZsPQIDAQABAoIBAQCyAfb49Z5D
UfsnqUk6E6rveH4+LKk+sqkM5NH/gZmq4BBdos/ef1v4wyxsObR9/x8qmOTu74XfRPyVc2Y8nTqC
RYUUg4CVdmRu9P1ZfvY+BWI04fxasJb8vid24NIhuIiKRDfm7ycE9Q5em6QOfzSmf3WoN6t6eGU5
W2fBp8Eda6pTvUQZtZbXmxdl2gRvxDvGF5SbR6loEZWJkt+BOyE8iv7tYF0e7a2hmT5Cdoo5KH2W
CBwRghaotx7FhO/2vGojLwDIz94EVY5ggoT5qF05V9Q8pcJ7/FJwaui6VgATKGj1MgIkoMsizrOi
7OVUobO/NP9ttpC0GkxVtIusP3nBAoGBAPBiAQP1nCqHvq9Pu9H5N4QtfJ9MYU2Ylcpq7x0fCE8+
Q60UiZCgTpvk7FcuCcT5F+UMfvZm3a4QMh1N0O2LNdItaiv0MUfNenqB/6OO0C0H9MKJjpkv/5ys
fy/2dQgQ373BncbotwNVhIEEVkBTNqUNpCcSUo4Gk8yzo2SncinpAoGBAMxZWA+20T+NBAy5ZF5j
I8/ghtegWT9Jq3zLLPfHcHPf0z6v6l4XYNoL8ARLOLDlQXZ2Gj4i/s+7BEonTbxG3eeAuse9Y/Uq
rGMpC3HxRicU1qa8GuhPo72lOCmBMhtFGpckcW94C17yFZPs78O4cTGgvTGsjRzi2FwsUyzFb2c1
AoGBAMnzXC0KZFfq0U2RrBaczIJUgLWIQtshDP8Q1bBeiOmiQtMfRO9nboNUUSZw/C4qo2OAGw5B
n44D90ZdQODAqsfX9bHVpq1POM3Bd5befZDHdV8Wl+GkzJfA593QrcPIAWD3T+lzS4YWi4qkrR2/
i1IhYr6cixTc+8DnTqdacfQ5AoGASyRzaFveeBL/sToe+UJVceRrUTEKgGYzpBEGORridAmTIVMI
yI6qM6P+H2YVs56pwsjM/5pYvsRTYH0xbZFVmgJRLI+tCQMnHtOB/OUu2cIk6Gz1LAXU/TCbBVAX
v8VacMea2tV2wPQeESYoSH0zSn+D8pcz0LJtwv8dmrIDNB0CgYEAotjZZTFWA3TOi+2p25eqkjyF
pYly/ZLX7qO+Swu3JZbUnqUKM1TPji8bfFyV+niv0L2+BUykZRvz8B/bpaczk6H59+g/VO/cg795
T7odLeNpkTb3irCz0cJB5Yfc7ij1LDACwfaZTjAPMJ5HTGrauKM7+YY9Y2jqlPq2WPLhFOA=
-----END RSA PRIVATE KEY-----




Work.key
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAk6bmG9I7PXQMb6O+BUp8QvJ+MvAnTca8RHT/j7oWE2grgtTimHDNFaIptIB9
E1tvN0F5YAhEWD9FoDswhYPdav8PbePCp8EOoyCRgyO7RaICv2tt+gMPamjn1RY8fnQy+4y4b+7O
sM5/eeeMsVz/WU/vYzEyj+mgvOmJEpc2+DbQeIWXfD+1gyZyctvjNcb9VyHftcsKW1CjoalNsozN
L2Ht6JUMJg/ySMqdYNkaDQB68ljJh4gyA6MW6qv7sxQUZOip3KYluw0fdzPyP/NDyUhTp/i2M9Bg
h0lY8EBGqPbS649Jr/NtHR5gvcCzr2LVw3BpGz917x6DPtglDw3cIQIDAQABAoIBAQCKbjvncZ9g
6mCOerI5O7BtA/UVxNrUrLLua9L+6bSw1UWWEAmyam+dDMCVHrIlZ+BJqfUl+Bo7snaQ122SgCMj
oabRnGxv4yzZ/Drw/JsjmdWBqjMd56iYV2qj+YkV9dOmzDRPnVHjqncRz+m0kEBHeA40rXd+PcgZ
1cpRx7wd0blaIShMMt9wFKwrK5yGNlYa3bq6Cqexllq4Zw+473IF4I6SUaGS+uXK+LwSPeYGFciA
lu5LtNgCcIb8gQXToa4RdZelo7r5HYHX+lm0glVYM93s4HYuuK3SS3DLlIhhePzL7uW5mrXkZMU6
qJqLUkJ+5N5ElxhwblYaCbQy1aMBAoGBAM2QTvhqbiKMHPMmGinhnfcWZuTohK47VVHUxwaIUnW/
I/wn4xRoyY1WLB75PfClLroqhCsfvNdvzuFGKDEMKXtK7kZafxMB0m0vsWof/w4tkpHMR/Avd73h
c16yubmjOBB4+eaF4JeovUCoY4QMu55o5qAUMBdDBKcb3hyrDXapAoGBALfhFjJat6TZ/RBOxjEL
8/n/puhe5Jei/3wRxaEb7qrgo/xflYDceJI4Z29G0RLj8gYEJUjqrDlEFPdPHs4doJzJxJ71Llp7
ZeGaeGihsgGIzmFPtNPAuNfuk2tA9AK02D+aLqdf3kXNEAHWeiVWGtWfM/xrDD/CdGS55qh2F7y5
AoGAIBZknVZPtsjURAgwkVUMiWNP0G+TNndAjDOAlb510LdzcIrxYWAyBgPrgzI4vvWp45l7ZBfi
LGbhjjybTXyuhPZfV1ANAfSI2k5VjVFNSPNIK8YNfKqMMHGexqtzXkziFYAs0hUXx9SpJgyi7Bvo
tYN+bIJ6N0dY1JT/CM6SnXECgYAL4dy4VkplubxzsFN4WehjMFUN0Qv+jIbr8o4N0itDGY8fQOH9
WMHl2QU+GJpsGRTLtLrgEmIctTyRmqhH83wshZFSIE/lgvHbeUrsn/5LwRZtDWSHBn4rXfxiwujB
wAP1YDZBlJ1db1nodH6iKQVE5qvKVPSOrjctRyITosX36QKBgQCP5yY9UhSCAIM6svxzrWisEj43
tlKFiNQfHz1V9HEeXzmduaKWe4IvC8qU+ZZzhyxDOpidfN28+cj8JLSnOjXepIiCOwTISzz1mjab
SIXQWcmJ+l4B+s3MJ0/igX5F7XeK8ICHPj36zD5u8nMF3iJoYxpB/DB7we28cw5bowjE5g==
-----END RSA PRIVATE KEY-----


c368875f3add5417023bf1ac0035f1a81e1d34c2





https://dev.azure.com/Nedbank-Limited/



















