# Programmable Policy Demo

This demo is composed of several components, all of which join to create a
real-time simulation of a network with a programmable policy algorithm.

## Demo components

### Nodes

Nodes invoked by the service. In this demo, these nodes are processes
running, but the only external communication is with their own atServer.
In a real environment these nodes could either be provisioned by any regular
means.

There are three types of nodes:

- server
- agent
- client

#### Server nodes

There are four server nodes, they are color coded and each represents a
different type of service. For the purposes of the demo these services have
been kept very simple.

- red: when sent "ping", responds with "pong"
- orange: a basic calculator which responds with the result when sent a math
  expression
- yellow: when sent a request responds with some randomly generated IoT data
- green: performs a dice roll and responds with the result of the roll

##### Red Node

Takes a request with a payload of:

```json
{
  "message": "ping"
}
```

Responds with

```json
{
  "message": "pong"
}
```

##### Orange Node

Takes a request with a payload of:

```json
{
  "expression": "<math expression string>"
}
```

Responds with:

```json
{
  "result": "<result of math expression>"
}
```

##### Yellow Node

Takes a request with empty payload: `{}`.

Responds with:

```json
{
  "temp": "<random float [-30:30]>",
  "humidity": "<random float [0:1]>"
}
```

##### Green Node

Takes a request with a payload of:

```json
{
  "dice-size": "<optional: positive integer>"
}
```

Responds with:

```json
{
  "result": "<positive integer>"
}
```

#### Agent nodes

The agent node may act as both a client and a server. It acts as a server
when speaking with clients, and it acts as a client when speaking with servers.

- violet: an LLM service which takes natural language and uses the orange and
  green services to randomly generate numbers (by rolling the dice with green)
  and compute math expressions (by using orange). The service then responds
  with the result in natural language.

- blue: coming soon

#### Client nodes

There is one type of client node, which takes a list of colors, these are the
types of requests that the client will make with the system.

Client nodes in this demo are simulated, and will periodically make requests
to services that match the configured colors until shutdown.

## Main Demo Driver

A Flutter application serves multiple roles for the sake of the demo.

On the main thread (the application itself), it serves as a front end for
displaying the graph of the network simulation.

On a second thread, in the background, the application also spins up:

- A policy service
- A simulation service

### Flutter application

The Flutter application receives a list of events that occur in the simulated
environment and updates the graph accordingly. The application also receives
logs from all of the nodes and stores them so they can be viewed on a second
screen.

### Policy Service

The policy service takes two kinds of queries:

- Request access: for requesting access to a system / system type
- Check access: for looking up with a particular atSign has the right to access a
  particular node

#### Request Access Query

The request access query is used by clients (and agents acting as clients) to
request access to a particular service or service type.

The intent string is `"request"`.

The request payload schema looks like:

```json
{
  "atsign": "<String?>",
  "color": "<String?>",
  "expiry": "<int?>"
}
```

One of either `atsign` or `color` must be provided, if both are provided, then
`atsign` takes priority.

Expiry is an optional timestamp (as milliseconds since epoch) which represents
when the grant will expire. The default expiry (if the grant is accepted)
is 30 minutes from when the policy service processes the request.

The response payload schema for an accepted access request looks like:

```json
{
  "granted": true,
  "atsign": "<String>",
  "expires": "<int>"
}
```

The response payload schema for a rejected access request looks like:

```json
{
  "granted": false
}
```

#### Check Access Query

The check access query is used by servers (and agents acting as servers) to
check access for a particular client which has queried it.

The intent string is "check".

The request payload schema is empty `{}`.

> All of the information required by the policy service is automatically
> provided outside of the payload.

The response payload schema for an accepted check request looks like:

```json
{
  "granted": true,
}
```

The response payload schema for a rejected check request looks like:

```json
{
  "granted": false
}
```

### Simulation Service

The simulation service drives the demo, it randomly creates and removes nodes
from the system. In a real-world environment, this service would not exist.
It only serves the purpose of simulating people and machines interacting with
the network environment.

### atServers Virtual Environment

The atServers Virtual Environment is contained under [setup/](./setup). To start
the virtual environment for the first time, the [setup.sh](setup/setup.sh)
script can be run. It will provision a virtual environment, then activate
the atkeys and store them in [setup/keys/](./setup/keys/).

If the environment is already running and you would like to re-provision it,
run [reset.sh](./setup/reset.sh).

If either `setup.sh` or `reset.sh` fails to generate a set of keys, run
[generate_keys.sh](./setup/generate_keys.sh), this will attempt to activate
any of the atSigns for which there are not keys.
