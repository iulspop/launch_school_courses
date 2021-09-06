function createWalk(check) {
  let found = []
  return function walk(node) {
    if (check(node)) { found.push(node) }
    if (node.childNodes.length === 0) { return found }
    for (let i = 0; i < node.childNodes.length; i++) {
      const element = node.childNodes[i]
      walk(element)
    }
    return found
  }
}

function isScrollable(element) {
  return element.scrollHeight > element.clientHeight
}

let results = createWalk(isScrollable)(document.body);

console.log(results)
