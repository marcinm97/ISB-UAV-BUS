#!/bin/bash
docker run --detach --name builder -v "$(pwd):/ISB" -t thematiq/solar-bus:3 > /dev/null
docker exec builder ./docker_builder.sh
docker stop builder > /dev/null
docker rm builder > /dev/null
echo "Closed docker container"