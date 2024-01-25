#TODO

Usage:
1. send file
   dart bin/at_file_share.dart -m send -s <sender_atsign> -r <receiver_atsign> -k <path_to_sender_atKeys_file> -f <path_of_file_to_send>
2. receive file
   dart bin/at_file_share.dart -m receive -k <path_to_receiver_atKeysFile> -r <current_atsign> -d <download_path>