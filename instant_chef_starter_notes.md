https://www.techapprise.com/cybersecurity/hacking-learning-websites/

## what is chef

By modeling infrastructure, Chef makes it much easier to manage those systems in a central location using a combination of recipes and configuration settings that are applied in a consistent manner.

You can manage  a collection of specific packages, configuration settings, network settings, firewall rules, user accounts, services, and so on that are required to provide its service within the infrastructure.

### Chef components

Chef is composed of two primary components, the ``client`` that is requesting configuration data to be applied, and the ``service`` that provides the configuration. In addition, any client that is used by an administrator to manage data (upload cookbooks, edit data bags, and so on), is referred to as a ``workstation`` but is just a client that runs tools, such as shef and knife.

``Node`` ---> A node is a `client` that applies roles and recipes, as described by the administrator in the chef service. These are the consumers of the configuration, the elements of your infrastructure such as a server that you are setting up. They can be physical or virtual machines and can run Linux, Windows, or technically any other system that is capable of running Ruby (some systems may not be supported
out of the box by Chef). Nodes primarily interact with the `Chef service` using the ```chef-client``` command-line tool which is responsible for fetching the node's ``run list`` and executing it to configure the system

``Chef Service/Chef Server`` ---> The chef service is composed of several components: a web interface, an API server, Solr for searching configurations, CouchDB for storing data, and RabbitMQ to provide a communications bus between the different processes. This is where the clients (nodes) connect to determine what roles and recipes to apply, and an administrator logs in to build configurations.

#### Basic Concepts

```Recipe``` --> A recipe is a collection of instructions (written in Ruby) and configuration data that achieves a goal. This goal may be to install a particular package, configure a firewall, provision users, and so on. Recipes rely on their custom logic written by the author combined with node-specific and role-specific attributes, data bags and Chef's built-in data searching abilities to be flexible, and generate reproducible results.


```Cookbook``` ---> A cookbook is a container (or collection of) that holds one or more recipes, templates, configuration settings, and metadata that work together to provide a package or perform an actionable item such as installing PostgreSQL or managing an internal server's connectivity. 

```Attributes``` ---> Attributes are configuration data that is used by recipes either to provide some default settings for a recipe or to override default settings. Attributes can be associated with a specific node or role in the system.

```Role``` A role is a `user-defined collection of recipes` and configuration values that describe some sort of common configuration. For example, you might declare a basic "MySQL Server" role that declares that the MySQL server recipe should be run and should have some specific configuration such as which password to use for the root user and what IP addresses to bind to.

`Note`: Roles are, at their core, a run list and a set of attributes that, when combined, work together to model a specific set of functionality.

```Run list``` ---> A run list is a combined list of recipes to be applied to a given node in a certain `order`. A run list can comprise of ``zero or more roles/recipes``, and `order is important` as the run list's items are executed in the order specified. Therefore, if one recipe is dependent upon the execution of another, you need to ensure that they run in the ``correct order``.

```Resource``` ---> A resource is, at its core, a unit of work. There are numerous types of resources to be used in a recipe but some of the more commonly used ones would be ``package`` and ``service``. Chef tries to be as cross-platform friendly as possible and keeps the implementation details of a resource separate in a `provider`.

```Provider``` ---> A provider is a concrete implementation of a resource. Most providers offer implementation-specific resources as well as generic resources. If you use the generic resource provider Chef will use node-specific information, such as the distribution name, to determine which provider to execute. Optionally, you can explicitly use an implementation-specific resource such as ```redhat_package``` if you need to.

```Data Bags``` ---> In addition to storing configuration data with a node or a role, Chef has the notion of infrastructure-wide data storage. ```This data is accessible to any recipe through the data bags interface```. Information about users, groups, firewall rules, internal IP address lists, software versions, and other data can be stored here. Data bags contain data about your infrastructure as a whole and are a good way to store any information your recipes need about system-wide configuration.

```Environments``` ---> Environments allow you to control groups of systems with different configurations. A very common use for environments is to manage multiple instances
of the same infrastructure for an application's life-cycle where a development team needs to have a staging and a production environment in which the nodes have the same
roles applied to them (database server, application server, job queue server) but unique configuration data such as firewalls, IP addresses, or other environment-specific data.


## Installing Chef Service, Chef Client and Bootstrapping a node

### Debian and Ubuntu distribution

`1`: Adding the Opscode repository to your APT sources

To use the repository, you need to add the following to your sources (either directly to ``/etc/ apt/sources.list`` or ``/etc/apt/sources.list.d/opscode.com.list``, depending
on your distribution):

`2`: Adding the GnuPG key to your keyring
	In order to use the packages provided by Opscode without APT complaining about unsigned packages, you will want to add the GnuPG key (0x83EF826A) that was used to sign the packages from gnupg.net.
		gnupg -- prerequisite (needs to be installed)

```
	$sudo mkdir -p /etc/apt/trusted.gpg.d
	$gpg --keyserver keys.gnupg.net --recv-keys 83EF826A
	$gpg --export packages@opscode.com > /tmp/opscode.gpg
	$sudo cp /tmp/opscode.gpg /etc/apt/trusted.gpg.d/opscode-keyring.gpg
```
`3`: Updating your APT repositories
```
	$sudo apt-get update
```
`4`: Installing the Chef Server
	
```
	$sudo apt-get install opscode-keyring chef chef-server
```

`knife` ---> command-line utility that a chef workstation or administrator uses to communicate to the chef-server/chef service. It is run from a workstation and provides many commands for ```viewing, searching, interacting with, and editing data``` provided by the Chef service.

``Knife communicates with the Chef Server via HTTP and uses certificates for authentication between the client or node and the server``. Once you have installed the components, create a location for your configuration, and `copy over the certificates that were generated by the server during the installation`, and then change their owner to your user

Chef uses signed header authentication for requests to the API, which means there must be an initial shared key for signing requests. Chef Server will generate the `validation.pem` file when it is first run. New nodes or clients use the `validation.pem` file to sign the requests used to self register.

`Knife Configuration Mode` : ``knife configure -i``

### Bootsrapping a node/servers

Bootstrapping is the process of setting up something without external intervention. Chef uses bootstrap scripts that are executed `(over SSH)` on a remote server to perform any initial configuration that you desire.

In addition to any initial configuration, bootstrapping registers the node with the Chef Server so that it becomes a member of the infrastructure and can have configurations, cookbooks and/or roles applied to it.

Knife does some ``interpolation locally`` of the bootstrap script before it is run on the server. This means that you can leverage Chef's data and configuration during the bootstrap process. Common uses here would include setting up initial firewall rules, routes, users, or other mandatory initial provisioning.

```
$export SERVER_IP ="IPADDRESS"
$export USER = "USER_NAME"
$knife bootstrap -U $USER --sudo $SERVER_IP -d ubuntu12.04-gems
 		OR
$export PASSWORD = "**********"
$knife bootsrap -U $USER -P $PASSWORD -N NODE_NAME -d ubuntu12.04-gems
```
The flag `-d` ---> is for distribution

When executed, this command tells knife to execute the bootstrap command, which is responsible for loading the bootstrap script specified by the -d flag (-d is for distribution) over SSH logging into the remote server specified by the environment variable.

### Uploading cookbook

```
$knife cookbook upload -o path/to/cookbook COOKBOOK_NAME
```
`o` ---> cookbook path

## Creating Roles

Roles are Chef's way of organizing a group of recipes and settings into a set of things that can be applied to a node.

Note: When Creating a Role, Order is important here, the run list is executed in the order specified

## Apply roles/cookbooks/recipes to client

``
$knife ssh QUERY COMMAND
$knife winrm QUERY COMMAND
``
This logges in to the node via SSH/WINRM and runs `chef-client` as sudo/administrator

Example:

```
$knife ssh "roles:ROLE_NAME" "sudo chef-client"
$knife winrm "roles:ROLE_NAME" "Administrator chef-client"
```
Should the FQDN not be resolvable, use:
``knife ssh 'KEY:VALUE' -a IP_ADDRESS -x USER -P PASSWORD 'sudo COMMAND' --> Linux/Unix
  knide winrm 'KEY:VALUE' -a IP_ADDRESS -x USER -P PASSWORD 'Administrator COMMAND' --> Windows
``

## Cookbook Attributes

When writing your recipes these attributes are accessed through the node hash, and are computed for you by Chef ahead of time.
Oder  of precedence of Attributes:
`
 a) default
 b)	normal (also set)
 c)	override
`
Within each level (above) the order of precedence is:
``
	a) attributes file inside of a cookbook
	b) environment
	c) role
	d) node
	``

Note: Chef loads attributes files in alphabetical order, and cookbooks tend to contain only one attributes file named ``attributes/default.rb``. If you have a cookbook that has more complex attributes definition files, it might be wise to separate them into ``recipe-specific attributes`` files.

### Definig Attributes
a) Default file
	default['COOKBOOK_NAME']['ATTRIBUTE_NAME'] == 'VALUE'
b) Recipe Specific (defined in the name)
	default['COOKBOOK_NAME']['RECIPE_NAME']['ATTRIBUTE_NAME'] == 'VALUE'

The attributes for a cookbook are name-spaced inside of a key, typically the same
name as the cookbook (as shown by `A` in above). If you have multiple recipes inside a cookbook, you would likely have default configurations in every recipe (As shown by `B`)

### Loading Attributes from another cookbook

Additionally, you can load attributes from another cookbook using the include_attribute
method.

``
	include_attribute 'COOKBOOK_NAME::ATTRIBUTE_FILE_NAME'
	#
	default['CURRENT_COOKBOOK_NAME']['ATTRIBUTE_NAME'] = node['COOKBOOK_NAME']['ATTRIBUTE_NAME']
``

Note: make sure that you add cookbooks that you load defaults from as a dependency in your cookbook's metadata.

Once you have defined your attributes, they are accessible in our recipes using the `node hash`. Chef will compute the attributes in the order discussed and produce one large hash, (also called a "mash" in Chef as it is a hash with indifferent access


Note:
String keys or symbol keys are treated as the same, so node[:key] is the same as node["key"])
#### Example
	default['COOKBOOK_NAME']['ATTRIBUTE'] = 'VALUE'
	node[:COOKBOOK_NAME][:ATTRIBUTE] is the same as node['COOKBOOK_NAME']['ATTRIBUTE']


## Templates

Often Used when: writing out any sort of customizable data file to the filesystem, you will need to generate a file with some data inside of it.

As ERB is a Ruby template language, it supports arbitrary Ruby code within it, as well as some ERB specific markup

To execute some arbitrary Ruby code, you use the ``<% %>`` container. The ``<%`` tag indicates the beginning of the Ruby code, and ``%>`` tag indicates the end of
the block.
#### Examples:
1) Executing Ruby

a) Multiple lines 
`<%
		[1,2,3].each do |index|
			puts index
		end
	%>`

b)  Single line
	`<% users.collect{|u| u.full_name } %>`

c) Multiple line with code embedded
	``<% [1,2,3].each do |value| %>
		#Code or None-Ruby Stuff...
	  <% end %>``

2)  Variable Replacement
ERB has syntax for replacing the block with the results of the block, and that container is similar to the last one, with the addition of the equal sign inside the opening tag. This looks like this, ``<%= %>``. Any valid Ruby code is acceptable inside this block, and the result of this code is put into the template in place of the block.

a) ``<%= @somevariable %>
	 <%= hash[:key] + otherhash[:other_key] %>
	 <%= array.join(", ") %>``

b) ``<% [1,2,3].each do |value| %>
	 #Some-stuff = <%= value %>
	 <% end %>``


## Resources

Resources, when used in a recipe take the following form:

resource_name "name attribute" do
	attribute "value"
	attribute "value"
end

## Roles

Create a role by running

``
$ knife role create ROLE_NAME
$ knife role from file PATH/TO/FILE/FILE_NAME.rb
``

$ Searching Nodes

```
$knife search SEARCH_INDEX "KEY:VALUE" ---> Precise Search
$knife search SEARCH_INDEX "KEY:*VALUE" ---> Search for all SEARCH_INDEX which end with VALUE
$knife search SEARCH_INDEX "KEY:VALUE*" ---> Search for all SEARCH_INDEX which start with VALUE
$knife search SEARCH_INDEX "KEY:*VALUE*" ---> Search for all SEARCH_INDEX which CONTAIN  VALUE
$knife search SEARCH_INDEX "KEY:START_VALUE-??-END_VALUE" ---> Search for all SEARCH_INDEX  Start-value and  end with end-value
```

## Data Bags

if we have information that is global to our infrastructure such as user accounts, internal firewall rules, or other information that could possibly be used in a variety of different recipes? This is where data bags come in, they are a place where we can store arbitrary data about our configuration that can be searched for, read from, and written to by recipes.

Data bags are recipe-independent and cookbook-independent, globally available JSON data. They can be searched, accessed, modified, and created from recipes or via knife. Think of them as a place to store your infrastructure configuration.

Data bags allow us to write recipes that are more generic in nature

### Data Bags Structure

Data bags are containers, and inside each data bag are zero or more items each of which has name and some arbitrary JSON data. As such there are no enforcements on how you structure your item's data, so long as it is can be represented using JSON.

