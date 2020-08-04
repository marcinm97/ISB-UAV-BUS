@echo off
docker run --detach --name builder -v %cd%:/ISB -t thematiq/solar-bus:3 > nul
docker exec builder ./docker_builder.sh
docker stop builder > nul
docker rm builder > nul
echo Closed docker container