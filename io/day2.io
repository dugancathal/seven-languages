#!/usr/bin/env io

Object printHeader := method(header, 
  writeln
  writeln
  writeln
  "********************" println;
  header println;
  "********************" println)

printHeader("Fibonacci")

Fibonacci := Object clone
Fibonacci recur := method(n,
  if(n == 1, 1,
    if(n == 2, 1,
      recur(n-1) + recur(n-2))))
Fibonacci looper := method(n,
  vals := list
  for(i, 1, n,
    if(i == 1 or i == 2, vals append(1),
      vals append(vals at(-1) + vals at(-2)))) at(-1))

printHeader("------Looping-------")
for(i, 1, 15, Fibonacci looper(i) println)
printHeader("-----Recursion------")
for(i, 1, 15, Fibonacci recur(i) println)

printHeader("Alter an operator")
# make / return 0 if denominator is 0

# Number / := method(denom, if(denom == 0, 0, /(denom)))

# "123 / 0 == " print
# (123 / 0) println

printHeader("Add up a 2D array")
arry := list(list(1,2,3,4),list(5,6,7,8))
arry map(row, row sum) sum println

printHeader("myAverage average method")
List myAverage := method(
  if( (call target size) > 0,
    (call target sum) / (call target size),
    Exception raise("can't get size of an empty list")))

list(1,2,3,4) myAverage println

printHeader("My 2D List")

List2D := Object clone
List2D colCount := method(self arry at(0) size)
List2D rowCount := method(self arry size)
List2D dim := method(x, y,
  newb := self clone
  newb arry := list;
  for(i, 1, y, 
    current := list;
    for(j, 1, x,
      current append(1));
      newb arry append(current));
  newb)

List2D set := method(x, y, val,
  self arry at(y) atPut(x, val))

List2D get := method(x, y,
  self arry at(y) at(x))

List2D println := method(
  for(i, 0, self colCount - 1,
    for(j, 0, self rowCount - 1,
      write(self get(i, j), " "))
    writeln))
List2D asString := method(
  str := ""
  for(i, 0, self colCount - 1,
    for(j, 0, self rowCount - 1,
      str = "#{str} \"#{self get(i, j)}\"" interpolate)
    str = "#{str}\n" interpolate)
  str)

myList := List2D dim(3, 4)
myList println
"-----" println
myList set(2, 3, "Oh hai")
myList println

(myList get(2, 3) == "Oh hai") println

printHeader("Transpose!")
List2D transpose := method(other,
  newb := self proto dim(self rowCount, self colCount)
  for(y, 0, self rowCount - 1,
    for(x, 0, self colCount - 1,
      newb set(y, x, self get(x, y))))
  newb)

new_matrix := myList transpose
new_matrix println
(new_matrix get(3, 2) == "Oh hai") println

printHeader("File I/o ... no?")
tmp := File with("tmpFile.txt")
tmp remove
tmp openForUpdating
tmp write(new_matrix asString)
tmp close


List2D fromData := method(cells,
  fileMade := List2D dim(cells size, cells at(0) size)
  cells foreach(i, row,
    row foreach(j, cell,
      fileMade set(i, j, cell)
    )
  )
  fileMade
)

Regex

tmp openForReading
lines := tmp readLines
cells := lines map(i, line,
  line strip allMatchesOfRegex("\"(.*?)\"") map (at(0))
)
fileMade := List2D fromData(cells)
fileMade println
tmp remove

printHeader("The Guessing Game")

theNumber := Random value(100) floor
"Welcome to The Guessing Game" println
for(i, 1, 10,
  "Take a guess: " print
  guess := File standardInput readLine strip asNumber
  if(guess == theNumber,
    "YOU GOT IT" println; break,
    if(guess < theNumber, "higher" println, "lower" println)))
