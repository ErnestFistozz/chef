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

