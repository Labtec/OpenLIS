import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "province", "district", "corregimiento", "line", "map" ]

  connect() {
    // Load all districts and corregimientos
    this.allDistricts = Array.from(this.districtTarget.getElementsByTagName("optgroup"))
    this.allCorregimientos = Array.from(this.corregimientoTarget.getElementsByTagName("optgroup"))

    // If an address field and its predecessor are empty, disable it
    // Otherwise, filter the next selection based upon it
    if ((this.districtTarget.value === "" && this.provinceTarget.value === "") || this.provinceTarget.value === "Guna Yala") {
      this.districtTarget.disabled = true
    } else {
      if (this.districtTarget.value === "") {
        this.filterDistricts()
        this.districtTarget.add(document.createElement("option"), this.districtTarget[0])
        this.districtTarget.value = ""
      } else {
        this.filterDistricts()
      }
    }

    if (this.corregimientoTarget.value === "" && this.districtTarget.value === "" && this.provinceTarget.value != "Guna Yala") {
      this.corregimientoTarget.disabled = true
    } else {
      if (this.corregimientoTarget.value === "") {
        this.filterCorregimientos()
        this.corregimientoTarget.add(document.createElement("option"), this.corregimientoTarget[0])
        this.corregimientoTarget.value = ""
      } else {
        this.filterCorregimientos()
      }
    }

    if (this.lineTarget.value === "" && this.corregimientoTarget.value === "") {
      this.lineTarget.disabled = true
    }

    if (this.provinceTarget.value === "") {
      this.mapTarget.hidden = true
    } else {
      this.mapTarget.hidden = false
    }
  }

  // Before submitting the form, enable disabled fields (in the case of Guna Yala).
  submit() {
    if (this.provinceTarget.value === "Guna Yala") {
      this.districtTarget.disabled = false
    }
  }

  // Triggered when a province is selected
  select_province() {
    let allDistricts = this.allDistricts
    let allCorregimientos = this.allCorregimientos

    // When the province is cleared:
    if (this.provinceTarget.value === "") {
      // Empty all selection boxes and the address line
      this.districtTarget.add(document.createElement("option"), this.districtTarget[0])
      this.districtTarget.value = ""
      this.corregimientoTarget.add(document.createElement("option"), this.corregimientoTarget[0])
      this.corregimientoTarget.value = ""
      this.lineTarget.value = ""
      // Restore all selection boxes
      this.districtTarget.innerHTML = allDistricts.innerHTML
      this.corregimientoTarget.innerHTML = allCorregimientos.innerHTML
      // Disable all selection boxes
      this.districtTarget.disabled = true
      this.corregimientoTarget.disabled = true
      // Hide the link to the map
      this.mapTarget.hidden = true
    } else {
      // When a province is selected:
      // If the province is Guna Yala:
      if (this.provinceTarget.value === "Guna Yala") {
        // Clear and disable the selection of a district
        this.districtTarget.add(document.createElement("option"), this.districtTarget[0])
        this.districtTarget.value = ""
        this.districtTarget.disabled = true
        // Filter corregimientos accordingly
        this.filterCorregimientos()
        // Clear and enable the selection of corregimientos
        this.corregimientoTarget.add(document.createElement("option"), this.corregimientoTarget[0])
        this.corregimientoTarget.value = ""
        this.corregimientoTarget.disabled = false
      } else {
        // Clear and enable the selection of filtered districts
        this.filterDistricts()
        this.districtTarget.add(document.createElement("option"), this.districtTarget[0])
        this.districtTarget.value = ""
        this.districtTarget.disabled = false
        // Clear and disable the selection of a corregimiento
        this.corregimientoTarget.add(document.createElement("option"), this.corregimientoTarget[0])
        this.corregimientoTarget.add(document.createElement("option"), this.corregimientoTarget[0])
        this.corregimientoTarget.value = ""
        this.corregimientoTarget.disabled = true
      }
      // Display the link to the map
      this.mapTarget.hidden = false
      this.mapTarget.href = `https://www.google.com/maps/place/+${this.provinceTarget.value}+Panamá`
    }
    // Disable the address line
    this.lineTarget.disabled = true
  }

  // Triggered when a district is selected
  select_district() {
    let allCorregimientos = this.allCorregimientos
    // When the district is cleared:
    if (this.districtTarget.value === "") {
      // Empty the selection of a corregimiento
      this.corregimientoTarget.value = ""
      // Restore the selection of a corregimiento
      this.corregimientoTarget.innerHTML = allCorregimientos.innerHTML
      // Disable the selection of a corregimiento
      this.corregimientoTarget.disabled = true
    } else {
      // When the district is selected:
      // Clear and enable the selection of filtered corregimientos
      this.filterCorregimientos()
      this.corregimientoTarget.add(document.createElement("option"), this.corregimientoTarget[0])
      this.corregimientoTarget.value = ""
      this.corregimientoTarget.disabled = false
    }
    // Update the map
    this.mapTarget.href = `https://www.google.com/maps/place/+${this.districtTarget.value}+${this.provinceTarget.value}+Panamá`
    // Disable the address line
    this.lineTarget.disabled = true
  }

  // Triggered when a corregimiento is selected
  select_corregimiento() {
    // When the corregimiento is cleared:
    if (this.corregimientoTarget.value === "") {
      // Empty the address line
      this.lineTarget.value = ""
      // Disable the address line
      this.lineTarget.disabled = true
    } else {
      // When a district is selected:
      // Enable the address line
      this.lineTarget.disabled = false
    }
    // Update the map
    this.mapTarget.href = `https://www.google.com/maps/place/+${this.corregimientoTarget.value}+${this.districtTarget.value}+${this.provinceTarget.value}+Panamá`
  }

  // Filters districts based upon the selected province
  // All but Guna Yala have districts
  filterDistricts() {
    if (this.provinceTarget.value === "" || this.provinceTarget.value === "Guna Yala") {
      this.districtTarget.value = ""
    } else {
      let allDistricts = this.allDistricts
      this.districtTarget.innerHTML = allDistricts.find((province) => province.label === this.provinceTarget.value).innerHTML
    }
  }

  // Filter corregimientos based upon the selected district,
  // or province, in the case of Guna Yala
  filterCorregimientos() {
    let allCorregimientos = this.allCorregimientos
    if (this.districtTarget.value === "") {
      if (this.provinceTarget.value === "Guna Yala") {
        this.corregimientoTarget.innerHTML = allCorregimientos.find((province) => province.label === "Guna Yala").innerHTML
      } else {
        this.corregimientoTarget.value = ""
      }
    } else {
      this.corregimientoTarget.innerHTML = allCorregimientos.find((district) => district.label === this.districtTarget.value).innerHTML
    }
  }
}
