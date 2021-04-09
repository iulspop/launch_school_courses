let hey = "Iuliu" + " Pop";


function digits(number) {
  digit1 = number % 10;
  digit2 = ((number % 100) - digit1) / 10;
  digit3 = ((number % 1000) - digit1 - digit2) / 100;
  return [digit3, digit2, digit1];
}


console.log(digits(5478));