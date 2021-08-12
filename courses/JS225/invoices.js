let invoices = {
  unpaid: [],
  paid: [],
  add(clientName, amount) {
    this.unpaid.push({clientName, amount})
  },
  totalDue() {
    return this.unpaid.reduce((total, invoice) => invoice.amount + total, 0)
  },
  totalPaid() {
    return this.paid.reduce((total, invoice) => invoice.amount + total, 0)
  },
  payInvoice(clientName) {
    let unpaid = [];
    this.unpaid.forEach(invoice => {
      if (invoice.clientName === clientName) { this.paid.push(invoice) }
      else { unpaid.push(invoice) }
    })
    this.unpaid = unpaid
  }
}

invoices.add('Due North Development', 250);
invoices.add('Moonbeam Interactive', 187.50);
invoices.add('Slough Digital', 300);
console.log(invoices.totalDue());

invoices.payInvoice('Due North Development');
invoices.payInvoice('Slough Digital');
console.log(invoices.totalPaid());
console.log(invoices.totalDue());