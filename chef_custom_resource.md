

property :PROPERTY_NAME, TYPE, default: 'DEFAULT_VALUE', name_property: 'TRUE/FALSE'

'name_property: true allows the value for this property to be equal to the 'name' of the resource block'

# The first action is the Default action

action :ACTION_NAME do
	# you access the property name (within the resource file) as

	new_resource.PROPERTY_NAME
end

action :ACTION_NAME do

end

The resource gets its name from the cookbook and from the file name in the /resources directory, with an underscore (_) separating them. For example, a cookbook named WEBSITE with a custom resource named SITE.rb


WEBSITE_SITE 'name' do
	PROPERTY_NAME VALUE
end

# Accessing  the custom resource is as follows:

'The cookbook name seperated underscore with the resource name'

COOKBOOK-NAME_RESOURCE-NAME 'name' do
	PROPERTY_NAME VALUE
end

'Chef’s built-in file, service and package can be used inside the chef custom resource'