# at_rpc_demo

Sample client and server programs demonstrating use of the at_client
package's AtRpc library

- Simple 'arithmetic' service. "Client" program `@alice` sends an
  arithmetical expression to the "server" program `@bob`; server
  evaluates the expression and returns the result.
  - client:
  `dart bin/arithmetic_client.dart -a @alice -n at_rpc_demo --server-atsign @bob`
  - server:
  `dart bin/arithmetic_server.dart -a @bob -n at_rpc_demo --allow-list @alice`
