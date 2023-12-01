Sample client and server programs demonstrating use of the AtRpc library in 
the at_client package

Sample command lines:
- client: `dart bin/arithmetic_client.dart -a @alice -n at_rpc_demo 
  --server-atsign @bob`
- server: `dart bin/arithmetic_server.dart -a @bob -n at_rpc_demo --allow-list 
  @alice`
