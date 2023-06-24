import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "linePrice", "lineQuantity", "lineTotal",
  "subtotal", "totalDiscount", "shippingAndHandling", "grandTotal" ]

  calculateTotals() {
    let linePrices = []
    let lineQuantities = []
    let lineTotals = []

    this.linePriceTargets.forEach(linePrice => linePrices.push(Number(linePrice.innerHTML.replace(/[^0-9\.]+/g, ""))))
    this.lineQuantityTargets.forEach(lineQuantity => lineQuantities.push(lineQuantity.value))
    this.lineTotalTargets.forEach(lineTotal => lineTotals.push(Number(lineTotal.innerHTML.replace(/[^0-9\.]+/g, ""))))

    let lineSubtotals = linePrices.map((linePrice, index) => linePrice * lineQuantities[index])
    let lineDiscounts = lineSubtotals.map((lineSubtotal, index) => lineSubtotal - lineTotals[index])
    let shippingAndHandling = Number(this.shippingAndHandlingTarget.value)

    this.subtotalTarget.textContent = numberToCurrency.format(lineSubtotals.reduce((a, b) => a + b, 0))
    this.totalDiscountTarget.textContent = numberToCurrency.format(lineDiscounts.reduce((a, b) => a + b, 0))
    this.grandTotalTarget.textContent = numberToCurrency.format(lineTotals.reduce((a, b) => a + b, 0) + shippingAndHandling)
  }
}

const numberToCurrency = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
})
