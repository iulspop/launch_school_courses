// if all positive, sum entire array
// if only negative, return zero
// empty array return zero

/*
algo:
check empty
check all postive
check all negative

get all contiguous subarrays
  [0, 1, 2, 3]
  init subarrays
  iterate from 1 to number of elements, |slice size|
    iterate from index 0 to number of elements - slise size |start index|
      push to subarrays
  start index, number of elements
  0, 1
  1, 1
  2, 1
  3, 1

  0, 2
  1, 2
  2, 2

  0, 3
  1, 3

  0, 4

map subarrays with sum

return max sum

*/

function maxSequence(numbers) {
  if (numbers.length == 0)       { return 0 }
  if (numbers.every(isPositive)) { return sum(numbers) }
  if (numbers.every(isNegative)) { return 0 }

  let subSequences = getSubSequences(numbers);

  let sums = subSequences.map(subSequence => sum(subSequence));

  let maxSum = max(sums);

  return maxSum;
}

const isPositive = num => num >= 0;
const isNegative = num => num <= 0;

const add = (accumulator, number) => accumulator + number;
const sum = numbers => numbers.reduce(add);

const getMax = (a, b) => Math.max(a, b);
const max = numbers => numbers.reduce(getMax);

const getSubSequences = (array) => {
  let subSequences = []
  for (let sliceSize = 1; sliceSize <= array.length; sliceSize++) {
    for (let index = 0; index <= array.length - sliceSize; index++) {
      subSequences.push(array.slice(index, index + sliceSize))
    }
  }
  return subSequences;
}

console.log(maxSequence([-1, 0, 1, 2, 3]) === 6)
console.log(maxSequence([]) === 0); // true
console.log(maxSequence([-2, 1, -3, 4, -1, 2, 1, -5, 4]) === 6); // true
console.log(maxSequence([11]) === 11); // true
console.log(maxSequence([-32]) === 0); // true
console.log(maxSequence([-2, 1, -7, 4, -10, 2, 1, 5, 4]) === 12); // true