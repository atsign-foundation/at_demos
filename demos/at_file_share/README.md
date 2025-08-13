# Sharing large files

An example of how to share large files, which uses atProtocol for key exchange
and messaging, and [Storj](https://www.storj.io/) for file storage.

## Instructions

### Storj account and access grant

    1. Login/signup to https://www.storj.io/
    2. Create new project e.g acme_demo
    3. Open the newly created project
    4. Go to buckets https://us1.storj.io/buckets/management and create new
       bucket e.g. demo-bucket
    5. Go to access tab https://us1.storj.io/access-grants and click "create
       access grant"
        1. Give a name to identify the access e.g. acme-access. Click continue
        2. Under bucket select the bucket that you created i.e. demo-bucket
        3. Create/enter a passphrase and click "create access". Click confirm
        4. Download the credentials file(acme-access.txt) by clicking "Download"

### Configure uplink

    1. Follow the instructions to install uplink
       tool - https://docs.storj.io/learn/tutorials/quickstart-uplink-cli
    2. Run the following command with the credentials file downloaded:
       `uplink access import main acme-access.txt`

### Run the receiver and sender

**Note:** Assumes you already have atsigns and their keys are in the default
location i.e. $HOME/.atsign/keys. If not then add the
`-k <path to atKeys file>` argument to the command lines below.

#### Run the file receiver

   ```
   dart bin/at_file_share.dart -m receive \
     -a <receiver atsign> -n <namespace> \
     -o <download path>
   ```

#### Run the file sender

  ```
  dart bin/at_file_share.dart -m send -a <sender atsign> \
    -r <receiver atsign> -n <namespace> \
    -f <path of file to send> -b <storj bucket name>
  ```
