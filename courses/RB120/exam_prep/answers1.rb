=begin
1. What is polymorphism with ducktyping?
Polymorphism is different types of objects responding to the same interface.
Ducktyping is a method of accomplishing polymorphism by creating a public method
with the same name on unrelated classes. Then, instances of those classes can respond to that same interface interchangebly, as if they were the same type (if it quacks like a duck, then its a duck.)

In the example below, even though a Horse instance has a different class than Duck, it can be used as if it did in this context, since we created an interface that responds to the same message.
```ruby
class Duck
  def quack
    'quack'
  end
end

class Horse
  def quack
    'Hiuuuhhhh'
  end
end

def quack_them_all(ducks)
  ducks.each { |duck| puts duck.quack }
end

quack_them_all([Duck.new, Horse.new])
```

2. What is encapsulation? How do objects encapsulate state?
Encapsulation is taking data and methods that act on that data and grouping
them in a container (like a capsule groups stuff inside). The container protects the data from being accessed externally, unless it's accessed through a explicitly defined interface.

For example, objects encapsulate state and behaviour. Below, local variable `car` references an instance of the `Car` class. That `Car` instance encapsulates the state held by the instance variable `@engine`, and the implementation method `activate_engine_systems`. Unless a public interface is defined on the `Car` class to expose that state or behaviour, they cannot be accessed externally. This prevents unknown dependencies from being made in the program.

```ruby
class Car
  def initialize
    @engine = false
  end

  private

  def activate_engine_systems; end
end

car = Car.new
```

3. What is equivalence in Ruby?
How ruby determines if an object is equivalent to another object. It lookups a '==' method.

4. What is an object and what is it's relationship to a class?
An object is a piece of program that encapsulates state and behaviour.
The class outlines what state and behaviour an object (also called instance)created from it has. Objects are created from a class by calling the `new` method on that class.

```ruby
class Car
  # state and behaviour is outlined
end

# A car object is instanciated and assigned to the local variable `car`
car = Car.new
```

5. What is OOP and why is it important?
Object-Oriented Programming are a set of programming techniques that use objects as the central principle of code organisation. Objects are pieces of program that manage their own data. That is, they group data and processes that manipulate that data together. That makes objects useful to model many things things in the world that have a current condition and behaviour that depends on that condition. By modeling things, objects hide details and expose a simple way to interact with that model. You can then think about using that model and how it interacts with other models without having to know the details of how the model is implemented. The result is you have pieces at a higher level, that hide more complexity, to put your program together with.

OOP is important because it can be used to solve the limitations of large, complex computer programs. As computer programs become larger it becomes more and more difficult to change them, because changing one thing in one place can have many effects in places not obviously related. OOP's approach to solving this problem uses objects to keep parts of the program as independent as possible by limiting possible dependencies only to the object's public interface.


6. What are getters and setters? Show all the ways of creating them.
Getters and setters are methods expose instance variables to access, since by default instance variables are encapsulated or inaccessible from outside the object. Getters 'get' or return the object instance variables reference. Setters take an argument and reassign the instance variable to that argument object.

You can create getters and setters manually or with the `attr_*` shortcut.

Below, no getter or setter is defined, so `@name` is not accessible
```ruby
class Dog
  def initialize(name)
    @name = name
  end
end

purple = Dog.new('purple')
purple.name # NoMethod error
```

Here, a getter and a setter methoid is defined for the `@name` instance variable. Since they are public, the data is not accessible from the outside of the object.
```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def name=(new_name)
    @name = new_name
  end
end

purple = Dog.new('purple')
purple.name # returns String representing name
purple.name = 'red' # reassigns instance variable
```

Finally, the same as above, but with Ruby's `attr_*` syntax. The attr_reader, `attr_writer` and `attr_accessor` method take symbols as arguments and create getters, setters or both repectively for instance variables where the symbol becomes the instance variable name (`:breed` => `@breed`).
```ruby
class Dog
  attr_reader :name
  attr_writer :name

  # or create both getter and setter with `attr_accessor :name`

  def initialize(name)
    @name = name
  end
end

purple = Dog.new('purple')
purple.name # returns String representing name
purple.name = 'red' # reassigns instance variable
```

7. Why use getters and setters withing the object? How are they used within the object?
It's recommended to call the getter and setter methods for an instance variable within an object, even though intance variables can be directly accessed since they're within scope. The reason is it's easier for changes to be made later, like logging each time the instance variable is accessed.

Getters are called directly like any method and the return value is used. Setters have to be called with the `self` keyword as the explicit caller like so: `self.setter = object`. That is so Ruby can distinguish between initializing a local variable and calling the setter method.

8. What is Method Access Control? Show how it is used in Ruby.
Method Access Control is controlling where methods defined on an object can be accessed. There are three types of control: public, private and protected. Public methods can be called on the instance anywhere in the source code.Private methods can only be called within the object. That is, they can be called only within other instance methods defined by the class, so by the object itself. Protected methods are like private methods, but they can also be called by other objects that are instances of the same class or a class the inherits from the same class.

Methods are defined with different access levels within the class definition using the `private`, `protected` and `public` keywords. Methods defined in the lines below the keyword will have the access level corresponding with the keyword. If no keyword is used, methods are by default public.

```ruby
class Foo
  # by default any method defined here is public

  private

  # private methods

  protected

  # protected methods

  public

  # public methods again, but it's not recommended to split the methods positions like this.
end
```

9. What is class inheritence? Show how it is used in Ruby.
Class inheritence is a code reuse mechanism where the behaviour (also known as methods) of a superclass is inherited by a subclass. The subclass simply adds the superclass as the next class up on the method loopup path. That is done with the `<` token like so: `class Subclass < Superclass`. Now, the methods defined by the `Superclass` class can be called on instances of `Subclass`. The access level of superclass' methods remains the same on subclass instances.

10. What is the method lookup path in Ruby? How does it work?
The method lookup path is the order in which Ruby searches for the method to execute when a method is called. The order is as follows: the class the object is an instance of, any modules that are included, starting with the modules include last in the source code, then the superclass, again the modules and so on until there's no superclass. Ruby searches for the method on the class or modules in that order, the first to be found is used and any other method up the loopup chain is ignored. The first method found effectively overwrites the rest, but the `super` keyword can be used the call the next method with the same name up the lookup chain.

11. How is a module used for interface inheritence? When is it helpful to use mixins?

12. How is a module used for namespacing? When is it helpful to create namespaces?

13. What is self? How is it used?

15. What are fake operators in Ruby?

16. What are collaborator objects? When is it helpful to use them?


=end


=begin
orgin questions
1. What is polymorphism with ducktyping?

2. What is encapsulation?

3. What is equivalence in Ruby?

4. What is an object and what is it's relationship to a class?

5. What is OOP and why is it important?

6. What is encapsulation?

7. What are getters and setters? Show all the ways of creating them.

8. How do we call getters and setters within and without the object?

9. What is Method Access Control? Show how it is done in Ruby.

10. What is class inheritence? Show how it is done in Ruby.

11. How is a module used for interface inheritence? When is it helpful to use mixins?

12. How is a module used for namespacing? When is it helpful to create namespaces?

13. How does the method lookup path work in Ruby?

14. What is self? How is it used?

15. What are fake operators in Ruby?

16. What are collaborator objects? When is it helpful to use them?


=end