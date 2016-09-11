# Vapor Todo Backend

Run the specs [here](https://todo-backend-vapor.herokuapp.com)

[Vapor](https://github.com/vapor/vapor) is a Swift backend framework to build server-side applications in Swift.

[TodoBackend](http://www.todobackend.com) is a proof-of-concept catalog to demonstrate the implementation of the same simple API using different backend frameworks.

This project is a TodoBackend implementation using Vapor, Swift and MySQL as a backend stack.

## Requirements

- Swift 3.0 Gold Master
- MySQL Database Credentials

## Setup

### Swift 3.0

Download latest Xcode 8 and make sure it's been opened at least once. Also make sure command line tools are set to Xcode 8 in Xcode's preferences.

> Xcode > Preferences > Locations > Command Line Tools

### MySQL Config

To build, the first place you'll want to look is the `Config/` directory. In their, you should create a `secrets` folder and a nested `mysql.json`. Here's how my `Config/` folder looks locally.

```
Config/
  - mysql.json
	secrets/
	  - mysql.json
```

The `secrets` folder is under the gitignore and shouldn't be committed.

Here's an example `secrets/mysql.json`

```json
{
  "host": "z99a0.asdf8c8cx.us-east-1.rds.amazonaws.com",
  "user": "username",
  "password": "badpassword",
  "database": "databasename",
  "port": "3306",
  "encoding": "utf8"
}

```

### Vapor CLI

The Vapor Command Line Interface makes it easy to build and run Vapor projects. Install it on Mac by running

#### Brew

```sh
brew install vapor/tap/toolbox
```

#### Curl

```sh
curl -sL toolbox.vapor.sh | bash
```

## Deploy

When deploying, one may optionally include the `secrets` folder if they have a secure way of doing so. The official deploy is done through use of environment variables configured on the server that match the following scheme.

```
{
  "host": "$MYSQL_HOST",
  "user": "$MYSQL_USER",
  "password": "$MYSQL_PASS",
  "database": "$MYSQL_DB",
  "port": "$MYSQL_PORT",
  "encoding": "utf8"
}

```

Checkout [more documentation here](https://vapor.github.io/documentation/)

## Thanks

A great deal of work on this library was originally done by @sarbogast. Thanks 🙌
