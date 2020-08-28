window.addEventListener('DOMContentLoaded', () => {
  const localeSelector = document.querySelector('[data-module="locale-selector"] select')

  if (localeSelector) {
    localeSelector.addEventListener('change', (event) => {
      event.target.form.submit()
    })
  }
})
