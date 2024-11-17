# Obtained from github.com/agurwicz/cmg-macos

########## User defined ##########

# Extra parameters to be appended to the end of the simulation running command (e.g. "-jacpar", "-parasol", "-wait").
cmg_commands=""

# Path to CMG directory in the Mac.
cmg_local_path=""

# CMG version (e.g. "2023.40").
cmg_version=""

#Location of the CMG license.
cmg_lic_host=""

########## User defined ##########
########## Customizable ##########

# Which simulator to use. Options are "IMEX", "GEM" and "STARS" (case-insensitive).
simulator=${1}

# Name of the main .dat file.
model_name=${2}

# Working directory in local machine. Will be mapped to the container.
workdir=${PWD}

# Base name of the container to create. An index will be appended at the end to allow for multiple instances.
container_base_name="cmgsimulation"

# Name of the Docker image to create the container from.
image_name="ubuntu:latest"

# Where to map the CMG directory in the container.
cmg_remote_path="/cmg"

# Where to map the working directory in the container.
remote_workdir="/workdir"

########## Customizable ##########

function check_docker {
	local docker=$(which docker)

	if [[ $docker = "" ]]; then
		echo "Docker not found."
		exit 1
	fi
}

function get_simulator {
	simulator=$(echo "${simulator}" | tr '[:upper:]' '[:lower:]')

  case ${simulator} in
    "imex") prefix="mx";;
    "gem") prefix="gm";;
    "stars") prefix="st";;
    *) echo "Simulator not recognized."; exit 1;;
  esac

  ld_library_path="${simulator}/${cmg_version}/linux_x64/lib"
	simulator_relative_path="${simulator}/${cmg_version}/linux_x64/exe/${prefix}${cmg_version//\./}.exe"
}

function get_container_name {
	local container_list=$(docker container ls)
	local index=0
	container_name="${container_base_name}-${index}"

	while [[ ${container_list} == *${container_name}* ]]; do
		((index++)); container_name="${container_base_name}-${index}"
	done
}

check_docker
get_simulator
get_container_name

docker container run \
--rm \
--platform linux/x86_64 \
--env CMG_LIC_HOST=${cmg_lic_host} \
--env LD_LIBRARY_PATH="${cmg_remote_path}/${ld_library_path}" \
--volume ${cmg_local_path}:${cmg_remote_path} \
--volume ${workdir}:${remote_workdir} \
--name ${container_name} \
${image_name} \
"${cmg_remote_path}/${simulator_relative_path}" \
-f "${remote_workdir}/${model_name}" -wd "${remote_workdir}" ${cmg_commands}
