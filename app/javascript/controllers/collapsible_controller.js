import { Controller } from "@hotwired/stimulus"

// Handles collapsible help panels
export default class extends Controller {
  static targets = ["content"]

  toggle(event) {
    event.preventDefault()
    const isHidden = this.contentTarget.hidden
    
    // Toggle visibility
    this.contentTarget.hidden = !isHidden
    
    // Update button icon and text
    const button = event.currentTarget
    const icon = button.querySelector("svg path")
    const span = button.querySelector("span")
    
    if (isHidden) {
      // Opening
      span.textContent = "Hide instructions"
      button.classList.add("help-toggle--open")
      // Change icon to minus
      icon.setAttribute("d", "M4 10H16")
    } else {
      // Closing
      span.textContent = "Don't have AWS credentials? Click here for step-by-step instructions"
      button.classList.remove("help-toggle--open")
      // Change icon to plus
      icon.setAttribute("d", "M10 4V16M4 10H16")
    }
  }
}
