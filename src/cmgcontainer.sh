# Obtained from github.com/agurwicz/cmg-macos

########## User defined ##########

# Path to CMG directory in the Mac.
cmg_local_path=""

#Location of the CMG license.
cmg_lic_host=""

########## User defined ##########
########## Customizable ##########

# Working directory in local machine. Will be mapped to the container.
workdir=${PWD}

# Base name of the container to create. An index will be appended at the end to allow for multiple instances.
container_base_name="cmg"

# Name of the Docker image to create the container from.
image_name="ubuntu:latest"

# Where to map the CMG directory in the container.
cmg_remote_path="/cmg"

# Where to map the working directory in the container.
remote_workdir="/workdir"

########## Customizable ##########

function get_container_name {
	local container_list=$(docker container ls)
	local index=0
	container_name="${container_base_name}-${index}"
	
	while [[ ${container_list} == *${container_name}* ]]; do
		((index++)); container_name="${container_base_name}-${index}"
	done
}

get_container_name

docker container run \
--interactive \
--tty \
--rm \
--platform linux/x86_64 \
--env CMG_LIC_HOST=${cmg_lic_host} \
--volume ${cmg_local_path}:${cmg_remote_path} \
--volume ${workdir}:${remote_workdir} \
--workdir ${workdir} \
--name ${container_name} \
${image_name} \
/bin/bash