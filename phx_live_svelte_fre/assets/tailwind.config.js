/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./js/**/*.{js,svelte}",
    "../lib/*_web/**/*.{ex,heex}",
    "../lib/*_web/**/*_live.ex"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography")
  ],
}
