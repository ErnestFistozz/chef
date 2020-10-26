
Node: A node is a client that applies roles and recipes, as described by the
	  administrator in the chef service. These are the consumers of the configuration,
	  the elements of your infrastructure such as a server that you are setting up. They
	  can be physical or virtual machines and can run Linux, Windows, or technically any
	  other system that is capable of running Ruby.

	  Nodes primarily interact with the Chef service using the
	  'chef-client' command-line tool which is responsible for fetching the nodes
	  run list and executing it to configure the system.

Chef-Service/Server: The chef service is composed of several components: a web interface, an
	  API server, Solr for searching configurations, CouchDB for storing data, and RabbitMQ
	  to provide a communications bus between the different processes. This is where
	  the clients (nodes) connect to determine what roles and recipes to apply, and an
	  administrator logs in to build configurations.


https://app.willotalent.com/common/6192b1b633bb42e7b16afe38c6a40d1d
MaxxAudio Pro  - 6
