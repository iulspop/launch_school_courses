


a = "Hello"
b = a
a = "Goodbye"
puts a
puts b

# What do the `puts` method calls on lines 7 and 8 output and why?

=begin
We declare local variable `a` and initialize it to a String object with the value "Hello". We then declare local variable `b` and initialize it to the same String object pointed to by `a`.

Next, we re-assign `a` to a String object with the value "Goodbye", meaning `a` and `b` no longer point to the same object -- `a` points to the String object with the value "Goodbye", whichle `b` still points to the String object with the value "Hello".

As a result, on line 7 when we call the puts method and pass the variable `a` as an argument, "Goodbye" is output to the screen.

On line 8, when we call the puts method and pass the variable `b` as an argument, "Hello" is output to the screen.

This question illustrates the concept of variables as pointers as re-assigning `a` did not impact the object pointed to by `b`.
=end

=begin
My suggestions:
1. Format your paragraphs with an empty line between them. Your answer might of looked better in coderpad depending how it formated it.

2. First paragraph, first sentence: 'We declare local variable `a` and initialize it to a String object with the value "Hello"'. I recommend you definitely specify the line number in every sentence where you're describing what is going on in a particular line, so here it would be: 'On line 1, we declare local variable `a` and initialize it to a String object with the value "Hello"'. My style preference is to specify the line number at the beginning of the sentence, so the reader can know what I'm describing first.

3. First paragraph, first sentence again: 'We declare local variable `a` and initialize it to a String object with the value "Hello"'. You can abbreviate this to: 'Local variable `a` is initialized to the String object `"Hello"`'. Your previous phrasing is totally correct, but the second sentence I'm 100% sure is correct too and less verbose. Notice, 'declare and initialize' is shortened to 'initialized to' and 'String object with value' is shortened to 'String object `Hello`'. Also, I prefer narrating the code without 'We', since it simplifies your answers.

3. First paragraph, second sentence: 'We then declare local variable `b` and initialize it to the same String object pointed to by `a`.' Same as before, you can abbreviate to '`b` is initialized to'. I would add another sentence for emphasis 'Now, both local variables `a` and `b` reference the same object'.

4. Second paragraph, first sentence: 'Next, we re-assign `a` to a String object with the value "Goodbye"'.. I would replace 'Next' with the line number, 'On line 5,'. Again instead of 'we', I'd phrase it like this: 'local variable `a` is reassigned to'. Notice I repeat that it's a local variable, I don't think this is necessary, but it's my style preference. I would emphasize that the String object is a new or different object: 'local variable `a` is reassigned to a new String object `"Goodbye"`'. Notice I format string values with backticks and double quotes. That again is a style preference, I think formating with only the double quotes is fine. Just keep your formatting consistent. Though variable and method names should definetely be formatted with backticks.

5. Second paragraph, second sentence: ', meaning `a` and `b` no longer point to the same object -- `a` points to the String object with the value "Goodbye", whichle `b` still points to the String object with the value "Hello"'. I like that you emphasize that the local variables no longer point to the same object, though I would make it a seperate sentence (replace comma with period) and remove 'meaning': '. local variables `a` and `b` now each point to different String objects'. Both 'point to' and 'reference' are correct, just be sure to pick one and stay consistent. I'm not sure if this part is necessary '-- `a` points to the String object with the value "Goodbye", whichle `b` still points to the String object with the value "Hello"'. I replaced it with a sentence connecting the local variables with the `puts` methods calls: 'Local variable `a` references the String object `"Goodbye"` when it is passed as an argument to the `puts` method call on line 7. Local variable `b` references the String object `"Hello"` when it is passed as an argument to the `puts` method call on line 8.'

6. Third and fourth paragraph about the `puts` method calls' outputs. I would restructure your answer to answer the question directly first. The question was what do the `puts` methods calls on line X and X output. Answer that, then explain in detail why.

8. Third paragraph again: 'As a result, on line 7 when we call the puts method and pass the variable `a` as an argument, "Goodbye" is output to the screen'. You can abbreviate this significantly, see my full edited answer below for reference.

7. Last paragraph: 'This question illustrates the concept of variables as pointers as re-assigning `a` did not impact the object pointed to by `b`'. First, I believe it is the code snippet or your answer that illustrates the concept, not the question. Though that's nitpicky. I think the explanation ' as re-assigning `a` did not impact the object pointed to by `b`' is a bit weak, though I can't say specifically what's wrong. I think it's because it's just one part of what the wider concept is about. I would rephrase this paragraph to something like this: 'This code example shows that variables in Ruby act a pointers to objects. Assigning a variable to another variable assigns it to the object other variables references. Reassigning a variable makes a reference a new object, but doesn't mutate the original object.'

Edited Answer:

On line 7, the `puts` method call with local variable `a` passed in as an argument outputs `"Goodbye"`. On line 8, the `puts` method call with local variable `b` passed in as an argument outputs `"Hello"`.

On line 4, local variable `a` is initalized to the String object `"Hello"`. On line 5, local variable `b` is initalized to the same String object local variable `a` references. Now, both local variables `a` and `b` reference the same object. On line 6, local variable `a` is reassigned to a new String object `"Goodbye"`. local variables `a` and `b` now each reference different String objects. Local variable `a` references the String object `"Goodbye"` when it is passed as an argument to the `puts` method call on line 7. Local variable `b` references the String object `"Hello"` when it is passed as an argument to the `puts` method call on line 8.

This code example shows that variables in Ruby act a pointers to objects. Assigning a variable to another variable assigns it to the object other variables references. Reassigning a variable makes a reference a new object, but doesn't mutate the original object.

=end
