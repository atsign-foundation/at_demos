#TODO

Prerequisite:
1. Storj account and s3 access/secret keys
   1. Login/signup to https://www.storj.io/
   2. Create new project e.g zetta_demo
   3. Open the newly created project
   4. Go to buckets https://us1.storj.io/buckets/management and create new bucket e.g demo-bucket
   5. Go to access tab https://us1.storj.io/access-grants and click "create access grant"
      6. Type --> "Access Grant" and give a name to identify the access e.g zetta-access. Click continue
      7. Under bucket select the bucket that you created i.e demo-bucket
      8. Create/enter a passphrase and click "create access".Click confirm
      9. Download the credentials file(zetta-access.txt) by clicking "Download" 
2. Configure uplink
   1. Follow the instructions to install uplink tool - https://docs.storj.io/learn/tutorials/quickstart-uplink-cli
   2. Run the below command with the credentials file downloaded 
      3. uplink access import main zetta-access.txt
3. Run file sender on sending machine and file receiver on receiving machine. File receiver will receive notification through
   atprotocol and download the storj file, decrypt using atClient SDK method.

Usage: 
1. File sender
   1. dart bin/at_file_share.dart -m send -s <sender_atsign> -r <receiver_atsign> -k <path_to_sender_atKeys_file> -f <path_of_file_to_send> -b <storj_bucket_name> -e <dev|prod>
   2. e.g. dart bin/at_file_share.dart -m send -s @alice -r @bob -k /home/user/@alice.atKeys -f /home/user/test_file.txt  -b demo-bucket -e dev
2. File receiver 
   1. dart bin/at_file_share.dart -m receive -k <path_to_receiver_atKeysFile> -r <current_atsign> -d <download_path> -e <dev|prod>
   2. e.g dart bin/at_file_share.dart -m receive -k /home/user/@bob.atKeys -r @bob -d /home/user/downloads -e dev