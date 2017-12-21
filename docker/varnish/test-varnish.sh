#!/usr/bin/env sh

curl -X BAN "http://varnish/" --silent -H "ApiPlatform-Ban-Regex: (^|\,)/foos($|\,)" > /dev/null
firstCall=`curl -X GET "http://varnish/foos" --silent -H  "accept: application/ld+json" -I | grep -Fi "ApiPlatform-Cache-Hits: 0"`
if [ -z "$firstCall" ]
    then echo 'First call must be MISS'; exit 1
fi

secondCall=`curl -X GET "http://varnish/foos" --silent -H  "accept: application/ld+json" -I | grep -Fi "ApiPlatform-Cache-Hits: 1"`
if [ -z "$secondCall" ]
    then echo 'Second call must be HIT 1'; exit 1
fi

thirdCall=`curl -X GET "http://varnish/foos" --silent -H  "accept: application/ld+json" -I | grep -Fi "ApiPlatform-Cache-Hits: 2"`
if [ -z "$thirdCall" ]
    then echo 'Third call must be HIT 2'; exit 1
fi

curl -X BAN "http://varnish/" --silent -H "ApiPlatform-Ban-Regex: (^|\,)/foos($|\,)" > /dev/null
newCall=`curl -X GET "http://varnish/foos" --silent -H  "accept: application/ld+json" -I | grep -Fi "ApiPlatform-Cache-Hits: 0"`
if [ -z "$newCall" ]
    then echo 'New call after BAN must be MISS'; exit 1
fi