import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    const saved = localStorage.getItem("theme")
    if (saved) this.apply(saved)
    this.updateButton()
  }

  toggle() {
    const isDark = document.documentElement.classList.contains("dark")
    this.apply(isDark ? "light" : "dark")
    this.updateButton()
  }

  apply(mode) {
    if (mode === "dark") {
      document.documentElement.classList.add("dark")
      localStorage.setItem("theme", "dark")
    } else {
      document.documentElement.classList.remove("dark")
      localStorage.setItem("theme", "light")
    }
  }

  updateButton() {
    const isDark = document.documentElement.classList.contains("dark")
    if (this.hasButtonTarget) this.buttonTarget.textContent = isDark ? "Light Mode" : "Dark Mode"
  }
}
