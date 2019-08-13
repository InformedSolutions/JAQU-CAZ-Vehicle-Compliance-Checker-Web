document.addEventListener("DOMContentLoaded", (event) => {
  if (document.body.dataset['ga'])
  {
    if (typeof gtag === 'function') {
      gtag('config', document.body.dataset.ga, {
        'page_location': event.data.url
      })
    }
  }
});
