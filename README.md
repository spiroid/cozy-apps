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

With docker-compose:

```
configuration:
    image: spiroid/cozy-conf

couchdata:
    image: spiroid/cozy-couchdb-data

couchdb:
    image: spiroid/cozy-couchdb
    volumes_from:
        - couchdata
        - configuration
    volumes:
        - $HOME/cozy-cloud/var/log/couchdb:/var/log/couchdb

dataindexer:
    image: spiroid/cozy-data-indexer
    hostname: dataindexer
    volumes_from:
        - configuration

controller:
    image: spiroid/cozy-controller
    links:
        - couchdb
        - dataindexer
    volumes_from:
        - configuration
        - dataindexer
    volumes:
        - $HOME/cozy-cloud/var/log/cozy:/usr/local/var/log/cozy
    ports:
        - "127.0.0.1:9002:9002"
```

replace $HOME by your actual home directory

## Init the cozy stack

When the container is running and your cozy cloud instance is not yet initialized, there is an init script to launch.
Given that your container name is cozy-container :

```
  docker exec cozy-container cozy-init.sh
```

This installs the Home, Data-System and proxy applications.


## Related images

This configuration image was created to work with the following images:

  * [cozy conf](https://github.com/spiroid/cozy-conf)
  * [cozy couchdb data](https://github.com/spiroid/cozy-couchdb-data) 
  * [cozy couchdb](https://github.com/spiroid/cozy-couchdb)
  * [cozy data indexer](https://github.com/spiroid/cozy-data-indexer)


# Inspirations

 * https://forum.cozy.io/t/deployer-cozy-avec-docker-et-des-containers-autonomes/468
