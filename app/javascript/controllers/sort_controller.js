import { Controller } from "@hotwired/stimulus"
import "@github/task-lists-element"
import { patch } from "@rails/request.js"

// To use this Stimulus controller, create a collection route named "sort"
// and wire it to the appropiate Rails controller.
// In the views, the task-list container is bound to the Stimulus controller,
// a URL value is attached with the path to the sort action.
// If everything is OK, it will flash the entire container, providing a
// visual indication.
export default class extends Controller {
  static classes = [ "success" ]
  static targets = [ "tasks" ]
  static values = {
    url: String
  }

  async move(event) {
    const {src, dst} = event.detail
    const src_list = src[0] + 1
    const src_item = src[1] + 1
    const dst_list = dst[0] + 1
    let dst_item
    if (src[1] < dst[1]) {
      dst_item = dst[1]
    } else {
      dst_item = dst[1] + 1
    }
    let data = new FormData()
    data.append("src_list", src_list)
    data.append("src_item", src_item)
    data.append("dst_list", dst_list)
    data.append("dst_item", dst_item)

    const response = await patch(this.urlValue, { body: data })
    if (response.ok) {
      this.tasksTarget.parentElement.classList.add(this.successClass)
      setTimeout(() => {
        this.tasksTarget.parentElement.classList.remove(this.successClass)
      }, 400)
    }
  }
}
