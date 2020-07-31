window.addEventListener('DOMContentLoaded', () => {
  const localeSelector = document.querySelector('.locale-selector select');

  localeSelector.addEventListener('change', (event) => {
    event.target.form.submit();
  });
});
