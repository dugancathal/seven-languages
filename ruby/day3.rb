#!/usr/bin/env ruby

require_relative 'support'

section_header 'Blank?'

class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    self.size == 0
  end
end

['', 'person', nil].each {|element| puts element unless element.blank?}

section_header 'Units'

class Numeric
  def inches
    self
  end

  def feet
    self * 12.inches
  end

  def yards
    self * 3.feet
  end

  def miles
    self * 5280.feet
  end

  def back
    self * -1
  end

  def forward
    self
  end
end

puts 10.miles.back
puts 2.feet.forward

section_header 'Roman' # Dear God, what is this guy doing

class Roman
  def self.method_missing(name, *args)
    roman = name.to_s
    roman.gsub!('IV', 'IIII')
    roman.gsub!('IX', 'VIIII')
    roman.gsub!('XL', 'XXXX')
    roman.gsub!('XC', 'LXXXX')

    (roman.count('I') +
     roman.count('V') * 5 +
     roman.count('X') * 10 +
     roman.count('L') * 50 +
     roman.count('C') * 100)
  end
end

puts "X:   ", Roman.X
puts "XC:  ", Roman.XC
puts "XII: ", Roman.XII
puts "XV:  ", Roman.XV

section_header 'Acts as CSV'

class ActsAsCsv
  def initialize
    @result = []
    read
  end

  def read
    file = File.new(self.class.to_s.downcase + '.txt')
    @headers = file.gets.chomp.split(', ')

    file.each do |row|
      @result << row.chomp.split(', ')
    end
  end

  def headers
    @headers
  end

  def contents
    @result
  end
end

class RubyCsv < ActsAsCsv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.contents.inspect

section_header 'Acts as CSV macros?!'

class ActsAsCsv
  def self.acts_as_csv
    define_method 'read' do
      file = File.new(self.class.to_s.downcase + '.txt')
      @headers = file.gets.chomp.split(', ')
      file.each do |row|
        @result << row.chomp.split(', ')
      end
    end
    define_method 'headers' do
      @headers
    end

    define_method 'contents' do
      @result
    end

    define_method 'initialize' do
      @result = []
      read
    end
  end
end

class RubyCsv < ActsAsCsv
  acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.contents.inspect

section_header 'Acts as CSV with a Module'

module ActsAsCsvModule
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_as_csv
      include InstanceMethods
    end
  end

  module InstanceMethods
    def read
      @contents = []
      file = File.new(self.class.to_s.downcase + '.txt')
      @headers = file.gets.chomp.split(', ')

      file.each do |row|
        @result << row.chomp.split(', ')
      end
    end

    attr_reader :headers, :contents

    def initialize
      read
    end
  end
end

class RubyCsv
  include ActsAsCsvModule
  acts_as_csv
end

m = RubyCsv.new
puts m.headers.inspect
puts m.contents.inspect

section_header 'CSV Rows!'

class CsvRow
  def initialize(row, headers = [])
    @headers = headers
    @row = Hash[headers.zip(row)]
  end

  def method_missing(method, *args)
    @row[method.to_s] || super(*([method] + args))
  end
end

puts CsvRow.new([1,2,3,4], ['one', 'two', 'three', 'four']).one
puts CsvRow.new([1,2,3,4], ['one', 'two', 'three', 'four']).nothing rescue "Worked!"

