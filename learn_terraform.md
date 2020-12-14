# Potential Books
	Learning-Terraform by Jude Zhu
	Learn Terraform The Hard Way
	Terraform: From Beginner To Master: With Examples In AWS


# Terraform definition

you rely on it to take care of the details while you articulate the end state you want.

`You define the list of resources and configuration required for your infrastructure. Terraform examines each resource and uses a graph-based approach to model and apply the desired state. Each resource is placed inside the graph, its relationships with other resources are calculated, and then each resource is automatically built in the correct order to produce your infrastructure. This means you never have to
think about modeling these complex relationships. Terraform does it for you`.

``Terraform also integrates with configuration management and provisioning tools to allow you to control application and service level components. You can easily leverage and reuse existing configuration management content you may already have that defines your applications and infrastructure``

`Terraform is primarily used to manage Cloud-based and Software-as-a-Service (SaaS) infrastructure but also supports various onpremise resources such as Docker and VMWare vSphere. Terraform can manage hosts, compute resources, data and storage, networking, as well as SaaS services like CDNs, monitoring tools, and DNS`

## Declarative 

Declarative plans are ones in which you specify outcomes.

## Infrastructure as Code (IaC) 
“Infrastructure as Code” (IaC) enables us to describe our infrastructure and 	applications in source code. This enables us to treat our infrastructure like we treat our applications and take advantage of development practices and tools.

Infrastructure represented, and programmatically manipulatable, in code can be versioned, shared, re-used, debugged, and potentially reverted when something goes wrong. We can apply the tenets of our application development life cycle to our infrastructure including code reviews, linting, and automated testing. Instead of poorly and infrequently maintained documentation or state stored in the minds of your teammates, we can create managed environments that we can easily introspect, monitor, and debug.


``configuration management tools`` - Puppet, Chef, and Ansible --> excellent at managing applications and services, but they’re often focused on software configuration rather than building the infrastructure components that underpin our applications.

Terraform ==> is instead focused on building and deploying infrastructure.


# Terraform - hands-on

## Terraform Commands

`init` -- is used to initialize a working directory containing Terraform configuration files
`plan` -- Shows us what changes Terraform will make to our
infrastructure.
`apply` -- Applies changes to our infrastructure

`destroy` -- Destroys infrastructure built with Terraform.

```
$terraform init --> used to download the providers used in configuration files
$terraform plan
$terraform apply
$terraform destroy
```

`When Terraform runs inside a directory it will load any Terraform configuration files. Any non-configuration files are ignored and Terraform will not recurse into any sub-directories. Each file is loaded in alphabetical order, and the contents of each configuration file are appended into one configuration.`

Terraform then constructs a DAG, or Directed Acyclic Graph, of that configuration. The vertices of that graph— its nodes—are resources—for example, a host, subnet, or unit of storage; the edges are the relationships, the order, between resources.

The graph determines this relationship and then ensures Terraform builds your configuration in the right order to satisfy this.

The configuration loading model allows us to treat individual directories, like base, as standalone configurations or environments. A common Terraform directory structure might look like:

```
terraform/
		base/
		development/
		production/
		staging/
```
Each directory could represent an environment, stack, or application in our organization.
Terraform files are written in the HashiCorp Configuration Language (HCL) and suffixed .tf or tf.json. USE .tf extension preferrably

### Providers

Providers connect Terraform to the infrastructure you want to manage—for
example, AWS, AZURE, VSphere.
They provide configuration like connection details and authentication credentials

Providers are not shipped with Terraform since Terraform 0.10. In order to download the providers you’re using in your environment you need to run the `terraform init` command to install any required providers.

#### Syntax

provider "PROVIDER_NAME" {
		KEY = VALUE  
}
PROVIDER_NAME --> provider offered by terraform
The KEY is a parameter of the provider --> look it up within terraform documentation


### Resources

Resources are the bread and butter of Terraform. They represent the infrastructure components you want to manage: ``hosts, networks, firewalls, DNS entries, and many more ``

#### Syntax

resource "RESOURCE_NAME" "NAME" {
	KEY = VALUE # they KEY is
}

RESOURCE_NAME --> associated to a PROVIDER, offered by terraform
KEY --> parameter of resource, look it up within terraform documentation
NAME ---> user defined name. The name of the resource should generally describe what the resource is or does.

NOTE: 'The combination of type and name must be unique in your configuration'

Example: General Syntax of resource

RESOURCE_NAME "PROVIDER_RESOURCE-TYPE" "NAME" {
	
}

system local machine,
thumbprint
add user to certificate

User [IIS AppPool\\AppPool Name] via AppPool identity

store name and store location

App Pool recycling

[11:52 AM] Hoosain, Q. (Qasim)
    Cert Store - Personal



