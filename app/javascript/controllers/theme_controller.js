import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "label"]

  connect() {
    // ページ読み込み時に保存されたテーマを適用
    const saved = localStorage.getItem("theme")
    if (saved) {
      this.apply(saved)
    } else {
      // システム設定に基づいてデフォルトを設定
      const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
      this.apply(prefersDark ? "dark" : "light")
    }
  }

  toggle() {
    const isDark = document.documentElement.classList.contains("dark")
    this.apply(isDark ? "light" : "dark")
  }

  apply(mode) {
    if (mode === "dark") {
      document.documentElement.classList.add("dark")
      localStorage.setItem("theme", "dark")
    } else {
      document.documentElement.classList.remove("dark")
      localStorage.setItem("theme", "light")
    }

    // ラベルを更新（存在する場合）
    if (this.hasLabelTarget) {
      this.labelTarget.textContent = mode === "dark" ? "ライトモードに切替" : "ダークモードに切替"
    }
  }
}
