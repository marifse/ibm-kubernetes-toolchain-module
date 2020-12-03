#!/usr/bin/env bash

#// https://github.com/open-toolchain/sdk/wiki/Toolchain-Creation-page-parameters#headless-toolchain-creation-and-update

# log in using the api key
ibmcloud login --apikey "$API_KEY" -r "$REGION" 

# get the bearer token to create the toolchain instance
IAM_TOKEN="IAM token:  "
BEARER_TOKEN=$(ibmcloud iam oauth-tokens | grep "$IAM_TOKEN" | sed -e "s/^$IAM_TOKEN//")
#echo $BEARER_TOKEN

# prefix region for toolchains
TOOLCHAIN_REGION=$REGION
if [[ ! $TOOLCHAIN_REGION =~ "ibm:" ]]; then
  export TOOLCHAIN_REGION="ibm:yp:$REGION"
fi

RESOURCE_GROUP_ID=$(ibmcloud resource group $RESOURCE_GROUP --output JSON | jq ".[].id" -r)

PARAMETERS="region_id=$TOOLCHAIN_REGION&resourceGroupId=$RESOURCE_GROUP_ID&autocreate=true&repository=$TOOLCHAIN_TEMPLATE_REPO&sourceZipUrl=$APPLICATION_REPO&app_repo=$APPLICATION_REPO&apiKey=$API_KEY&registryRegion=$REGION&registryNamespace=$CONTAINER_REGISTRY_NAMESPACE&prodRegion=$REGION&prodResourceGroup=$RESOURCE_GROUP&prodClusterName=$CLUSTER_NAME&prodClusterNamespace=$CONTAINER_REGISTRY_NAMESPACE&toolchainName=$TOOLCHAIN_NAME"
#echo $PARAMETERS

curl -i -o output.json -X POST \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Accept: application/json' \
  -H "Authorization: $BEARER_TOKEN" \
  "https://cloud.ibm.com/devops/setup/deploy?env_id=$TOOLCHAIN_REGION&$PARAMETERS"

cat output.json
LOCATION=$(grep Location output.json | awk {'print $2'})
echo "The toolchain is here: $LOCATION"

exit 0;
