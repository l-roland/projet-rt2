#!/bin/bash
#chmod +x classNetwork.sh

#link to netbox service
netbox="https://netbox.lroland.fr/api/"

#url user input
echo "$netbox  <- Insert an url"
read url

#combine netbox service to url and print
link=${netbox}${url}
echo $link;echo

#http request user input
echo "HTTP REQUEST : GET - POST - PATCH - DELETE"
echo "GET - Retrieve an object or list of objects"
echo "POST - Create an object"
echo "PATCH - Modify an existing object"
echo "DELETE - Delete an existing object" 
read request
echo

#if user input = get
if [ $request = "GET" ]
then
    curl -X $request -s $link -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" -H "Content-Type: application/json" -H "Accept: application/json; indent=4" | jq '.'
    exit
fi

#if user input = post
if [ $request = "POST" ]
then
    #classroom number
    echo "Number of the classroom?"
    read classroom

    #number of machines
    echo "How many machines in the classroom?"
    read machine

    #machine per machine
    for num in `seq 1 $machine`; do 
        #ip address 
        ip="10.${classroom}.${num}.1/24"
        curl -X $request $link \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
            -H "Content-Type: application/json" \
            -H "Accept: application/json; indent=4" \
            --data '{
                "address": "'$ip'",
                "assigned_object_type": null,
                "assigned_object_id": null,
                "description": "PC'$num'"
            }'
    done
    exit
fi

#if user input = patch
if [ $request = "PATCH" ]
then
    echo "Insert number of IDs"
    read idnum

    #if id number = 1
    if [ $idnum = "1" ]
    then
        echo "Insert ID"
        read id

        echo "Type here what to modify"
        read opt

        if [ $opt = "RESERVED" ]
        then
            curl -X $request -s ${link}/${id}/ \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
            -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
            --data '{"status": "reserved"}' | jq '.'
        fi

        if [ $opt = "ACTIVE" ]
        then
            curl -X $request -s ${link}/${id}/ \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
            -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
            --data '{"status": "active"}' | jq '.'
        fi
    #if id number !=0
    else
        for k in `seq 1 $idnum`; do
            read -p "Enter number of ID($k) : " idtf[$k]
            echo "Type here what to modify"
            read opt

            if [ $opt = "RESERVED" ]
            then
                curl -X $request -s ${link}/${idtf[$k]}/ \
                -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
                -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
                --data '{"status": "reserved"}' | jq '.'
            fi

            if [ $opt = "ACTIVE" ]
            then
                curl -X $request -s ${link}/${idtf[$k]}/ \
                -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
                -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
                --data '{"status": "active"}' | jq '.'
            fi
        done
    fi
    exit
fi

#if user input = patch
if [ $request = "DELETE" ]
then
    echo "Insert number of IDs"
    read idnum

    #if id number = 1
    if [ $idnum = "1" ]
    then
        echo "Insert ID"
        read id

        curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/${id}/ \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567"
        
        echo Removed
    #if id number !=0
    else
        for l in `seq 1 $idnum`; do
            read -p "Enter number of ID($l) : " ident[$l]
            curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/${ident[$l]}/ \
                -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567"

            echo Removed
        done
    fi
    exit
fi
