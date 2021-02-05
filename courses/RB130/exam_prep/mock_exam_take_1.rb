=begin
1. What is a closure? Show how it is implemented with a Proc.

A closure is a piece of code that can be passed around a program and invoked.
It also retains references to the surrounding artefacts where and when it's created,
such that those artefacts like local variables are accessible within the closure wherever it's invoked.
Blocks, Procs and lambdas are implementations of closures in Ruby. The references
they retain is called 'binding' in Ruby.

The following code outputs `10` and then raises a `NameError`. That is because the
Proc instanciated on line 14 captures references that are available in the scope it's instanciated in 
and at the time it's instanciated. Local variable `a` was initilized before the Proc is instanciated
and is in the same scope, so the Proc's binding retains a reference to it.
On line 23, the proc is called after being passed as an argument to the `call_proc` method call.
Even though local variable `a` initialized on line 17 is not available in the self-contained
scope of the method, the Proc retains a reference to what was available in the scope at the time it's
initialized. local variable `a` was accessible in that scope and so it was retained by the binding.
When the Proc executes it's block, `a` is resolved, but since local variable `b` was
instanciated **after** the Proc, the binding retained no references to it, so the unknown variable
raises a `NameError`.
```ruby
a = 10
proc = Proc.new do
  puts a, b
end
b = 1

def call_proc(proc)
  proc.call
end

call_proc(proc)
```

2. How do closures relate to scope? Explain using a lamba example.

3. How are blocks used when passed in to a method call? And how does it work it terms of execution?

4. What are two uses cases for writing method that use blocks or procs? Show with examples.

5. How do explicit block parameters work? What is the benefit of using them?

6. What are the arity rules of blocks, Procs and lambas?

7. When can you pass a block to a method?

8. How does the `&:symbol` syntax work?

9. What will this return and why?

```ruby
a = 5
lambda = lamda do
  puts a, b
end
b = 10

def call_lambda(&lambda)
  b = 15
  lambda.call
end

call_lambda(&lambda)
```

10. What will the `call_first` method invocation return and why?

```ruby
def call_second
  yield
end

def call_first(&closure)
  call_second(&closure)
  15
end

call_first do
  return 10
end
```

11. What will this return and why?

```ruby
def reduce(collection, accumulator = nil)
  accumulator = collection.shift if accumulator.nil?
  collection.each do |item|
    accumulator = yield(accumulator, item)
  end
  accumulator
end

array = [1, 1, 1]

reduce(array) do |sum, el|
  sum + el
end
```

12. Explain these testing terms:
     test suite,
     test,
     assertion,
     DSL,
     code coverage,
     expectations-based vs assertions-based interface,
     what is ...FE.SS

13. What are the differences between Minitest and Rspec?

14. What is the SEAT approach to tests? Make a demonstration.

15. Recall and use in an example test 5 different Minitest assertions.

16. What is the purpose of Bundler? What are the config files associated with it? How do you configure them?

17. What is the purpose of Rake?

18. What is the purpose of rvm?

19. What is the purpose of Ruby gems?

20. Solve this problem, zip solution and submit: https://launchschool.com/exercises/cbf0104f
    Don't forget Rubocop!

=end