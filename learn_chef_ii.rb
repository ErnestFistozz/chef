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







SMSGW 










