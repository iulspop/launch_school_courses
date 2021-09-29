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

/*
take old tree => intermediate reperesntation (Virtual DOM)
  is intermediate representation inneficient unnecesary?
take new tree => intermediate repesentation (Virtual DOM)

declarativeRender(component)
  knows old Virtual DOM from last render
  creates new Virtual DOM
  compare to know which changed
  go over actual DOM, and 

map === the boolean value
  how does react make diff between identity and equality?
  - key? whatever is given to render, list a post => the post id
  - structural identification?
  - simple solution: assign unique num for each node

take old tree, walk, when boolean true,
take value from new tree and replace old value.
*/
