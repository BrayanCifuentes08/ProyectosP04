/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [  './src/**/*.html',
  './src/**/*.ts',],
  theme: {
    extend: {
      backdropBlur: {
        xs: '1.8px',  // Personalizado: desenfoque muy leve
      },
    },
  },
  plugins: [],
  darkMode: 'class'
}

