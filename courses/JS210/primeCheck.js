function isPrime(number) {
  if (number === 1 || number === 0) { return false }

  let limit = Math.sqrt(number);
  for (let divisor = 2; divisor < limit; divisor++) {
    if (number % divisor == 0) { return false }
  }

  return true;
}

console.log(isPrime(1));  // false
console.log(isPrime(2));  // true
console.log(isPrime(3));  // true
console.log(isPrime(43)); // true
console.log(isPrime(55)); // false
console.log(isPrime(0));  // false