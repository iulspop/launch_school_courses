=begin
write out pseudo-code (both casual and formal) that does the following:

- a method that returns the sum of two integers
- a method that takes an array of strings, and returns a string that is all
  those strings concatenated together
- a method that takes an array of integers, and returns a new array with every
  other element
=end

=begin
== Problem 1 ==
Given two integers
add them together
return the result

START

# Given two integers called first_number and second_number

SET sum = first_number + second_number
RETURN sum

END

=end

=begin
== Problem 2 ==
Given an array of strings
Concatenate strings together into single string
Return big string

START

# Given an array of strings

SET joined_string = ""

LOOP through array
  SET joined_string += string

RETURN joined_string

END

=end

=begin
== Problem 3 ==
Given an array of integers
Instantiate new array
Iterate through array
Add every second element to new array

START

# Given an array of integers

SET new_array = []
SET index = 0

WHILE index < array.size
  append array[index] to new_array
  index = index + 2

RETURN new_array

END

=end
