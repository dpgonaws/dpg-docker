#!/bin/sh

NS=esignet

LOCAL_ESIGNET_FILE_NAME=esignet.properties
CHANGED_ESIGNET_FILE_NAME=esignet-local.properties

export ESIGNET_HOST_VALUE=$(kubectl get cm global -n esignet -o jsonpath={.data.mosip-esignet-host})
export API_INTERNAL_VALUE=$(kubectl get cm global -n esignet -o jsonpath={.data.mosip-api-internal-host})
export KEYCLOAK_EXTERNAL_URL_VALUE=$(kubectl get cm global -n esignet -o jsonpath={.data.mosip-iam-external-host})
export SOFTHSM_SECURITY_PIN_VALUE=$(kubectl get secrets softhsm -n softhsm -o jsonpath={.data.security-pin} | base64 --decode)
export AWS_MANAGED_KAFKA_URL=$AWS_KAFKA_ARN
export DB_HOSTNAME_VALUE=$DB_HOSTNAME
export DB_PORT_VALUE=$DB_PORT
export DB_USERNAME_VALUE=$DB_USERNAME
export DB_PASSWORD_VALUE=$DB_PASSWORD
export SBRC_RELEASE_NAME=$SBRC_RELEASE
export SBRC_NAMESPACE=$SBRC_NAMESPACE

export SBRC_ISSUER_ID="did:web:umadeloitte.github.io:DID-Resolve:b3d7b9cc-a79b-4200-bee6-88903781f2ed"
export SBRC_SCHEMA_ID="did:schema:a902c1b1-fc61-4ede-a0c1-9b6ed098360d"


echo "setting namespace\n"
echo $NS

echo "ESIGNET_HOST_VALUE\n"
echo $ESIGNET_HOST_VALUE

echo "API_INTERNAL_VALUE\n"
echo $API_INTERNAL_VALUE

echo "KEYCLOAK_EXTERNAL_URL_VALUE\n"
echo $KEYCLOAK_EXTERNAL_URL_VALUE

echo "SOFTHSM_SECURITY_PIN_VALUE\n"
echo $SOFTHSM_SECURITY_PIN_VALUE

echo "AWS_MANAGED_KAFKA_URL\n"
echo $AWS_MANAGED_KAFKA_URL

echo "DB_HOSTNAME_VALUE\n"
echo $DB_HOSTNAME_VALUE

echo "DB_PORT_VALUE\n"
echo $DB_PORT_VALUE

echo "DB_USERNAME_VALUE\n"
echo $DB_USERNAME_VALUE

echo "DB_PASSWORD_VALUE\n"
echo $DB_PASSWORD_VALUE



envsubst < $LOCAL_ESIGNET_FILE_NAME  > $CHANGED_ESIGNET_FILE_NAME

echo "properties file updated....\n"

kubectl create configmap esignet-local-properties -n $NS  --from-file=$CHANGED_ESIGNET_FILE_NAME



kubectl -n artifactory get configmap artifactory-share -o yaml | sed "s/namespace: artifactory/namespace: $NS/g" |  kubectl -n $NS create -f - 
kubectl -n softhsm get configmap softhsm-share -o yaml | sed "s/namespace: softhsm/namespace: $NS/g" | sed "s/name: softhsm-share/name: softhsm-esignet-share/g"|  kubectl -n $NS create -f -


echo "esignet init setup completed"
