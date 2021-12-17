#!/bin/bash

response=$(curl --write-out '%{http_code}' --silent --output /dev/null http://host.docker.internal:3142/acng-report.html)
echo "Response is: ${response}"

if [[ "${response}" -ne "200" ]]
then
    echo "Health check failed"
    exit 1    
fi

echo "Response success"

sudo sh -c 'echo "Acquire::HTTP::Proxy \"http://host.docker.internal:3142\";" > /etc/apt/apt.conf.d/02proxy'
sudo sh -c 'echo "Acquire::HTTPS::Proxy \"false\";" >> /etc/apt/apt.conf.d/02proxy'

time sudo apt update

content=$(curl --silent http://host.docker.internal:3142/acng-report.html)


