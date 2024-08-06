# at_rpc_demo

Sample client and server programs demonstrating use of the at_client
package's AtRpc library

- Simple 'arithmetic' service. "Client" program `@alice` sends an
  arithmetical expression to the "server" program `@bob`; server
  evaluates the expression and returns the result.
    - client:
      `dart bin/arithmetic_client.dart -a @alice
      --server-atsign @bob -n at_rpc_demo`
    - server:
      `dart bin/arithmetic_server.dart -a @bob
      --allow-list @alice -n at_rpc_demo`
- Simple 'permission check' sample. "Client" program `@alice` sends a request
  to the server asking, 'can I send messages to $someAtSign?'. The server will
  respond with `true` or `false`. The demo code responds with `true` if
  $someAtSign starts with `@c` and `false` otherwise
    - client:
      `dart bin/permission_check_client.dart -a @alice
      --server-atsign @bob -n at_rpc_demo`
    - server:
      `dart bin/permission_check_server.dart -a @bob
      --allow-list @alice -n at_rpc_demo`
