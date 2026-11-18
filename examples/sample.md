---
title: Typed configuration *without* the ceremony
subtitle: How Iron refinement types catch bad settings at compile time, and what it costs.
kicker: Article · Scala 3
author: Raphaël Lemaitre
date: 2026-10-17
lang: en
---

Most configuration bugs are not logic bugs. A port set to `-1`, an empty URL, a timeout in seconds read as
milliseconds: the program compiles, starts, and fails at the worst moment.[^1]

## The problem

Configuration arrives as text. We parse it into types that are **too wide**: an `Int` accepts every port number and
every nonsense value. Validation then lives in scattered `require` calls, and nobody knows which ones ran.

- Values are checked late, at runtime
- Checks are duplicated across services
- Errors name the field, not the rule that broke

## Refinement types

A refined type carries its constraint. The compiler checks literals; the parser checks everything else, once, at the
boundary.

```scala
import io.github.iltotore.iron.*
import io.github.iltotore.iron.constraint.numeric.*

type Port = Int :| Interval.Closed[1, 65535]

// Rejected at compile time: -1 is not a valid port.
val admin: Port = 8080
def parse(raw: String): Either[String, Port] = raw.toIntOption.toRight("not a number").flatMap(_.refineEither)
```

### What changes for the team

> A type that cannot hold a bad value is a test that never needs to run.

| Approach         | When it fails | Where the rule lives |
|------------------|---------------|----------------------|
| `require` checks | Runtime       | Scattered            |
| Smart constructors | Runtime     | One file per type    |
| Refinement types | Compile time  | The type itself      |

## Costs

1. Compile times grow with heavy inline constraints
2. Error messages need a custom renderer for users
3. Everyone on the team must read `:|` fluently

---

Français aussi : « les types raffinés » réduisent les erreurs de configuration, même en production où l’œil ne voit rien.

[^1]: Usually on a Friday evening, during a deploy nobody else is watching.
