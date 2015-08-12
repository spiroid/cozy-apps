FROM node:0.10
MAINTAINER Rony Dray <contact@obigroup.fr>, Jonathan Dray <jonathan.dray@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --quiet --assume-yes --no-install-recommends \
    build-essential \
    curl \
    nano \
    sudo \
    && apt-get clean

# Clean APT cache for a lighter image
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install CoffeeScript & Cozy Controller
RUN npm install -g \
    coffee-script \
    cozy-controller@2.0.30 \
    cozy-monitor@1.2.27

# Create Cozy users, without home directories.
RUN useradd -M cozy \
&& useradd -M cozy-data-system \
&& useradd -M cozy-home

# Need ENV VARS:
ENV NODE_ENV production
ENV COUCH_HOST couchdb
ENV COUCH_PORT 5984
ENV INDEXER_HOST dataindexer
ENV INDEXER_PORT 9102

# Expose port
EXPOSE 9104

VOLUME ["/usr/local/cozy/"]

ADD sh/init.sh /usr/local/bin/cozy-init.sh
RUN chmod +x /usr/local/bin/cozy-init.sh

WORKDIR /usr/local/lib/node_modules/cozy-controller/build/

CMD [ "node", "server.js" ]
#CMD ["/bin/sh", "run.sh"]
