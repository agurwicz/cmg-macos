# CMG on macOS

This repository came to exist due to the lack of macOS support by [Computer Modeling Group](https://www.cmgl.ca)'s reservoir simulators.
We make use of [Docker](https://www.docker.com) to indirectly run CMG's Linux distribution on Macs.

We are open to suggestions and contributions to the repository.
Please feel free to open pull requests/issues for contribution and discussion.

> [!NOTE]
> We have currently tested for CMG 2023.40, macOS 15.1 and Docker Desktop 4.35.1.

## Requirements
- [Docker Desktop on Mac](https://docs.docker.com/desktop/setup/install/mac-install).
- CMG's Linux distribution.
See section [Installation of CMG on macOS](#installation-of-cmg-on-macos) for installation instructions.

## Usage

### Installation
The scripts provided can simply be downloaded and run from the terminal.

For ease of use, we recommend cloning the repo and adding the [`src`](src) directory to the user's `PATH`.
This allows the commands to be called from any directory.

### Use

> [!IMPORTANT]
> Some variables need to be defined in the scripts before running.
> 
> These variables and corresponding explanations are listed in the beginning of each file.

The [cmgrun](src/cmgrun.sh) script runs a simulation in the container and exits, automatically deleting the container.
The syntax is
```bash
cmgrun.sh <simulator> <dat_file>
```
where `simulator` is one of "IMEX, GEM, STARS" (case-insensitive) and `dat_file` is the name of the main model file.
By default, the command should be run from the directory where the model is located.

The [cmgcontainer](src/cmgcontainer.sh) script allows the user to open an interactive container to run simulations and interact with files.
The container will be automatically deleted when exited.
The syntax is
```bash
cmgcontainer.sh
```
and again, the command should be run from the directory where the model is located.

## Installation of CMG on macOS

If trying to install CMG through the installer, the user will most likely face the following error:
> "Darwin" is not a recognized CMG kernel name.

This happens as CMG is (in theory) not compatible with macOS.
There are two workarounds:

1. If the user has access to a functioning CMG installation on a Linux machine (e.g. HPC, other computers), it suffices to copy the whole CMG directory to the Mac.

2. Open an interactive Docker container and install CMG there.
The CMG directory can then be copied from the container to the local machine.
