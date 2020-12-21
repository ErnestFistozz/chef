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

resource "PROVIDER_RESOURCE-TYPE" "RESOURCE_NAME" {
	
}

using output of resource in another resource

PROVIDER_RESOURCE_TYPE.NAME.ATTRIBUTE_REFERENCE

Note: For AWS creating a AWS_INSTANCE attaches the instance to the default VPC

Order doesn't really matter to terraform since it uses the GRAPHQ to exermine the order of execution

For AZURE ~>VERSION 2.01 ~
 provider needs to be defined with features block

Example:
provider "PROVIDER_NAME" {
	
	features {}
}

# VARIABLES

variable "VARIABLE_NAME" {
	type = VARIABLE_TYPE e.g string, integer, map, list
	default = DEFAULT_VALUE, e.g "hello world"
	description = "PURPOSE_OF_THIS_VARIABLE"
}

Preferrable define them in `terraform.tfvars` file or
							`FILE_NAME.auto.tfvars` eg. 
							foo.auto.tfvars or
							`variables.tf`
These files will be loaded

## Local variables

define them in a configuration file
Syntax:

locals{
	VARIABLE_NAME = VALUE
}

Usage:
local.VARIABLE_NAME or ${local.VARIABLE_NAME}

### Setting variables
a) define variables in ```variables.tf``` (don't set the default values)
b) set the variable values in ```terraform.tfvars```
c) use the variables in main configuration
d) to set environment variables use `TF_VAR_VARIABLE-NAME`
	Terraform will look for variables in the environment variables which start are prefixed with ``TF_VAR_``

i) if you don't supply a default value, it will request you to pass it at runtime when you execute ``terraform apply``

## Output VALUES or variables

used for debugging, inspection and output data from modules

Preferrable stored in `outputs.tf`

Syntax:

output "OUTPUT_VALUE_NAME"{
	value = VALUE_OF_OUTPUT
	description = "describe out value"
	sentive = true/false --> enables outputting on the cli or not
	depends_on = 

}


# Data Sources

Allow you to retrive data from providers/resources --> think of it as an GET API

Note: all resource have a data source

data "RESOURCE_NAME" "DATA_NAME" {
	KEY = PAIR
	#optionally you can filter
	filter = {
		name = "CATERGORY: VALUE"
		value = ["VALUE_1", "VALUE_2"]
	}
}

using data retrieved

data.RESOURCE_NAME.DATA_NAME


# RESOURCE - META ARGUMENTS

count  (INTEGER) --> how many resources should be created
provisioner --> allows one to run commands against the infrastructure that has been created after its been 
provisioned e.g shell command

example : count

resource "aws_instance" "machine_name"{
	count = 2
	# using count
	count.index --> gives the current index (useful if not a lot of changes are required to resource)	
}

output "instance"{
    # since we created two aws instances, we will iterate over the two
    value = aws_instance.ec2-instance[*].ATTRIBUTE_REFERRENCE -->all
    # OR
    value = [for current_instance in aws_instance.ec2-instance  : current_instance.ATTRIBUTE_REFERRENCE ]
}

example : for_each

resource "aws_instance" "machine_name"{
	for_each" ={
		prod = "t2.large"
		dev = "t2.dev"
	}
	# 
	each.value --> gives the current index (useful if not a lot of changes are required to resource)	
}

output "instance"{
    // since we created two aws instances,
    value = aws_instance.ec2-instance["KEY".ATTRIBUTE_REFERRENCE
}

NOTE: count and for_each cannot be used in the same RESOURCE
NOTE: you can use the same provider in the same file but they must have alias

Example:
	provider "aws"{
		region = "us-west-2"
	}

	provider "aws"{
		alias = "east"
		region = "us-east-1"
	}

using inside a resource

resource "aws_instance" "east_instance"{
	provider = aws.east --> referrence the alias 
}


# EXPRESSION

a) Tenarry or short hand if-else statement
locals {
	KEY = VALUE
}

output{
	VARIABLE = local.KEY === VALUE? TRUE_VALUE : FALSE_VALUE
}

b) HEDOX -- help with multine strings

KEY = <<EOT or <<-EOT (IDENTIFY)
	String 1 ...
	string n
	EOT
c) IF -STATEMENTS AND FOR-LOOPS

	testing_if = "hello %{if CONDITION}{result}%{else}result %{endif} "

	testing_loop = <<EOT
		%{for INDEX in CONDITION }
			DO_SOMETHIN
		%{endfor}
	EOT


# DYANMIC BLOCK

locals {
	ingress_rules = [
		{
			port = 443
			description = "port 443"
		},
		{
			port = 80
			description = "Port 80"
		}
	]
}

resource "aws_security_group" "security_group"{
	dynamic "RULE"{
		for_each = local.ingress_rules
		content  { --> data for block that we are creating dynamically
			description = RULE.value.description (usually the  value has KEY-VALUE pair, but since its a list there is no key )
			from_port = RULE.value.port
			to_port = RULE.value.port
		}
	}
}
			basically we changed the below to the above

ingress {
	description = "port 443"
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cdir_block = ["0.0.0.0/0"]
}

ingress {
	description = "port 80"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cdir_block = ["0.0.0.0/0"]
}

# PROVISIONERs

defined inside a resource

a) local-exec provisioner

local-exec --> will be ran locall from the actual machine we run terraform from
only be called when the resource is created for the first time or on the destroy


provisioner "local-exec" {
	command = "echo ${self.public_id}"
	on_failure = "continue" --> ran when the provisioner fails
}

b) file provisioner
Allows you to create a file on our remote server or copy from local to remote server

c) remote-exec 
Allows to execute commands on the newly created machine

provisioner "remote-exec" {
	when = "destroyed" -->  only ran when destroying
	command = "echo ${self.public_id}"
	script = "" --> unfortuante cannot pass arguemnts
	inline = [
				"touch /"
			]
}
for connection

connection {
	type = "ssh" or wirm
	host = self.public_ip
	user = "user to use to ssh as"
	private_key = file(/path/to/private_key/key.pem)
}

# TERRAFORM MODULES
Allow you to group multiple resources together in a form of a package
i.e allows you to package resources as a group or package

modules generally have 3 (three) files
``` main.tf
	variables.tf
	output.tf
```
Syntax

module "MODULE_NAME"{
	source = "path/to/where/resources/are/defined"
	VARIABLE = VALUE
	...
	VARIABLE_N = VALUE_N

	# for terraform 0.13
	``
	you are allowed to use
	cout  = 
	for_each 
	``
}	

Variables must be defined in the variables file or ``main.tf`` file in where the resources are defined.

terraform {
	required_version = ">= 0.12"
}

# WORKSPACE

by default you have one state
but with workspace, you have multiple set of states

terraform workspace new WORKSPACE_NAME --> create new workspace
terraform workspace list --> list all available workspace
terraform workspace show --> show current workspace

terraform workspace select WORKSPACE_NAME -- > switch or move from workspace

terraform apply -var-file VARIABLE_FILE_NAME.tfvars

### Out-Scope Learnings
Attach webserver to load balancer using 

resource "aws_elb"