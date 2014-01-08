#!/usr/bin/env io

# Run from a file

"test" println

# Execute the code in a slot given its name

Mac := Object clone

Mac boot := method("done" println)
Mac initialize := method(
  "bootstrapping OS" println
  (50000000 + 1231821241) print
  " objects built" println
) 

Mac initialize
Mac boot
