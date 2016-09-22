# Cozy controller

## Pull the image

```
$ docker pull spiroid/cozy-controller
```


## Build it yourself

```
$ git clone git@github.com:spiroid/cozy-controller.git
$ cd cozy-controller
$ doker build -t spiroid/cozy-controller .
```


## Run:

### With docker-compose

A sample docker-compose.yml configuration file:

```
configuration:
    image: spiroid/cozy-conf

couchdata:
    image: spiroid/cozy-couchdb-data

couchdb:
    image: spiroid/cozy-couchdb
    restart: always
    volumes_from:
        - couchdata
        - configuration

dataindexer:
    image: spiroid/cozy-data-indexer
    hostname: dataindexer
    restart: always
    volumes_from:
        - configuration

controller:
    image: spiroid/cozy-controller
    restart: always
    links:
        - couchdb
        - dataindexer
    volumes_from:
        - configuration
        - dataindexer
    ports:
        - "127.0.0.1:9002:9002"
        - "127.0.0.1:9104:9104"
```


You can also have log files written in a specific directory on your host file system.  
In this case, replace the couchdb and controller section of the above configuration file by
the following:

```
couchdb:
    image: spiroid/cozy-couchdb
    restart: always
    volumes_from:
        - couchdata
        - configuration
    volumes:
        - ./log/couchdb:/var/log/couchdb

controller:
    image: spiroid/cozy-controller
    restart: always
    links:
        - couchdb
        - dataindexer
    volumes_from:
        - configuration
        - dataindexer
    volumes:
        - ./log/cozy:/var/log/cozy
    ports:
        - "127.0.0.1:9002:9002"
        - "127.0.0.1:9104:9104"
```


For this to work, you have to create the logs directories:

```
mkdir -p log/couchdb log/cozy
```

and make sure they have write permissions:

```
chmod -R 777 log
```


## Init the cozy stack

When the container is running and your cozy cloud instance is not yet initialized, there is an init script to launch.
Given that your container name is cozy-container :

```
  docker exec cozy-container cozy-init.sh
```

This installs the Home, Data-System and proxy applications.


## Update nodejs 0.10 to 4.5

To complete your update you need to reinstall your stack.
Given that your container name is cozy-controller :

```
docker exec -ti cozy-controller cozy-monitor install-cozy-stack
docker exec -ti cozy-controller cozy-monitor reinstall-missing-app
```


## Related images

This configuration image was created to work with the following images:

  * [cozy conf](https://github.com/spiroid/cozy-conf)
  * [cozy couchdb data](https://github.com/spiroid/cozy-couchdb-data) 
  * [cozy couchdb](https://github.com/spiroid/cozy-couchdb)
  * [cozy data indexer](https://github.com/spiroid/cozy-data-indexer)


# Inspirations

 * https://forum.cozy.io/t/deployer-cozy-avec-docker-et-des-containers-autonomes/468
