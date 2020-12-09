#using boto module to communicate with AWS.
import boto3
import json
#autheticating with AWS using below parameters.
ec2 = boto3.client('ec2', aws_access_key_id="XXXXXXX", aws_secret_access_key="YYYYYY", region_name="us-east-2")
#Listing the instances that arew avialble in the AS account based on the parameters provided.
list_inst = ec2.describe_instances()
#Printing the Complete metadata of the instances in json format.
print json.dumps(list_inst,indent=4, sort_keys=True, default=str)
#storing the Instance Info into variable as dictionary
abc = list_inst
#using the key to iterate in the dictionary
key = "ResponseMetadata/HTTPHeaders"
#using split function to separate the keys and using it for further iterations
new_key = key.split("/")
#looping the separated key with the dictionary
for item in new_key:
#checking if the given key present in the dictionary
    if item in abc:
       abc = abc[item]
    else:
#coming out of loop in case of key not present in the given dictionary
        break
print "\n\n\n"
#Printing the Data of the particular data key in Json format.
print json.dumps(abc,indent=4, sort_keys=True, default=str)
