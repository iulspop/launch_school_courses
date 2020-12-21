=begin
1. What is OOP and why is it important?
OOP is an approach to programming that uses the object as the central principle of code organisation. It's important because it allows us to write complex programs that can be changed cost-effectively, because objects can make the pieces of our program self-contained.

2. What is an object and what is it relationship to a class?
An object is a container for data and the methods that manipulate that data. Objects are specific instances created from classes. Classes define instance methods that are available to instances of that class. The instance methods in turn outline the kind of data the object's instance variables will store.

In the below example, the `new` class method is called on the `Dog` class on line 2, which returns a new object of the `Dog` class. The `Dog` instance has access to the instance method `bark` and has an instance variable `@name`.
```ruby
class Dog
  def initialize(name)
    @name = name
  end
  def bark; end
end
Dog.new('sparky')
```

3. What is encapsulation and is the benefit of using it in programming?
Encapsulation is taking data and the methods that operate on that data and putting them inside a container. The result is the data is protected from outside access. A public interface is defined to interact with the behaviour and data of the container.

```ruby
class Dog
  def initialize(name)
    @name = name
  end

  def print_dog_info
    puts name
  end

  private

  attr_reader :name
end
```

4. What is abstraction and is the benefit of using it in programming?
Abstraction in programming is creating a new level of meaning to interact with by hiding details and focusing on a general concept that's easily understood.

Abstractions can be created in OOP with classes and objects. For example, we can define a Car class and instanciate an object from it.
```ruby
class Car
  # car does things and has state
end
car = Car.new
```
From the user's perspective, the details of how the `Car` object is implemented is hidden. Hence, they can operate at a new level of meaning and interact with the 'car' concept. This is helpful, because the simpler concept without the details leave them room to think about how other pieces/concepts/objects fit with the car object.

5. What is class inheritence? Show how it works in Ruby.
It's a code reuse mechanism that allows a class to inherit behaviour from another class. They are called the subclass and superclass respectively.

It works in Ruby like this:
```ruby
class Vehicle
  def accelerate; end
end
class Car < Vehicle; end
```
The `<` token is used to make the subclass on the left inherit from the superclass on the right.

Now, the `accelerate` method can be called on instances of the `Car` class.
```ruby
Car.new.accelerate
```
That instance method is not defined on the `Car` class, but it can called on instances of that class, because the superclass was added to the method lookup path by making the subclass inherit from it.

6. What is polymorphism? Show how it's applied with class inheritence.
Polymorphism is when objects of that are instances of different classes respond to the same method call with their own implementation. In other words, when different kinds of objects respond to the same message. The details of how objects of different types respond to the message are independent and can be very different.

On way to accomplish polymorphism is through class inheritence:
```ruby
class Vehicle
  def accelerate
    # increase speed
  end
end

class Car < Vehicle
  def accelerate
    super
    # call sub-systems
  end
end

class Motorcycle < Vehicle
  def accelerate
    super
    # call different sub-systems
  end
end

car = Car.new
motorcycle = Motorcycle
```

In the above example, the instance of the `Car` class and the instance of the `Motorcycle` class are different types of objects, but can respond to the same interface `accelerate`. From a user's point of view, using the two objects is the same, but the details of the implementation can be very different.

7. What is the method lookup path? Show how it works in Ruby.
The method lookup path is how Ruby resolves what method to execute. Each object has a method lookup path that starts with the class it is an instance of and is followed by the chain of inheritence of that class.

Below, I display the method lookup path for an Integer object.
```ruby
num = 5
puts 5.class.ancestors
# Integer
# Numeric
# Comparable
# Object
# Kernel
# BasicObject
```
`5` is an instance of the `Integer` class. So, if I call a method on that object, like for example `5.abs`, then Ruby will search for an instance method defined on each of those classes starting with `Integer` down through `BasicObject`. The first instance method to be found that matches the name is executed, so methods further up the inheritence hierarchy are ignored.

8. What is the method access control? Show how it works in Ruby.
Method access control is a way to control where methods can be called on an object built in to Ruby. Instance methods always have an access level. There are three levels: public, private and protected.

By default, any instance method defined on a class is public:
```ruby
class Car
  def accelerate; end
end
```

Instance methods can also explicitly be defined as public using the `public` keyword. Instance methods defined below that keyword are public.
```ruby
class Car
  public
  def accelerate; end
end
```

That means it can be called on instances of that class from outside the object.
```ruby
car = Car.new
car.accelarate
```
So, public instance methods form the interface users of the object interact with.


To define a private method, the private keyword is added to the class definition and any instance method defined on lines below the keyword are private methods.
```ruby
class Car
  private
  def accelerate; end
end
```

Private methods cannot be called on instances from the outside of the object.
```ruby
car = Car.new
car.accelerate # => NoMethodError
```

They can be called only from within the object. That is within public instance method calls of the same object.
```ruby
class Car
  def turn_on
    accelerate
  end

  private

  def accelerate; end
end
car = Car.new
car.turn_on
```
So, private methods are implementation details we don't want the user to access.

Finally protected instance methods are similiar to private methods. They can only be called from within the object, only with one exception. Protected methods can also be called within another object of the same class or of a class that subclasses the same class.

For instance, we can make the getter for `@miles` protected if we wanted to compare the miles of two cars, but also keep that protect that data from access otherwise.
```ruby
class Car
  def initialize(miles)
    @miles = miles
  end

  def ==(other)
    miles == other.miles
  end

  protected

  attr_reader :miles
end
car1 = Car.new(100)
car2 = Car.new(200_000)
puts car1 == car2 # => false
```

9. What is the `super` keyword in Ruby? Show how it works.
The `super` keyword is used inside instance methods or class methods to call the next method up the lookup chain with the same name.

I show the use of the `super` keyword below.
```ruby
class Player
  def initialize(strength, intelligence)
    @strength = strength
    @intelligence = intelligence
  end
end

class Human < Player
  def initialize
    super(6, 6)
  end
end

class Orc < Player
  def initialize
    super(8, 3)
  end
end
```

The `super` keyword is used in the `Human` and `Orc` classes' `initialize method` to call same method one step up the method lookup chain. That is the same as calling the next method up the inheritence hierarchy. In this case that is the `initialize` instance method on the `Player` class.

The `super` keyword implicitly takes all method parameters as arguments when called without parentheses.

The following example illustrates that:
```ruby
class OneThing
  def foo(x, y); end
end

class TwoThing < OneThing
  def foo(x, y, z)
    super
  end
end

TwoThing.new.foo(1, 2, 3) # => ArgumentError
```

The code raises a `ArgumentError` when executed, because the `super` method on line 8 calls the `foo` instance method of the `OneThing` class with 3 arguments, since the three parameters of the `foo` method on `TwoThing` were passed implicitly.

To fix that, we can add parentheses to the `super` keyword to explicitly pass in the arguments we want, in the order we want.

```ruby
  def foo(x, y, z)
    super()     # calls next method up with no arguments
    super(x, y) # with two arguments
    super(y, x) # or changed order
  end
```

10. What are fake operators in Ruby? Explain how they work.
Fake operators are methods that can be used with operator-like syntax in Ruby.

For example, we can define an instance method called `+` on a custom class:
```ruby
class Container
  attr_reader :size

  def initialize(size)
    @size = size
  end

  def +(other)
    Container.new(size + other.size)
  end
end

a = Container.new(50)
b = Container.new(50)
c = a + b
puts c.size # => 100
```

The `+` instance method is not a operator in the sense that it is not a construct built in to the language. It looks like one syntactically, but in reality it is an instance method of a particular class. This affords users of Ruby a lot of flexibily, since fake operators can defined and overwritten on any class to provide an intuitive interface for certain operations.

11. What are getters and setters? Show the different ways to create them.
By default, the data that the instance variables of an object reference is not accessible from outside that object.

For example, when I create an instance of this class, there's no way for a user of that object to access the data referenced by `@name`:
```ruby
class Player
  def initalize
    @name = 'Long Pants'
  end
end

a_player = Player.new
a_player.name # => NoMethodError
```

`@name` is scoped to the object referenced by `a_player`. That state is encapsulated within the object and protected from outside access.

Getters and setters are methods used to expose an interface to "get" or read that data and "set" or write to that data.

```ruby
class Player
  def initalize
    @name = 'Long Pants'
  end
end

a_player = Player.new
a_player.name # => NoMethodError
```

12. What is the `self` keyword in Ruby? Show how it works.
The `self` keyword is a reference to an object. The object it references is either a class or an instance of a class. Which it references depends on where it is used in the source code, also known as the lexical context.

The following example explains the rules that determine what `self` references:
```ruby
class Foo
  # used here in the class definition it references the class `Foo`
  foo_inception = self

  # self after the `def` keyword also references the class `Foo`. This defines a singleton method on the class `Foo` (a class method).
  def self.a_class_method
    # used inside a class method, it references the class `Foo`
  end

  def an_instance_method
    # used inside an instance method it references the instance of `Foo` that calls this method
  end
end

# What is `self` in the top level scope?
puts self # => main
puts self.class # => Object
# `self` references `main` an instance of the `Object` class
```
However, there's a twist to it. Ruby also uses `self` implicitly to determine what object a method with no explicit called is called on.

The `self` keyword can also been seen as a method that returns an object or another based on where it is called.

13. What are collaborator objects? When can it be helpful to use them? Show how they're used.

14. What are modules in Ruby? What are two purposes they're used for? Show how they're used for that.

15. What is the difference between instance methods and class methods? Show how each is created and used.

16. How are the methods `==` and `equal?` different? Show it with an example

17. What are fake operators in Ruby? Give 5 examples of different fake operators and how they're used.

17.5 What are the differences between classes and modules?

24. The following is a short description of the application:

The application lets a customer place an order for a meal.
A meal always has three meal items: a burger, a side, and drink.
For each meal item, the customer must choose an option.
The application must compute the total cost of the order.

Write an application from this description.

=end