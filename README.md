# docker-local-development-rhel-6-10

Dockerfiles and settings for local development on Rhel 6.10 images via Ansible (mainly)

Since Rhel 6.10 is out of support getting things to work on it (specifically Python 3.x) and Ansible is quite painful

There are also some "gotcha's" to keep in mind when using M1 macs and when trying to avoid using Docker-Desktop which has now been properly monetised

There's also a dockerfile-centos-7 version in here as a bit of a contrast which can be connected to via VSCode.

## Installing Docker without Docker-Desktop

1. Make sure Docker-Desktop is no longer installed
2. `brew install docker docker-compose`
3. There will likely be instructions to link these two as docker-compose is now a plugin for docker so follow those instructions
4. You need a docker runtime for macs - use [Colima](https://github.com/abiosoft/colima)

## Considerations for M1 macs

`docker build` will freak out without the correct settings as you're no longer on an intel/amd platform

Either run all docker tasks with 

* --platform linux/amd64 flag
* export DOCKER_DEFAULT_PLATFORM=linux/amd64 
* add `FROM --platform=linux/amd64 <dockerimage>:<version> to all dockerfiles

## Making life easier with Portainer

[Follow these installation instructions](https://docs.portainer.io/start/install/server/docker/linux)
You'll want to use the community edition

## Docker commands

### Build
`docker build --platform linux/amd64 -t <dockerimage>:<version> .`

### Run
`docker run -t -i -d --platform linux/amd64 -v /<local_folder_path>:/<container_folder <dockerimage>:<version>`

### Connecting to your local file system (i.e. VSCode)
If the docker image has the relevant glibc and other libraries available then VSCode will be able to connect to the file system for you without having to mount a volume.

### Docker exec 
`docker exec -it <container_id> /bin/bash`

### Portainer gui
`http://localhost:9443` > Containers > Select container > Console 

If you haven't set the run -i flag you won't be able to easily do this. You can still do it with `docker exec -it <container_id> /bin/bash` but you'll need to know the container id

## Things to avoid

1. Don't run `build` commands from the VSCode terminal. It seems pretty slow and will sometimes randomly timeout getting things from repositories...

2. Due to the lack of GCLIB versions in Centos 6.10 you won't be able to connect your VSCode directly to the running container (I tried but something fails, even if you follow the VSCode workaround).

## Sources

https://www.getpagespeed.com/server-setup/how-to-fix-yum-after-centos-6-went-eol

https://danieleriksson.net/2017/02/08/how-to-install-latest-python-on-centos/