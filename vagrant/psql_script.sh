#!/bin/bash

colname="mz_ion"
value=1
margin=1

while [ "$1" != "" ]; do
    case $1 in
        -c | --column )         shift
                                colname=" $1 "
                                ;;
        -v | --value )          shift
                                value=$1
                                ;;
        -m | --margin )         shift
                                margin=$1
                                ;;
        * )                     echo "Unknown parameter $1"
                                exit
    esac
    shift
done

# Iterate over resource ids concatenated with their package ids
for id in $(curl -s -H'Authorization: tester' 'http://localhost/api/action/current_package_list_with_resources' | jq -r '.result[] | .name + ";" +(.resources[] | .id)')
do 
    # Split the id into resource and dataset
    package_name=$(echo $id | cut -d ";" -f 1)
    resource_id=$(echo $id | cut -d ";" -f 2)
    
    # echo $resource_id
    # echo $package_id
    
    # echo $(sudo -u postgres psql -t -d "datastore_default" -c "\d $resource_id")
    
    # Get column names
    if sudo -u postgres psql -t -d "datastore_default" -c "\d $resource_id" | grep -q $colname; then
        if test $(sudo -u postgres psql -t -d "datastore_default" -c " 
        SELECT CAST( 
            CASE WHEN 
                EXISTS(SELECT $colname FROM \"$resource_id\" WHERE $colname BETWEEN $value - $margin AND $value + $margin) THEN 1 
            ELSE 0 
            END 
        AS BIT)") = 1
        then
            echo "http://192.168.19.97/dataset/$package_name/resource/$resource_id"
        fi
    fi
    
done 