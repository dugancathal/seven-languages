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

  - `awesomeLanguages := list("Ruby", "Go", "Clojure")`

  - respond to #size, #append, #average, #sum, #at(n), #append(i),
    #pop, #isEmpty, #prepend(i)

  - `awesomeLanguages include("Scala")`

- Map - take a guess

  - `elvis := Map clone`

  - respond to #atPut(key, val), #at(key), #asObject, #asList, #keys
    #size

### Booleans

- Standard booleans (true/false)

- Boolean operators (and/or/<=/>/==, etc.)

- 'true', 'false', and 'nil' are singletons

### Singletons

- Override #clone to return the current Object

  - `Highlander clone := Highlander`

### Questions

1) Strongly typed - `1 + 'one'` BLOWS THE **FUCK** UP

2) 0 is true, "" is true, nil is false

  - `0 and true` #=> true

  - `"" and true` #=> true

  - `nil and true` #=> false

3) With #slotNames

4) They each compile to something different

  - `::=` compiles to `newSlot(obj, val)`

  - `:=` compiles to `setSlot(obj, val)`

  - `=` compiles to `updateSlot(obj, val)`

## Day 2

### Looping

You can loop forever with `loop("doing stuff" println)`.

`while` loops look kind of like traditional `for` loops

    i := 1
    while(i <= 11, i println; i = i + 1); "This goes to 11" println

But there are `for` loops, too!

    for(i, 1, 11, i println); "This does the same thing!" println
    #with an increment
    for(i, 1, 11, 2, i println); "I print odds" println

### Conditionals

If statement make you feel like it's the good 'ole days of 95 in Excel.

    if(true, "Got it", "NOPE") # => Got it
    if(false) then("Uh ...") else("Heh.") # => Heh.

### Operator Overloading

You thought that you couldn't get enough of it in C ... Look ma! "==" now does
multiplication! View all operators with `OperatorTable`.

Let's define `xor`:

    OperatorTable addOperator("xor", 11) # second arg is precedence
    true xor := method(bool, if(bool, false, true))
    false xor := method(bool, if(bool, true, false))

    true xor true # false
    true xor false # true
    false xor true # true
    false xor false # true

### It's messages all the way down (almost)

Everything but commas (,) and octithorpes are messages.

The `call` message lets you inspect messages.

    postOffice := Object clone
    postOffice packageSender := method(call sender)
    mailer := Object clone
    mailer deliverTo := method(office, office packageSender)
    mailer deliverTo(postOffice) # => mailer

Io passes the message and makes the receiver evaluate it.

    unless := method(
      (call sender doMessage(call message argAt(0))) ifFalse(
      call sender doMessage(call message argAt(1))) ifTrue(
      call sender doMessage(call message argAt(2)))
    )

    unless(1 == 2, write("One is not two\n"), write("One is two?\n"))

`doMessage` is "like Ruby's eval but at a lower level". It interprets the
message parameters, but delays binding and execution.

    westley := Object clone
    westley trueLove := true
    westley princessButtercup := method("Do things" println)
    westley princessButtercup unless(trueLove, "It is false", "It is true")
    # => "It is true"

### Reflection

    Object ancestors := method(
      prototype := self proto;
      if(prototype != Object,
      writeln("Slots of ", prototype type, "\n----------");
      prototype slotNames foreach(slotName, writeln(slotName));
      writeln;
      prototype ancestors))

    Animal := Object clone
    Animal speak := method("ambiguous noise" println)

    Duck := Animal clone
    Duck speak := method("quack" println)
    Duck walk := method("waddling ..." println)

    disco := Duck clone
    disco ancestors
