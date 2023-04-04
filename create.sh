#!/usr/bin/env bash

# check to see if we have enough variables
source healthcheck.sh

# do the uploading!
for i in $(cat $INPUT); do
    # skipping the first line (if copied from example.csv)
    if [[ $i == "Name,Tenant" ]]; then
        continue
    fi

    name=$(echo $i | cut -d, -f1)
    tenant=$(echo $i | cut -d, -f2)

    echo Creating $name

    msg=$(cat req.json | \
        sed "s/TNAME/$name/g" | \
        sed "s/TENANT/$tenant/g"
    )

    curl --fail -s -XPOST \
        -u $USER:$PASSWORD \
        -d "$msg" \
        https://console.redhat.com/api/sources/v3.1/bulk_create >/dev/null

    if [[ $? != 0 ]]; then
        echo "Invalid exit code from sources-api: $?"
        exit 1
    fi
done
