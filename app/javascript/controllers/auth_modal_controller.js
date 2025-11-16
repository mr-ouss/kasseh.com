import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="auth-modal"
export default class extends Controller {
  static targets = ["modal", "loginForm", "signupForm"]

  connect() {
    // Close modal on escape key
    this.escapeHandler = this.handleEscape.bind(this)
    document.addEventListener("keydown", this.escapeHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this.escapeHandler)
  }

  showLogin(event) {
    event.preventDefault()
    this.modalTarget.classList.add("is-active")
    this.loginFormTarget.classList.add("is-active")
    this.signupFormTarget.classList.remove("is-active")
    document.body.style.overflow = "hidden"
  }

  showSignup(event) {
    event.preventDefault()
    this.modalTarget.classList.add("is-active")
    this.signupFormTarget.classList.add("is-active")
    this.loginFormTarget.classList.remove("is-active")
    document.body.style.overflow = "hidden"
  }

  close(event) {
    if (event) {
      event.preventDefault()
    }
    this.modalTarget.classList.remove("is-active")
    this.loginFormTarget.classList.remove("is-active")
    this.signupFormTarget.classList.remove("is-active")
    document.body.style.overflow = ""
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) {
      this.close(event)
    }
  }

  handleEscape(event) {
    if (event.key === "Escape" && this.modalTarget.classList.contains("is-active")) {
      this.close()
    }
  }

  switchToLogin(event) {
    event.preventDefault()
    this.loginFormTarget.classList.add("is-active")
    this.signupFormTarget.classList.remove("is-active")
  }

  switchToSignup(event) {
    event.preventDefault()
    this.signupFormTarget.classList.add("is-active")
    this.loginFormTarget.classList.remove("is-active")
  }
}
