=begin
1. What is a closure? Show how it is implemented with a Proc.

```ruby

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