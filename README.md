# Build

```
docker build -t spiroid/cozy-controller .
```


# Dependencies

[Cozy CouchDb](https://registry.hub.docker.com/u/spiroid/cozy-couchdb/) and [Cozy Dataindexer](https://registry.hub.docker.com/u/spiroid/cozy-data-indexer/) 


# Run

With docker-compose :

```
controller:
    image: spiroid/cozy-controller
    links:
    - couchdb
    - dataindexer
    volumes_from:
    - couchdb
```

# Init

When the container is running and your cozy cloud instance is not yet initialized, there is an init script to launch.
Given that your container name is cozy-container :

```
  docker exec cozy-container cozy-init.sh
```


# More about updates

```
https://forum.cozy.io/t/deployer-cozy-avec-docker-et-des-containers-autonomes/468
```
