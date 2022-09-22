# docker-local-development-rhel-6-10

Dockerfiles and settings for local development on Rhel 6.10 images via Ansible

Since Rhel 6.10 is out of support getting things to work on it (specifically Python 3.x) and Ansible is quite painful

There are also some "gotcha's" to keep in mind when using M1 macs and when trying to avoid using Docker-Desktop which has now been properly monetised

## Installing Docker without Docker-Desktop

1. Make sure Docker-Desktop is no longer installed
2. `brew install docker docker-compose`
3. There will likely be instructions to link these two as docker-compose is now a plugin for docker so follow those instructions
4. You need a docker runtime for macs - use [Colima](https://github.com/abiosoft/colima)

## Considerations for M1 macs

`docker build` will freak out without the correct settings as you're no longer on an intel/amd platform

Either run all docker tasks with 

(a) --platform linux/amd64 flag
(b) export DOCKER_DEFAULT_PLATFORM=linux/amd64 
(c) add `FROM --platform=linux/amd64 <dockerimage>:<version> to all dockerfiles

## Making life easier with Portainer

[Follow these installation instructions](https://docs.portainer.io/start/install/server/docker/linux)
You'll want to use to community edition
