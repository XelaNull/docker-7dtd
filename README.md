


# STEP 1: BUILD DOCKER IMAGE
```
time docker build -t docker-7dtd .
```

# STEP 2: RUN DOCKER IMAGE
Pick a method to run the docker image. Note that when you run it for the first time, it'll take some time to download the game server.

## MANUALLY RUN
```
docker run -dt -v$(pwd)/data:/data --name=docker-7dtd docker-7dtd
```

## RUN VIA DOCKER-COMPOSE.YML
```
```

# EXAMINE RUNNING DOCKER LOGS
You can examine the server's logs with the command below.
```
docker logs docker-7dtd --follow
```
