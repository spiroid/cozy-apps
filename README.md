# Build:
```
docker build -t obigroup/cozy-cozyapps .
```

# Run:
Dependencies : [Cozy CouchDb](https://registry.hub.docker.com/u/obigroup/cozy-couchdb/) and [Cozy Dataindexer](https://registry.hub.docker.com/u/obigroup/cozy-dataindexer/) 
With fig :
```
cozyapps:
    image: obigroup/cozy-cozyapps
    links:
    - couchdb
    - dataindexer
    volumes_from:
    - couchdb
```

#More about updates
```
https://forum.cozy.io/t/deployer-cozy-avec-docker-et-des-containers-autonomes/468
```