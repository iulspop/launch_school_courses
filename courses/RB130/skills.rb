=begin
  What are blocks?
  What happens when pass in a block?
  What are blocks great for?
  How to implement methods using blocks?
  What is a closure, show an example?
  Why is it called a closure?
  What is the difference between Proc and lambda and block?
  What does it mean to say Procs, Lambda and block are binding?
  How to use the yield keyword?
  How to use a block as a parameter?
  Use the Symbol#to_proc for a collection operation and explain how it works.
  What are the rules for parameters and arguments passed to a block?

  Use minitest assert or spec interface?
  How does assert_equal work?
  Some other built-in assertions?
  Setup minitest colors?
  What is SEAT?
  logic of assertions?
  What does redundancy mean in the context of testing?

  How to configure bundle?
  How to configure rake?
  How to configure gemspec?

  "Including Set Up and Tear Down steps reduces redundancy in the Test Suite code." Ask why is that true, doesn't increase redundancy and reduce duplication.
  GAPS:

=end

def hi(a, b, &t)
  if block_given?
    t.call(a, b, 5)
  end
end
z = 5
t = Proc.new { |a, b| p a, z }
hi(1, 2, &t)
