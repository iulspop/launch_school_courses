function fizzbuzz() {
  times(100, (i) => {
    let isMultipleOf3 = i % 3 === 0;
    let isMultipleOf5 = i % 5 === 0;

    let output = checkCases([
      {condition: (isMultipleOf3 && isMultipleOf5), value: 'FizzBuzz'},
      {condition: isMultipleOf3,                    value: 'Fizz'},
      {condition: isMultipleOf5,                    value: 'Buzz'},
      {condition: "default",                        value: i}
    ])

    console.log(output)
  })
}

function times(number, callback) {
  for (let i = 1; i <= number; i++) {
    callback(i)
  }
}

function checkCases(cases) {
  return iterate(cases, kase => { if (kase.condition) { return kase.value } });
}

function iterate(array, callback) {
  for (let i = 0; i < array.length; i++) {
    let item = array[i];
    let value = callback(item);
    if (value) { return value }
  }
}

fizzbuzz()
