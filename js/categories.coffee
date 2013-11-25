---
---

category = window.location.hash.replace('#', '')

categoryListing = document.getElementById "category-#{category}"
categoryListing?.classList.remove 'hidden'

if not categoryListing
  categories = document.querySelectorAll '.hidden.category'
  for i in [0...categories.length]
    categories[i].classList?.remove 'hidden'
