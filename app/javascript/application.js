document.addEventListener("turbo:load", () => {
  const btn = document.getElementById("themeToggle");
  if (!btn) return;

  const apply = (isDark) => {
    document.documentElement.classList.toggle("dark", isDark);
    btn.textContent = isDark ? "Light Mode" : "Dark Mode";
  };

  const saved = localStorage.getItem("theme");
  apply(saved === "dark");

  btn.addEventListener("click", () => {
    const isDark = !document.documentElement.classList.contains("dark");
    localStorage.setItem("theme", isDark ? "dark" : "light");
    apply(isDark);
  });
});
