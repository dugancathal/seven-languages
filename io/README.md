# Io

## Day 1

Written in 2002, it's always Io, never IO.

- Rich Concurrency

- Prototypical

- Strongly typed

### Usage

- 'Messages' are sent to 'receivers'. Receiver first, then message

- Objects have 'slots'. Think a dumb hash

- New assignment of slots is done using ':=', reassignment with '='

- Types are uppercased.

- Methods are objects, just like everything else.

  - Create them with method(args)

  - Assign them just like other objects

- You can get the contents of a slot by sending the message, OR with
  #getSlot("slotName")

- You can get an object's prototype with #proto

### Collections

- List - behaves like an array

  - awesomeLanguages := list("Ruby", "Go", "Clojure")

  - respond to #size, #append, #average, #sum, #at(n), #append(i),
    #pop, #isEmpty, #prepend(i)

- Map - take a guess

  - elvis := Map clone

  - respond to #atPut(key, val), #at(key), #asObject, #asList, #keys
    #size

### Control Structures

- Standard booleans (true/false)

- Boolean operators (and/or/<=/>/==, etc.)

- 'true', 'false', and 'nil' are singletons

### Singletons

- Override #clone to return the current Object

  - Highlander clone := Highlander

### Questions

1) Strongly typed - 1 + 'one' BLOWS THE **FUCK** UP

2) 0 is true, "" is true, nil is false

  - 0 and true #=> true

  - "" and true #=> true

  - nil and true #=> false

3) With #slotNames

4) They each compile to something different

  - ::= compiles to newSlot(obj, val)

  - := compiles to setSlot(obj, val)

  - = compiles to updateSlot(obj, val)
