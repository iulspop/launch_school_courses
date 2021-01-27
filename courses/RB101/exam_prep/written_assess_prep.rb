=begin
===== PROBLEM =====
What will line 9 log to the console and why?

/*0*/ let greeting = ["Hello"];
/*1*/
/*2*/ const test = arr => {
/*3*/ arr = ["ByeBye"];
/*4*/ arr.push("World!");
/*5*/ return arr;
/*6*/ }
/*7*/
/*8*/ test(greeting);
/*9*/ console.log(greeting);
=end

=begin
===== SOLUTION =====
It will log `["Hello"]` to the console.
When we call the function `test` on line 8, the parameter `arr` references the same array as the variable `greeting`. 
When `arr` is re-assigned on line 3, it no longer references the same array as the variable 'greeting'.
Mutating changes called on `arr` no longer affect the array `greeting` references, since `arr` now references another array.
Therefore, calling console.log on line 9 will print the array `["Hello"]` unchanged.

==== TRY SOLUTION AGAIN ====

** START WITH ANSWERING THE QUESTION **
On line 9, `console.log` function call prints `["Hello"]` to the console because:
  1) The global variable `greeting` is not reassigned in the body of the function `test`
  2) The object that `greeting` points to is not mutated within the function 'test'.

** THEN EXPLAIN IN DETAIL ONLY THE LINES THAT ARE RELEVANT TO ANSWER **
On line 3, the `arr` parameter is reassigned to the new array `["ByeBye"]`.
The parameter `arr` no longer references the same object as `greeting`.
From now, we can't mutate the object the `greeting` variable points to, because `arr` references a different object.


=end