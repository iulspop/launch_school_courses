
function personfactory(name = 'John The Baptist', age = 2030) {
  return {
    name,
    age,
    greet() {
      console.log(`Hi, my name is ${this.name}`)
    }
  }
}

let person1 = personfactory()

function LifeForm(energy = 9900) {
  this.energy = energy;
}

LifeForm.prototype.displayEnergy = function displayEnergy() {
  console.log(this.energy)
}

// Constructor Pattern
function Person(name = 'John The Baptist', age = 2030) {
  LifeForm.call(this);
  Object.setPrototypeOf(Object.getPrototypeOf(this), LifeForm.prototype);
  this.name = name;
  this.age = age;
}

Person.prototype.greet = function greet() {
  console.log(`Hi, my name is ${this.name}`)
}

let person2 = new Person;
person2.greet()
// Object.setPrototypeOf(person2.prototype, LifeForm.prototype);
person2.displayEnergy()


console.log(Person.prototype)
console.log(Person.prototype.constructor)

console.log(Object.getPrototypeOf(person2) === person2.__proto__)
console.log(Object.getPrototypeOf(person2) === Person.prototype)

console.log(Object.getOwnPropertyNames(Object.getPrototypeOf(person2)))
console.log(person2.constructor)

console.log(Object.getOwnPropertySymbols(person2))


// OLOO Pattern?

let person3 = personfactory()

Object.setPrototypeOf(person3, {
  greet() {
    console.log(`Hi, my name is ${this.name}`)
  }
})

console.log('============================== HERE ===========================')

function turtle() {
  
}
console.log(turtle.prototype)
console.log(turtle.prototype.constructor)