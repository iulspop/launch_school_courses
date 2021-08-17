turtle = {
  a: 5,
  b: {
    a: 7,
    dragon() {
      const arrow = () => console.log(this.a)
      arrow()
    }
  }
}

turtle.dragon = turtle.b.dragon

turtle.dragon.bind(turtle.b)()