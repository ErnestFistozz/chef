
# generate a chef cookbook
chef generate cookbook cookbook_name

# generate chef attributes folder in a cookbook
chef generate attribute path/to/cookbook attribute_file_name

# generate chef resource folder in a cookbook
chef generate resource path/to/cookbook resource_file_name

# generate chef template folder in a cookbook
chef generate template path/to/cookbook template_file_name

# executing a resouce in command line without a recipe file
chef-apply -e "package 'package_name'"

#running chef apply using a recipe file
chef-apply recipe_name.rb

#adding an entire cookbook to a git repository
change directory to where cookbook is located
e.g for a cookbook named apache
cd path/to/apache cookbook
git init path/to/apache cookbook # This command must be run at the root folder of the apache cookbook,
								 # i.e inside the cookbook name folder

# running a single recipe with chef-client in local mode is
chef-client --local-mode -r "recipe[cookbook_name::recipe_name]"

# running multiple recipes from different cookbooks with chef-client in local mode is
chef-client --local-mode -r "recipe[cookbook_name::recipe_name], recipe[cookbook_name2::recipe_name]"

# definition of a runlist
A runlist is an order collection of  recipes #Each recipe in the runlist must be defined in the following formatt
"recipe[cookbook_name::recipe_name]"
# Note: When we apply a recipe with 'chef-client', we define a run list.

#including a recipe in another recipe
A recipe can include one (or more) recipes located in cookbooks by using the include_recipe method.
"include_recipe 'cookbook_name::recipe_name' "
# Example as follows:
include_recipe 'cookbook_name::recipe_name'
# Including a recipe in another recipe will allow the resources of the included recipe to be included in the exact same order

#how to upload a cookbook
knife cookbook upload -o /path/to/cookbook/directory cookbook_name
#example
knife cookbook upload -o . cookbook_name

#To show or view a node's run list
knife node show -r node_name
#example 
knife node show -r xdvmamba1

'Kitchen is a command-line application that enables us to manage the testing lifecycle'

Test Kitchen allows us to create an instance solely for testing, installs Chef, converge a run list
of recipes on that instance, verify that the instance is in the desired state, and then destroy the instance

#To create the instance for testing purposes -- create an instance
kitchen create

#To apply the cookbook -- Install chef tools, copy cookbooks, run/apply cookbooks
kitchen converge

#To run the test/verify everything works accordingly
kitchen verify

#To Destroy the instance created in  the first stage
kitchen destroy

#Kitchen File 
#The driver is responsible for creating a machine that we'll use to test our cookbook.
driver:
		name: vagrant/docker
#This tells Test Kitchen how to run Chef, to apply the code in our cookbook to the machine under test.
#This provisioner is responsible for how it applies code to the instance that the driver created.
#The default and simplest approach is to use chef_zero
provisioner:
		name: chef_zero
#This is a list of operation systems on which we want to run our code
#Platforms contains a list of all the platforms that Kitchen will test against when executed
#This should be a list of all the platforms that you want your cookbook to support.
platform:
		- name: ubuntu-18.04
		- name: centos-6.5
#This section defines what we want to test. It includes the Chef run-list of recipes that we want to test
suites:
		- name: default # <-- this is the name of the suite, it can be anything
		  run_list:
		    - recipe[cookbook_name::recipe_name] # list of recipes to be tested
		  attributes:

		- name: anotherTest # <-- this is the name of the suite, it can be anything
		  run_list:
		    - recipe[cookbook_name::recipe_name]
		    - recipe[cookbook_name::recipe_name]
		  attributes:

# kitechen test combines all the kitchen commands into one 
# i.e it combines kitchen create, kitchen converge, kitchen verify and kitchen destroy
kitchen test

# Serverspec tests your servers actual state by executing command locally, via SSH, via WinRM, via Docker API and so on.
# Serverspec is built on a Ruby testing framework named RSpec.
ServerSpec

'example of an isolated ServerSpec expectation/test'

describe package('package_name') do
	it { should be_installed }
end 

path/To/Cookbook/cookbooks/cookbook_name/test/integration/default/serverspec/default_spec.rb

# Within the spec file we need to first require a helper file
# The helper is were we keep common helper methods and library requires in one location.

'Example of a test file'

require 'spec_helper'
describe 'cookbook_name::recipe_name' do

	describe resource_name ('name') do
		it {should action} # e.g it {should be_installed}, it {should be_running}, it {should be_stopped}, it {should be_removed}
	end

end

# Explaining the path
path/To/Cookbook/cookbooks/cookbook_name/test/integration/default/serverspec/default_spec.rb
'The test is by default required' # <-- to indicate that these are tests
'integration' # all tests are searached by serverspec here but it could very well be unit
'default' # <-- corresponds to the name of the suite we defined in the kitchen.yaml file configuration
'default_spec' # relates to the name of the recipe that is to be tested, eg. if recipe name was server => server_spec.rb
# name of the ruby file must give name as:
	'recipe_name_spec.rb' # otherwise, must have the suffix *_spec.rb , else it won't work






























































