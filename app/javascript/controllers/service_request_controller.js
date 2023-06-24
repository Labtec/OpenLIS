import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "labTest", "panel" ]

  // When the connection is triggered,
  // grab all the checked panels.
  // For those, toggleLabTests(panels).
  connect() {
    const panels = new Array()

    this.panelTargets.forEach((panel) => {
      if (panel.checked) {
        panels.push(panel)
      }
    })
    this.toggleLabTests(panels)
  }

  // When the select action is triggered, besides `event.target`,
  // grab all the checked panels as well.
  // For those, toggleLabTests(panels).
  select(event) {
    const panels = new Array()

    panels.push(event.target)
    this.panelTargets.forEach((panel) => {
      if (panel.checked && panel != event.target) {
        panels.push(panel)
      }
    })
    this.toggleLabTests(panels)
  }

  // Before submitting the form, enable all lab tests.
  submit() {
    this.labTestTargets.forEach((labTest) => {
      labTest.disabled = false
    })
  }

  // Check/un-check lab tests belonging to a panel.
  // When a panel is unchecked:
  // - If this is a new Order, uncheck and enable all its lab tests
  // - If this is an existing Order, enable (do not uncheck) all its lab tests
  toggleLabTests(panels) {
    panels.forEach((panel) => {
      const labTestIds = JSON.parse(panel.getAttribute("data-lab-test-ids"))

      if (panel.checked) {
        labTestIds.forEach((id) => {
          let labTest = document.getElementById(`accession_lab_test_ids_${id}`)

          labTest.checked = true
          labTest.disabled = true
        })
      } else {
        labTestIds.forEach((id) => {
          let labTest = document.getElementById(`accession_lab_test_ids_${id}`)

          if (event.params.newOrder) {
            labTest.checked = false
          }
          labTest.disabled = false
        })
      }
    })
  }
}
