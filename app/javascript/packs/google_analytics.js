document.addEventListener('turbolinks:load', () => {
  if (document.body.dataset['ga'])
  {
    if (typeof gtag === 'function') {
      gtag('config', document.body.dataset.ga, {
        'page_location': window.location.origin + window.location.pathname
      })
    }
  }
});
