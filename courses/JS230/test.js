console.log(document.querySelector("input[name='email']"));

timesCalled = 0;
function walk(node) {
  ++timesCalled;
  console.log(node.nodeName);
  if (node.childNodes.length === 0) {
    return;
  }
  each(node.childNodes, walk);
}

function each(collection, fn) {
  for (let i = 0; i < collection.length; i++) {
    const element = collection[i];
    fn(element);
  }
}

walk(document);
console.log(timesCalled);
