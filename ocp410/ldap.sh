ca_file=$(mktemp)
cat <<EOF >$ca_file
-----BEGIN CERTIFICATE-----
MIIDmzCCAoOgAwIBAgIQRcTZ3+fXNpRDWeqaYUkpzjANBgkqhkiG9w0BAQUFADBg
MRUwEwYKCZImiZPyLGQBGRYFbG9jYWwxFzAVBgoJkiaJk/IsZAEZFgdjbG91ZHJh
MRMwEQYKCZImiZPyLGQBGRYDYW0yMRkwFwYDVQQDExBhbTItTUFSUy1BRERTLUNB
MB4XDTE3MDMwNjE5MzgxOFoXDTI3MDMwNjE5NDgxOFowYDEVMBMGCgmSJomT8ixk
ARkWBWxvY2FsMRcwFQYKCZImiZPyLGQBGRYHY2xvdWRyYTETMBEGCgmSJomT8ixk
ARkWA2FtMjEZMBcGA1UEAxMQYW0yLU1BUlMtQUREUy1DQTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBAMJZ+3GTc3Ic3vhDIQhyKIjxFL6Jhb1H67JBzmA6
+rvbZk8AsB/MPu43sFBDp7ceLdfiIoxmG8JwQpOye+86fh38pXlzrJGmmiJx0OOx
uUJ0HaKWs3z//V20njyjJxNunqArls5eR+BFkqlpGF6naRu2lJ+ncMhbYNwRmiEg
btCLMq+rHGQiYVp7m44PQFfPoussBOdRf1tvWieSsz4IBP0CITCfiv+Ab2S8i5Vx
9d0203k9Faw2NY7/Cx6lfbXCMzlqk2HWZIobBWLqnMqwNQ0J9a3E74v+BIz9XRUy
sZdWV0vuUBQpcHLriXtQhZprU925McUX1hmjBWCud9Y5uYcCAwEAAaNRME8wCwYD
VR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFLvPm4XBF68n6kn3
nEg7RthgpcxqMBAGCSsGAQQBgjcVAQQDAgEAMA0GCSqGSIb3DQEBBQUAA4IBAQCL
OSAsN9rngg4L4i9rqKNhkCyBnjUUbU/UMOUA5nUTHf/F836arYZCvyFRaNQIKC9b
0Idhba0smCeRjGY9PErNixDJTnz+asnqs6+d0QZBbaxY7CXYarlpURgnyAMlOpc5
1kDlq5EVD79x3EarTwCE6/rqFjcUBprE+SHA2TOtMD4eHn5qs3AIQPB79ZH6W0bp
WAFBUzPQyYPnUOQ+LOPuxzWiP0sx2Z2/51yaMnCrF0t3uwRvFmFDR5Kaj6YeAi7M
WtwaYOwMPgUIX93j6PpB8378MKDkA0K8sk3rgnXYG81WUtp6OWp8qkV7Jbe7SR5n
v2blsozytKnLcwEKfhnD
-----END CERTIFICATE-----
EOF
cat $ca_file

config_file=$(mktemp)
cat <<EOF > $config_file
kind: LDAPSyncConfig
apiVersion: v1
url: ldaps://mars-adds.am2.cloudra.local
ca: $ca_file
insecure: false
bindDN: cn=adreader,cn=Users,dc=am2,dc=cloudra,dc=local
bindPassword: Just4m3hp
groupUIDNameMapping:
  "CN=ocpusers,CN=Users,DC=am2,DC=cloudra,DC=local": ocpusers
  "CN=ocpadmins,CN=Users,DC=am2,DC=cloudra,DC=local": ocpadmins
activeDirectory:
  usersQuery:
    baseDN: cn=Users,dc=am2,dc=cloudra,dc=local
    scope: sub
    derefAliases: never
    filter: (objectClass=person)
    pageSize: 0
    insecure: true
  userNameAttributes: [ sAMAccountName ]
  groupMembershipAttributes: [ memberOf ]
EOF
cat $config_file

oc adm groups sync --sync-config=active_directory_config.yml     'CN=ocpadmins,CN=Users,DC=am2,DC=cloudra,DC=local' --confirm
oc adm groups sync --sync-config=active_directory_config.yml     'CN=ocpusers,CN=Users,DC=am2,DC=cloudra,DC=local' --confirm
oc adm policy add-cluster-role-to-group cluster-admin ocpadmins
