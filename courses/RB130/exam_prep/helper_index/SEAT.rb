=begin

11. What is the SEAT approach to tests? Make a demonstration.

SEAT is a process for writing automated tests with four steps. The first step is 'Setup', which is initializing the objects that will be used in the tests.
It's like getting the actors for a play on stage.

```ruby
require "minitest/autorun"

class TestSuite < Minitest::Test
  def setup
    @number = 5 # Setup
  end
end
```

The second step is 'Execute', which is calling the methods on the objects and having Ruby execute those instructions. This step is like giving the actors a script and telling them to enact the play.

```ruby
require "minitest/autorun"

class TestSuite < Minitest::Test
  def setup
    @number = 5 # Setup
  end

  def test_increment_plus_one
    number = @number += 1 # Execute
  end
```

The third step is 'Assert'. Assert means to claim a truth. In the context of testing, generally it means we affirm what we expect a return value to be and compare it to the actual result of the previous execution step. We can also affirm other things like that an error is raised if some code is executed.

```ruby
require "minitest/autorun"

class TestSuite < Minitest::Test
  def setup
    @number = 5 # Setup
  end

  def test_increment_plus_one
    number = @number += 1 # Execute
    assert_equal 6, number # Assert
  end
end
```

Finally, the fourth step is 'Teardown'. In this step do any clean up necessary after running our step, such as closing database connections established during the setup. This is like removing the actors from the stage and cleaning up for the next play.

```ruby
require "minitest/autorun"

class TestSuite < Minitest::Test
  def setup
    @number = 5 # Setup
  end

  def test_increment_plus_one
    number = @number += 1 # Execute
    assert_equal 6, number # Assert
  end

  def teardown
    @number = nil # Teardown (in this case the teardown is unessessary)
  end
end
```

=end