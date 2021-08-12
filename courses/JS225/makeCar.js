function makeCar(accelRate, breakRate) {
  return {
    speed: 0,
    accelRate,
    breakRate,
    accelerate() {
      this.speed += this.accelRate;
    },
    brake() {
      this.speed -= this.breakRate;
      if (this.speed < 0) { this.speed = 0 }
    }
  }
}

let hatchback = makeCar(9);