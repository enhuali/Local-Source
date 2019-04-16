#!/bin/bash
docker rm -f apt-mirror
docker run --name apt-mirror -p 80:80 -itd registry:5000/library/apt-mirror
