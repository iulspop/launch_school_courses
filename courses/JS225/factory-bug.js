function createPayment(services = {}) {
  let obj = {};
  Object.keys(services).forEach(key => {
    obj[key] = services[key];
  })

  function total() {
    if (this.hasOwnProperty('amount')) {
      console.log('this was executed')
      return this.amount;
    } else {
      console.log(Object.values(this)) // [ 2000, 3000, [Function: bound total] ]
      return Object.values(this).reduce((sum, value) => sum + value)
    }
  }
  obj.total = total.bind(obj);

  return obj;
}

let payment = createPayment({phone: 2000, internet: 3000});
console.log(payment.total()) // => 5000function () { [native code] }
