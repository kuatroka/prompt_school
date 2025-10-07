/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    '../lib/**/*.{ex,exs,heex}',
    './js/**/*.js'
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
}
