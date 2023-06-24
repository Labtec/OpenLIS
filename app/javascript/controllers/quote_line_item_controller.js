import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "price", "discountValue", "discountUnit", "quantity", "total" ]

  calculateTotal() {
    this.dispatch("calculateTotal")

    const price = Number(this.priceTarget.innerHTML.replace(/[^0-9\.]+/g, ""))
    let discountUnit = this.discountUnitTarget.options[this.discountUnitTarget.selectedIndex].text

    switch(discountUnit) {
      case "$":
        this.totalTarget.textContent = numberToCurrency.format((price - this.discountValueTarget.value) * this.quantityTarget.value)
        break
      case "%":
        this.totalTarget.textContent = numberToCurrency.format((price * ( 1 - this.discountValueTarget.value / 100)) * this.quantityTarget.value)
        break
      default:
        this.totalTarget.textContent = NaN
    }
  }
}

const numberToCurrency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
})
