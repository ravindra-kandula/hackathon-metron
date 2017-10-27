import boto3

ec2 = boto3.resource('ec2', region_name="ohio")
outfile = open('TestKey.pem','w')
key_pair = ec2.create_key_pair(KeyName='TestKey')
KeyPairOut = str(key_pair.key_material)
outfile.write(KeyPairOut)

instances = ec2.create_instances(
    ImageId='', 
    MinCount=1, 
    MaxCount=1,
    KeyName="TestKey",
    InstanceType="m4.xlarge"
)

ssh -i TestKey.pem 'git clone https://github.com/ravindra-kandula/hackathon-metron;cd hackathon-metron;./setup.sh'

