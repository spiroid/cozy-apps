FROM node:0.10
MAINTAINER Rony Dray <contact@obigroup.fr>

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python-pip \
    curl \
    nano \
    sudo \
    && apt-get clean

# Clean APT cache for a lighter image
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install supervisor

# Install CoffeeScript
RUN npm install -g \
    coffee-script

# Configure Supervisor.
ADD supervisor/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor \
&& chmod 777 /var/log/supervisor \
&& /usr/local/bin/supervisord -c /etc/supervisord.conf

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

# Install Cozy Monitor
RUN git clone https://github.com/cozy/cozy-monitor /usr/cozy/cozy-monitor
RUN cd /usr/cozy/cozy-monitor; npm install --production

# Install Cozy Controller
RUN git clone https://github.com/cozy/cozy-controller /usr/local/lib/node_modules/cozy-controller
RUN cd /usr/local/lib/node_modules/cozy-controller; npm install --production

# Import Supervisor configuration files.
ADD supervisor/cozy-controller.conf /etc/supervisor/conf.d/cozy-controller.conf
RUN chmod 0644 /etc/supervisor/conf.d/*

#Expose Proxy port
# EXPOSE 9104

ADD sh/run.sh /home/run.sh
WORKDIR /home
CMD ["/bin/sh", "run.sh"]