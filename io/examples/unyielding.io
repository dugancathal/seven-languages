first := Object clone
first do := method(
  list(1,3,5) foreach(i,
    i println;
    yield;
    ))

second := Object clone
second do := method(
  list(2,4,6) foreach(i,
    i println;
    yield;
    ))

second @@do
first @@do

while(Scheduler yieldingCoros size > 1, yield)
