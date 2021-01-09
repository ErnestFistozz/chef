
# The docker book - James Turnbull

## Docker introduction
Docker is an open-source engine that automates the deployment of applications into containers.
Docker adds an application deployment engine on top of a virtualized container execution environment. It is designed to provide a lightweight and fast environment in which to run your code as well as an efficient workflow to get that code from your laptop to your test environment and then into production. 

### Docker Components

``Docker Client and Server``

Docker is a `client-server application`. ``The Docker client talks to the Docker server
or daemon, which, in turn, does all the work``. You’ll also sometimes see the `Docker
daemon` called the `Docker Engine`. Docker ships with a command line client binary,
docker, as well as a full RESTful API to interact with the daemon: dockerd. You
can run the Docker daemon and client on the same host or connect your local
Docker client to a remote daemon running on another host.

``Docker images``

Images are the building blocks of the Docker world. You launch your containers
from images. Images are the “build” part of Docker’s life cycle. They have a
layered format, using Union file systems, that are built step-by-step using a series
of instructions.

You can consider images to be the “source code” for your containers.

``Docker registries``
Docker stores the images you build in registries. There are two types of registries:
public and private.

```public registry``` - Docker, Inc., operates the public registry for images, called
the Docker Hub.

```private registry```  - This allows you to store images behind your firewall, which may be a
requirement for some organizations

``Docker Containers or Simply Container``

Docker helps you build and deploy containers inside of which you can package
your applications and services. As we’ve just learned, containers are launched
from images and can contain one or more running processes. You can think about
images as the building or packing aspect of Docker and the containers as the
running or execution aspect of Docker.

Docker container is:
	• An image format.
	• A set of standard operations.
	• An execution 

A docker container is a running instance of a docker image.

``Compose, Swarm and Kubernetes``
In addition to solitary containers we can also run Docker containers in stacks and
clusters, what Docker calls swarms.

• Docker Compose - which allows you to run stacks of containers to represent
				   application stacks, for example web server, application server and database
				   server containers running together to serve a specific application.

• Docker Swarm - which allows you to create clusters of containers, called
				 swarms, that allow you to run scalable workloads.


### Docker installation

``$ sudo docker info`` returns lists of containers, images etc

Note: if you use UFW (Uncomplicated Firewall) you need to alter the configuration inside ``/etc/default/ufw``
`` From -- DEFAULT_FORWARD_POLICY="DROP" ``
`` To -- DEFAULT_FORWARD_POLICY="ACCEPT" ``

After changing this, reload UFW ``sudo ufw reload``

``Docker Daemon``
Docker runs as a ``root-privileged daemon`` process to allow it to handle operations
that can’t be executed by normal users (e.g., mounting filesystems). The
docker binary runs as a client of this daemon and also requires root privileges to
run. You can control the Docker daemon via the dockerd binary.


The Docker daemon should be started by default when the Docker package is
installed. By default, the daemon listens on a Unix socket at `/var/run/docker`.
sock for incoming Docker requests. If a group named `docker` exists on our system,
Docker will apply ownership of the socket to that group. Hence, any user that
belongs to the docker group can run Docker without needing to use the sudo
command.

Docker has a `client-server` architecture.
It has two binaries, the Docker server provided via the ``dockerd`` binary and the
``docker`` binary, that acts as a client. As a client, the docker binary passes requests
to the Docker daemon (e.g., asking it to return information about itself), and then
processes those requests when they are returned.