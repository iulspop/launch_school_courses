=begin
1. What is OOP and why is it important?

2. What is an object and what is it relationship to a class?

3. What is encapsulation and is the benefit of using it in programming?

4. What is abstraction and is the benefit of using it in programming?

5. What is class inheritence? Show how it works in Ruby.

6. What is polymorphism? Show how it's applied with clas inheritence.

7. What is the method lookup path? Show how it works in Ruby.

8. What is the method access control? Show how it works in Ruby.

9. What is the `super` keyword in Ruby? Show how it works.

10. What are fake operators in Ruby? Explain how they work.

11. What are getters and setters? Show the different ways to create them.

12. What is the `self` keyword in Ruby? Show how it works.

13. What are collaborator objects? When can it be helpful to use them? Show how they're used.

14. What are modules in Ruby? What are two purposes they're used for? Show how they're used for that.

15. What is the difference between instance methods and class methods? Show how each is created and used.

16. How are the methods `==` and `equal?` different? Show it with an example

17. What are fake operators in Ruby? Give 5 examples of different fake operators and how they're used.

18. Examine the code below:
```
module Describable
  def describe_shape
    "I am a #{self.class} and have #{SIDES} sides."
  end
end

class Shape
  include Describable

  def self.sides
    SIDES
  end
end

class Quadrilateral < Shape
  SIDES = 4
end

class Square < Quadrilateral; end

Square.sides # => 4
Square.new.sides # => 4
Square.new.describe_shape # => "I am a Square and have 4 sides."
```

Make the changes necessary to the coce to produce that output.

19. What is wrong with the following code? What fix(es) would you make?
```
class Expander
  def initialize(string)
    @string = string
  end

  def to_s
    self.expand(3)
  end

  private

  def expand(n)
    @string * n
  end
end

expander = Expander.new('xyz')
puts expander
```

20. You have the following classes.
```
class Person
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "strolls"
  end
end

class Cat
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "saunters"
  end
end

class Cheetah
  attr_reader :name

  def initialize(name)
    @name = name
  end

  private

  def gait
    "runs"
  end
end
```

You need to modify the code so that this works:
```
mike = Person.new("Mike")
mike.walk
# => "Mike strolls forward"

kitty = Cat.new("Kitty")
kitty.walk
# => "Kitty saunters forward"

flash = Cheetah.new("Flash")
flash.walk
# => "Flash runs forward"
```
You are only allowed to write one new method to do this.

21. We have written some code for a simple employee management system. Each employee must have a unique serial number. However, when we are testing our program, an exception is raised. Fix the code so that the program works as expected without error.
```
class EmployeeManagementSystem
  attr_reader :employer

  def initialize(employer)
    @employer = employer
    @employees = []
  end

  def add(employee)
    if exists?(employee)
      puts "Employee serial number is already in the system."
    else
      employees.push(employee)
      puts "Employee added."
    end
  end

  alias_method :<<, :add

  def remove(employee)
    if !exists?(employee)
      puts "Employee serial number is not in the system."
    else
      employees.delete(employee)
      puts "Employee deleted."
    end
  end

  def exists?(employee)
    employees.any? { |e| e == employee }
  end

  def display_all_employees
    puts "#{employer} Employees: "

    employees.each do |employee|
      puts ""
      puts employee.to_s
    end
  end

  private

  attr_accessor :employees
end

class Employee
  attr_reader :name

  def initialize(name, serial_number)
    @name = name
    @serial_number = serial_number
  end

  def ==(other)
    serial_number == other.serial_number
  end

  def to_s
    "Name: #{name}\n" +
    "Serial No: #{abbreviated_serial_number}"
  end

  private

  attr_reader :serial_number

  def abbreviated_serial_number
    serial_number[-4..-1]
  end
end

# Example

miller_contracting = EmployeeManagementSystem.new('Miller Contracting')

becca = Employee.new('Becca', '232-4437-1932')
raul = Employee.new('Raul', '399-1007-4242')
natasha = Employee.new('Natasha', '399-1007-4242')

miller_contracting << becca     # => Employee added.
miller_contracting << raul      # => Employee added.
miller_contracting << raul      # => Employee serial number is already in the system.
miller_contracting << natasha   # => Employee serial number is already in the system.
miller_contracting.remove(raul) # => Employee deleted.
miller_contracting.add(natasha) # => Employee added.

miller_contracting.display_all_employees
```

22. You started writing a very basic class for handling files. However, when you begin to write some simple test code, you get a NameError. The error message complains of an uninitialized constant File::FORMAT.

What is the problem and what are possible ways to fix it?
```
class File
  attr_accessor :name, :byte_content

  def initialize(name)
    @name = name
  end

  alias_method :read,  :byte_content
  alias_method :write, :byte_content=

  def copy(target_file_name)
    target_file = self.class.new(target_file_name)
    target_file.write(read)

    target_file
  end

  def to_s
    "#{name}.#{FORMAT}"
  end
end

class MarkdownFile < File
  FORMAT = :md
end

class VectorGraphicsFile < File
  FORMAT = :svg
end

class MP3File < File
  FORMAT = :mp3
end

# Test

blog_post = MarkdownFile.new('Adventures_in_OOP_Land')
blog_post.write('Content will be added soon!'.bytes)

copy_of_blog_post = blog_post.copy('Same_Adventures_in_OOP_Land')

puts copy_of_blog_post.is_a? MarkdownFile     # true
puts copy_of_blog_post.read == blog_post.read # true

puts blog_post
```

23. Write a class that will display:
```
ABC
xyz
```

when the following code is run:
```
my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')
```

24. The following is a short description of the application:

The application lets a customer place an order for a meal.
A meal always has three meal items: a burger, a side, and drink.
For each meal item, the customer must choose an option.
The application must compute the total cost of the order.

Write an application from this description.

=end