FROM node:0.10
MAINTAINER Rony Dray <contact@obigroup.fr>

RUN apt-get update && apt-get install -y --no-install-recommends \
    python-pip \
    curl \
    nano \
    sudo

# Clean APT cache for a lighter image
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install supervisor

# Configure Supervisor.
ADD supervisor/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor \
&& chmod 777 /var/log/supervisor \
&& /usr/local/bin/supervisord -c /etc/supervisord.conf

# Install CoffeeScript
RUN npm install -g \
    coffee-script

# Create Cozy users, without home directories.
RUN useradd -M cozy \
&& useradd -M cozy-data-system \
&& useradd -M cozy-home

# Need ENV VARS:
ENV NODE_ENV production

# Install Cozy Monitor
RUN git clone https://github.com/obigroup/cozy-monitor /usr/cozy/cozy-monitor
RUN cd /usr/cozy/cozy-monitor; npm install --production

# Install Cozy Controller
RUN git clone https://github.com/obigroup/cozy-controller /usr/local/lib/node_modules/cozy-controller
RUN cd /usr/local/lib/node_modules/cozy-controller; npm install --production;

#Expose Proxy port
EXPOSE 9104

# Import Supervisor configuration files.
ADD supervisor/cozy-controller.conf /etc/supervisor/conf.d/cozy-controller.conf

ADD sh/run.sh /home/run.sh
WORKDIR /home
CMD ["/bin/sh", "run.sh"]