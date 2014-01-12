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

  - respond to #size, #append, #average, #sum, #at(n), #append(i), #pop, #isEmpty, #prepend(i)

  - `awesomeLanguages include("Scala")`

- Map - take a guess

  - `elvis := Map clone`

  - respond to #atPut(key, val), #at(key), #asObject, #asList, #keys, #size

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

## Day 3 - DSLs are apparently a big thing

So, apparently, you can implement a subset of C in Io in 40 lines...

The `curlyBrackets` message is called whenever the parser encounters `{}`.

### Parsing XML in Io

Suppose you have:

    <body>
      <p>
        This is a paragraph
      </p>
    </body>

And you want to represent this in Io (LispML for those that are following
along).

    body(
      p("This is a paragraph")
    )

You can do this pretty easily... (remember, I prefaced that with a "pretty").

    Builder := Object clone
    Builder forward := method(
      tagName := call message name;
      writeln("<", tagName, ">");
      call message arguments foreach(arg,
        content := self doMessage(arg);
        if(content type == "Sequence", wri teln(content)));
      writeln("</", tagName, ">"))
    Builder body(p("This is a paragraph"))

The key takeaways from that are:

    - The `forward` message is basically like Ruby's `method_missing`

    - We just redefined inheritance for the subObject Builder

### Concurrency - This is when shit gets real

Built of three main components - coroutines, actors, and futures.

#### Coroutines

A coroutine provides a way to voluntarily suspend and resume execution of a
process. Think of this as a block with multiple `yield`s that all suspend the
process and transfer control to another process.

Before a message: 

  - `@` returns a future and starts a coroutine (e.g. obj @mes)

  - `@@` returns nil and starts the coroutine (e.g. obj @@mes)

You can call methods that start coroutines and release control from the current
coroutine with `Coroutine currentCoroutine pause`. Then, in your methods,
`yield` passes control to another waiting coroutine.

#### Actors

Think of actors as concurrent primitives that send messages, process messages,
and create more actors.

An actor can only change its own state and only accesses other actors through
message queues. Sending an async message to _ANY_ object makes it into an actor.

    slower := Object clone
    faster := Object clone
    slower start := method(wait(2); writeln("Slow and steady wins the race"))
    faster start := method(wait(1); writeln("Not if I get there first!"))

#### Futures

A future is a resultant object that immediately comes back from an async call.
The future will become the result of the message when the result is available.
If you ask for the value before it's ready, the process will block until such a
time as it can give you back the value.

    futureResult := URL with("http://google.com") @fetch
    writeln("Doing something else")
    writeln("This will block ....")
    writeln("Fetched ", futureResult size, " bytes")

Futures also provide deadlock detection ... apparently.
