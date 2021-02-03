=begin
1. What is a closure? Show how it is implemented with a Proc.
pieces of code that saves the environment around it

```ruby
a = 1
my_proc = Proc.new do
  puts a
  puts b
end
b = 2


def call_proc(my_proc)
  my_proc.call
end

call_proc(my_proc)
```

2. How do closures relate to scope? Explain using a lamba example.

3. How are blocks used when passed in to a method call?

4. How does this syntax work: method_call(&:+)?

5. What is the purpose of Bundler? What are the config files associated with it? How do you configure them?

Bundler manages the dependencies of your Ruby program or the gem/library that your program requires. It's configuration file is called `Gemfile`. In it you specify the gems used by your program.

6. What is the purpose of Rake? What is the config file associated with it?

7. What is the purpose of rvm?

8. What is the purpose of Ruby gems?

9. Explain these testing terms:
     test suite,
     test,
     assertion,
     DSL,
     code coverage,
     expectations-based vs assertions-based interface,
     what is ...FE.SS

10. What are the differences between Minitest and Rspec?


12. Recall and use in an example test 5 different Minitest assertions.

13. When can you pass a block to a method?

14. How to write a method with an explicit block parameter? Why would you write one like that?

15. What are good uses cases for writing method that us blocks or procs?

16. What are the differences between lambda and procs?

17. What are arity rules for blocks?

18. What is a binding?
It's binding are references to surrounding environment/context?
Includes local variables, methods, constants and other artifacts???

19. Explain two places where unary `&` can be used and for what?
```ruby
loop do

  loop do
    a = 1
    break
  end

  a = 2
  break
end
```


=end