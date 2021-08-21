// var sum = 0;
// var numbers;

// sum += 10;
// sum += 31;

// numbers = [1, 7, -3, 3];

// function sumNumbers(arr) {
//   return arr.reduce(function(sum, number) {
//     sum += number;
//     return sum;
//   }, 0);
// }

// sum += sumNumbers(numbers);  // ?


function countdown(count) {
  (function count(n) {
    if (n === -1) { return console.log('Done!') }
    console.log(n)
    count(n - 1)
  })(count)
}

countdown(7)