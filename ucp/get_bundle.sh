#
# Retrieve the admin client bundle
#
script_dir=$(dirname $0)
. ${script_dir}/mycloud.rc

#
# Create the Certificates directory if it does not exists
#
[ ! -d $CERTS_DIR ] && mkdir $CERTS_DIR

#
# Retrive a token for the API
#
token=$(curl -k -s -X POST "https://$UCP_IP/id/login" -H  "accept: application/json" -H  "content-type: application/json" -d "{\"username\": \"${UCP_ADMIN}\",\"password\": \"${UCP_PASSWORD}\"}" | jq -r .sessionToken)

#
# Get  the client bundle
#
curl -k -s -H "Authorization: Bearer $token" https://$UCP_IP/api/clientbundle -o $CERTS_DIR/bundle.zip
( cd $CERTS_DIR ; unzip -o bundle.zip)

#
# Say hello
#
echo Your certificates are in $CERTS_DIR
