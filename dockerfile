FROM centos:centos6.10

# Fixing main repositories
RUN curl https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo

# Fixing missing EPL repositories
RUN curl https://www.getpagespeed.com/files/centos6-epel-eol.repo --output /etc/yum.repos.d/epel.repo

RUN yum -y install centos-release-scl \
    && curl https://www.getpagespeed.com/files/centos6-scl-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl.repo \
    && curl https://www.getpagespeed.com/files/centos6-scl-rh-eol.repo --output /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo

RUN yum -y update

RUN yum install wget tar curl unzip git nc ca-certificates gcc screen zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel xz-devel expat-devel musl-devel libffi-devel xz -y

# goal here is to allow VSCode to connect by updating glibc - this should work but doesn't 
# RUN wget -q http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-2.17-55.el6.x86_64.rpm \
#     && wget -q http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-common-2.17-55.el6.x86_64.rpm \
#     && wget -q http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-devel-2.17-55.el6.x86_64.rpm \
#     && wget -q http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-headers-2.17-55.el6.x86_64.rpm \
#     && wget -q https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-utils-2.17-55.el6.x86_64.rpm \
#     && wget -q https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/glibc-2.17-55.fc20/glibc-static-2.17-55.el6.x86_64.rpm \
#     && rpm -Uh --force --nodeps \
#         glibc-2.17-55.el6.x86_64.rpm \
#         glibc-common-2.17-55.el6.x86_64.rpm \
#         glibc-devel-2.17-55.el6.x86_64.rpm \
#         glibc-headers-2.17-55.el6.x86_64.rpm \
#         glibc-static-2.17-55.el6.x86_64.rpm \
#         glibc-utils-2.17-55.el6.x86_64.rpm \
#     && rm *.rpm

# Update libstdc++ - this should work but doesn't
# RUN  wget -q https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-4.8.2-16.3.el6.x86_64.rpm \
#     && wget -q https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-devel-4.8.2-16.3.el6.x86_64.rpm \
#     && wget -q https://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-el6/epel-6-x86_64/gcc-4.8.2-16.3.fc20/libstdc++-static-4.8.2-16.3.el6.x86_64.rpm \
#     && rpm -Uh \
#         libstdc++-4.8.2-16.3.el6.x86_64.rpm \
#         libstdc++-devel-4.8.2-16.3.el6.x86_64.rpm \
#         libstdc++-static-4.8.2-16.3.el6.x86_64.rpm \
#     && rm *.rpm

# Install python 3.6.3
RUN wget --no-check-certificate https://python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz \
    && tar xf Python-3.6.3.tar.xz \
    && rm -f Python-3.6.3.tar.xz \
    && ./Python-3.6.3/configure --enable-optimizations \
    && make altinstall

# install pip and virtualenv
RUN cd /tmp \
    && wget https://bootstrap.pypa.io/pip/3.6/get-pip.py \
    && python3.6 get-pip.py \
    && python3.6 -m pip install --upgrade pip \
    && python3.6 -m pip install virtualenv

# install ansible and create virtualenv
RUN cd /tmp \
    && mkdir /tmp/python-venv && cd "$_" \
    && python3.6 -m venv ansible \
    && source ansible/bin/activate \
    && pip install --upgrade pip \
    && python3.6 -m pip install wheel \
    && python3.6 -m pip install cryptography==2.3 \
    && export LC_ALL=en_US.UTF-8 \
    && python3.6 -m pip install ansible-core==2.11.12

CMD [ "/bin/bash" ]