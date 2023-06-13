#!/bin/bash

# A script that will create a resource group in Azure and install an Ubuntu VM into it

setup() {
    # Install az cli
    brew update && brew install azure-cli # Install azure-cli
    # Login
    az login --use-device-code
    echo "You're logged in."
}

# Prints out recommended regions
print_out_regions() {
    regions_array=($( az account list-locations --query "[?metadata.regionCategory=='Recommended'].{Name:name}" -o tsv))
    for i in "${regions_array[@]}"
    do
       echo "$i"
    done
}

# Select a region
check_region() {
    local region_exists=false
    while [[ "$region_exists" = false ]];  do
        print_out_regions
        read -p "Enter your region: " selected_region
        for j in "${regions_array[@]}"
        do
            if [[ "$selected_region" == "$j" ]]; then
                region_exists=true
                echo "Region exists"
                break
            else
                continue
            fi
        done
    done
}

# Check if resource group already exists.
check_resource_group () {
    while true; do
        read -p "Enter a name for you resource group: " resource_group
        if [ $(az group exists --name $resource_group) = true ]; then
            echo "The group $resource_group exists in $selected_region, please provide another name..."
        else
            break
        fi
    done
}


# Create the resource group
create_resource_group () {
    echo "Creating resource group: $resource_group in $selected_region"
    az group create -g $resource_group -l $selected_region | grep provisioningState
}

#List all resource groups
list_resource_groups() {
    az group list -o table
}

# Asks user if they would like to create a VM and stores in createvm variable
vm_creation() {
	local answer=false
	while [[ "$answer" = false ]]; do
		read -p "Would you like to create a VM yes/no?" createvm
		if [ "$createvm" = "yes" ]; then
			answer=true
			echo "VM to be created"
			break
		elif
			[ "$createvm" = "no" ]; then
			answer=true
			echo "No problem, goodbye!"
			break
		else
			echo "Try again"
			continue
		fi
	done
}

vm_creation_answer() {
    if [ "$createvm" = "yes" ]; then
	    echo "Lets get creating a new VM!"
	fi
}


# Prompts user to name their new VM and proceeds to create one with set parameters

vm_letsdothis() {
	if [ "$createvm" = "yes" ]; then
		read -p "Enter a name for your new VM :  " vmname
		read -p "Enter an Admin username for your new VM" adminuser
		read -p "Enter a password" adminpass
		az vm create --resource-group $resource_group --name $vmname --image UbuntuLTS --admin-username $adminuser --admin-password $adminpass
		echo "Thank you, please wait . . . "
	fi
}







#setup
check_region
check_resource_group
create_resource_group
list_resource_groups
vm_creation
vm_creation_answer
vm_letsdothis
