import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"
import { patch } from "@rails/request.js"

// To use this Stimulus controller, create a member route named "sort"
// and wire it to the appropriate Rails controller.
// In the views, the main container is bound to the Stimulus controller,
// a URL value is attached with the path to the sort action, using ":id"
// as a placeholder for the sorted element.
// The items just pass a data-id attribute with its corresponding
// database ID.
// Sortable will populate the event with the newIndex value, that is then
// passed to the Rails controller's sort action.
// If everything is OK, it will flash the entire container, providing a
// visual indication.
export default class extends Controller {
  static classes = [ "success" ]
  static values = {
    url: String
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: ".handle",
      onEnd: this.end.bind(this)
    })
  }

  async end(event) {
    let id = event.item.dataset.id
    let data = new FormData()
    data.append("position", event.newIndex)
    const response = await patch(this.urlValue.replace(":id", id), { body: data })
    if (response.ok) {
      this.element.classList.add(this.successClass)
      setTimeout(() => {
        this.element.classList.remove(this.successClass)
      }, 400)
    }
  }
}
