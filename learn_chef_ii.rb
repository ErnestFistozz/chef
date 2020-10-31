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




















