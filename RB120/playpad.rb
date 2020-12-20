class Vehicle
  def self.info
    puts 'vehicle stuff'
  end
end

class Car < Vehicle; end

# Class
# Module
# Object
# Kernel
# BasicObject

singleton_class = ( class << Vehicle; self; end )
puts singleton_class.ancestors

singleton_class = ( class << Car; self; end )
puts singleton_class.ancestors

=begin
How are class methods inherited? (Solved: Through Singleton Classes)

Hello,

In Ruby, when a subclass inherits from a superclass, the superclass is added to the method lookup path of the subclass. Then, methods defined on the superclass are accessible when called on instances of the subclasses. That's how inheritance shares behaviour between classes. But, how come class methods are inherited as well?

I'll create a class that inherits a class method:
```ruby
class Vehicle
  def self.info; end
end

class Car < Vehicle; end

Car.info
```

Now, the `info` class method can be called on the `Car` class. Yet, `Vehicle` isn't added to the method lookup path of the `Car` class. Nor is the method defined on any of the classes on the lookup path.
```ruby
puts Car.class.ancestors
# Class
# Module
# Object
# Kernel
# BasicObject
```
So, how does Ruby search and find the `info` class method on the `Car` class? My hypothesis is class methods are defined directly on the `Class` instance. If that is correct, does it mean class methods are not reused, but in fact duplicated when inherited?

...after writing my question in detail and researching it. I found the answer. I'll explain for others who are curious.

A class, like `Car` above, is an object of the `Class` class. A class method is a method defined directly on that object. That is it isn't shared among the instances of the `Class` class. It belongs only to that instance where it is defined directly.

When we use the `class` keyword, we're instanciating an object of the `Class` class.
```ruby
class Car; end
```

We can define a method directly on that object like so:
```ruby
def Car.model; end
```

Which exactly the same as:
```ruby
class Car
  def self.model; end
end
```

The same can be done for any object, for example an instance of the `Car` class.
```ruby
car = Car.new
def car.model; end
```

In the above example, we define the `model` method on a particular instance of the `Car` class. Below, we define the `model` instance method on the `Car` class, which is shared by all instances of that class. Completely different.
```ruby
class Car
  def model; end
end
car = Car.new
```

Again, since these methods are defined **on an object** and not as an instance method of a class, they **belong only to that specific instance**. These in fact called **singleton methods** in Ruby.

We can retrieve an array of the singleton methods of an object with `Object#singleton_methods`:
```ruby
class Car
  def self.model; end
end
puts Car.singleton_methods # => model
```

To answer my second question "If that is correct, does it mean class methods are not reused, but in fact duplicated when inherited?". No, class methods are reused and they're not duplicated when inherited.

How can that be if class methods are defined on one `Class` instance?
It's because in Ruby, **all methods must belong to a class**. That is, every method must be an instance method defined on a class. So, singleton methods defined on a `Class` instance are actually defined on the **singleton class** of that instance.

There's a lot to unpack there, so let me reiterate, class methods are singleton methods defined on a class. In other words, they're methods particular to one instance of the `Class` class. But, since methods must belong to a class, they're defined on the **singleton class** of the object.

I'll show that the class method `model` is defined on the singleton class of `Car` and not on `Car`.
```ruby
class Car
  def self.model; end
end
puts Car.method_defined? :model
# => false, the method is not defined on this class

metaclass = Car.singleton_class # returns the singleton_class
p metaclass # Outputs '#<Class:Car>' denoting the singleton_class.

puts metaclass.method_defined? :model
# => true, this is where the instance method is defined!
```
From that, we can conclude that Ruby in fact does not support class methods! In mimics class methods through singleton methods that are actually instance methods on a singleton class.

Finally, how are class methods reused? It is through singleton classes' own method lookup path.

Let's setup the example we started and inspect the singleton class of the `Car` class.
```ruby
class Vehicle
  def self.info; end
end

class Car < Vehicle; end

metaclass = Car.singleton_class # returns Car's singleton_class

# Is the `info` class method stored on `Car`'s singleton class?
puts metaclass.method_defined? :info, false # => false. No, it's not.

# Let's check the singleton classe's ancestors
puts metaclass.ancestors

# #<Class:Car>
# #<Class:Vehicle> <- Maybe `info` is here?
# #<Class:Object>
# #<Class:BasicObject>
# Class
# Module
# Object
# Kernel
# BasicObject

# Is the `info` class method stored on `Vehicle`'s singleton class?
vehicles_singleton_class = metaclass.ancestors[1]
puts vehicles_singleton_class .method_defined? :info, false # => true. Yes, it is!
```
Wow! So, Ruby finds the `info` class method on the singleton class of `Vehicle`. That means when one class inherits from another, the singleton class of the superclass is added to the subclass' singleton class method lookup path.

Further exploration would be to verify what the full method lookup path is for different kinds of objects, given the existence of singleton classes. I don't understand that exactly yet.
=end