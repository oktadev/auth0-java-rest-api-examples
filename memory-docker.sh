#!/bin/bash
for i in {1..10}
do
    curl localhost:8080/hello -i --header "Authorization: Bearer $TOKEN"
done
printf "\n"
docker stats --no-stream
