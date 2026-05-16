const searchInput = document.getElementById('searchInput');
const siteHeader = document.getElementById('siteHeader');
const cancelSearch = document.getElementById('cancelSearch');

if (searchInput && siteHeader && cancelSearch) {
  searchInput.addEventListener('focus', () => {
    siteHeader.classList.add('search-active');
  });

  cancelSearch.addEventListener('click', () => {
    siteHeader.classList.remove('search-active');
    searchInput.value = '';
  });
}
