import { Controller } from "@hotwired/stimulus"

// Handles mobile navigation menu toggle
export default class extends Controller {
  static targets = ["menu", "toggle"]

  connect() {
    // Close menu when clicking outside
    this.boundCloseOnOutsideClick = this.closeOnOutsideClick.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.boundCloseOnOutsideClick)
  }

  toggle(event) {
    event.stopPropagation()
    
    // Check which type of menu this is (dashboard or site nav)
    const isDashboard = this.menuTarget.classList.contains("dashboard-nav__menu")
    const openClass = isDashboard ? "dashboard-nav__menu--open" : "site-nav--open"
    const isOpen = !this.menuTarget.classList.contains(openClass)
    
    if (isOpen) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    // Determine which class to use
    const isDashboard = this.menuTarget.classList.contains("dashboard-nav__menu")
    const openClass = isDashboard ? "dashboard-nav__menu--open" : "site-nav--open"
    
    this.menuTarget.classList.add(openClass)
    this.toggleTarget.setAttribute("aria-expanded", "true")
    // Add listener after a short delay to prevent immediate close
    setTimeout(() => {
      document.addEventListener("click", this.boundCloseOnOutsideClick)
    }, 10)
  }

  close() {
    // Remove both possible open classes
    this.menuTarget.classList.remove("dashboard-nav__menu--open", "site-nav--open")
    this.toggleTarget.setAttribute("aria-expanded", "false")
    document.removeEventListener("click", this.boundCloseOnOutsideClick)
  }

  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}
