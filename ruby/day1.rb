#!/usr/bin/env ruby

# Print the string "Hello, world."
puts "Hello, world."

# Find the index of 'Ruby' in "Hello, Ruby."
string = "Hello, Ruby."
puts "Index is: #{string[/Ruby/]}"

# Print your name 10 times
10.times { puts "TJ" }

# Print the string with the index changing from 1-10
1.upto(10) {|i| puts "This is sentence number #{i}." }

# Let's play low-high
puts "We're gonna play Low-High!"
puts "I'm thinking of a number between 1 and 100."
my_number = rand(1..100)
print "What do you think it is? "
while guess = gets.chomp
  break if guess.empty?
  if my_number == guess.to_i
    puts "YOU GOT IT"
    break
  end

  puts "Too low" if guess.to_i < my_number
  puts 'Too high' if guess.to_i > my_number
  print "What do you think it is? "
end
