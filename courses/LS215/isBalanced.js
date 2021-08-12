/*

match and replace with inner values until no more match
then ask if string contains parentheses

*/

function isBalanced(text) {
  while (true) {
    let match = text.match(/[^\(\)]*\((.*)\)[^\(\)]*/);
    if (!match) { break }
    let betweenParentheses = match[1];
    text = betweenParentheses;
  }
  return text.match(/[\(\)]/) ? false : true
}

console.log(isBalanced('What (is) this?'));        // true
console.log(isBalanced('What is) this?'));         // false
console.log(isBalanced('What (is this?'));         // false
console.log(isBalanced('((What) (is this))?'));    // true
console.log(isBalanced('((What)) (is this))?'));   // false
console.log(isBalanced('Hey!'));                   // true
console.log(isBalanced(')Hey!('));                 // false
console.log(isBalanced('What ((is))) up('));       // false