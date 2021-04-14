#!/bin/bash

#link to netbox service
netbox="https://netbox.lroland.fr/api/"

#url user input
echo "Insert an url"
read -p "$netbox" url

#combine netbox service to url and print
link=${netbox}${url}
echo

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
    read -p "Classroom number? " classroom;echo

    #number of machines
    read -p "How many machines? " machine;echo

    #machine per machine
    for num in `seq 1 $machine`; do 
        #ip address 
        ip="10.${classroom}.${num}.1/24"

        #send to netbox
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
    #insert id number
    read -p "Insert number of IDs : " idnum

    #if id number = 1
    if [ $idnum = "1" ]
    then
        #insert id
        read -p "Insert ID : " id;echo

        #what object to change
        read -p "Type here what to modify : " opt;echo

        #if user input = R -> "status": "reserved"
        if [ $opt = "R" ]
        then
            #send to netbox
            curl -X $request -s ${link}/${id}/ \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
            -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
            --data '{"status": "reserved"}' | jq '.'
        fi

        #if user input = A -> "status": "active"
        if [ $opt = "A" ]
        then
            #send to netbox
            curl -X $request -s ${link}/${id}/ \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
            -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
            --data '{"status": "active"}' | jq '.'
        fi

    #if id number !=1
    else
        #for 1 to id number
        for k in `seq 1 $idnum`; do
            #user input id
            read -p "ID($k) : " idtf[$k];echo

            #what object to change
            read -p "Type here what to modify : " opt;echo

            #if user input = R -> "status": "reserved"
            if [ $opt = "R" ]
            then
                #send to netbox
                curl -X $request -s ${link}/${idtf[$k]}/ \
                -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567" \
                -H "Content-Type: application/json" -H "Accept: application/json; indent=4" \
                --data '{"status": "reserved"}' | jq '.'
            fi

            #if user input = A -> "status": "active"
            if [ $opt = "A" ]
            then
                #send to netbox
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
    #user input id number
    read -p "Insert number of IDs : " idnum;echo

    #if id number = 1
    if [ $idnum = "1" ]
    then
        #user input id
        read -p "ID : " id

        #send to netbox
        curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/${id}/ \
            -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567"
        
        #print removed
        echo Removed

    #if id number !=1
    else
        #for 1 to id number
        for l in `seq 1 $idnum`; do
            #user input id
            read -p "ID($l) : " ident[$l]

            #send to netbox
            curl -X DELETE -s https://netbox.lroland.fr/api/ipam/ip-addresses/${ident[$l]}/ \
                -H "Authorization: Token 0123456789abcdef0123456789abcdef01234567"

            #print removed
            echo Removed
        done
    fi
    exit
fi
