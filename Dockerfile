FROM phusion/passenger-nodejs:latest

MAINTAINER Zydney Ambat <zydney.ambat@zalora.com>
MAINTAINER Huan Nguyen <huan.nguyen@zalora.com>

# Initialize frontend dialog since it requires a controlling fucking tty
ENV DEBIAN_FRONTEND noninteractive

# Enable SSH
# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. the init system will auto-generate one during boot.
RUN rm -f /etc/service/sshd/down
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh


# # nvm environment variables
# ENV NVM_DIR /var/www/nvm
# ENV NODE_VERSION 8.11

# # Install nvm 
# RUN apt-get update && apt-get install build-essential libss1-dev \
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash


# # Install node and npm
# RUN /bin/bash -c " source $NVM_DIR/nvm.sh \
#     && nvm install $NODE_VERSION \
#     && nvm alias default $NODE_VERSION \
#     && nvm use default"

# # Add node and npm to path so the commands are available
# ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
# ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Yarn
RUN npm install -g yarn

# Install Webpack
RUN yarn global add webpack

# Install node modules
COPY package.json /var/www/shop/alice/
WORKDIR /var/www/shop/alice
RUN yarn

WORKDIR /var/www/

# According to https://github.com/phusion/baseimage-docker
# This prevents zombie processes and also prevents file corruption when stopping services
CMD ["/sbin/my_init"]
