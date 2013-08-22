# Enis

some sort of configuration thing.

## Example

this:

```
shared_database_config {
  database_server -> 'localhost'
  database_port -> 4032,
  database_user -> 'root',
  database_password -> 'powpow'
}

dev <- shared_database_config {
  database_name -> 'dev'
}

stage <- shared_database_config {
  database_server -> 'stage-server'
  database_name -> 'stage'
  database_password -> 'onlyonepow'
}
```

turns into a JSON object that looks like:

```
{
  "shared_database_config": {
    "database_server": "localhost",
    "database_port": 4032,
    "database_user": "root",
    "database_password": "powpow"
  },
  "dev": {
    "database_server": "localhost",
    "database_port": 4032,
    "database_name": "dev",
    "database_user": "root",
    "database_password": "powpow"
  },
  "stage": {
    "database_server": "stage-server",
    "database_port": 4032,
    "database_name": "stage",
    "database_user": "root",
    "database_password": "onlyonepow"
  }
}
```

## This is the dumbest thing i've ever seen

yeah.

## What's so special about this?

here are a few things:

- trailing whitespace in a config file? *ERROR!@!!!!*
- inherit properties from other objects
- want to override an inherited property with a different type? *NOT GOING TO HAPPEN, BUDDY!! THATS AN ERROR!*
- 5 types:
  - integers
  - boolean
  - strings (single quoted)
  - references (to other top level blocks)
  - blocks (can contain properties)

that's basically it... it's nothing special

## Install

```
npm i enis
```

## Usage

```
enis = require 'enis'

result = enis.compile """
  pow {
    pow -> 'pow'
    whammy -> {
      number -> 123
    }
  }
  """
```

## Anything else?

I'm sure there are tons of bugs...

