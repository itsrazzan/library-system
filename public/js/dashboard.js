/**
 * Dashboard JavaScript
 * Handles user profile, logout, book search, and navigation
 */

// ===== Profile Dropdown =====
document.getElementById('profileBtn')?.addEventListener('click', function(e) {
    e.stopPropagation();
    const dropdown = document.getElementById('profileDropdown');
    dropdown.classList.toggle('show');
});

document.addEventListener('click', function(e) {
    const dropdown = document.getElementById('profileDropdown');
    const profileBtn = document.getElementById('profileBtn');
    if (profileBtn && !profileBtn.contains(e.target)) {
        dropdown.classList.remove('show');
    }
});

// ===== Logout Function =====
function logout() {
    if (confirm('Anda yakin ingin keluar?')) {
        window.location.href = '/NOVA-Library/controllers/logout.php';
    }
}

// ===== Book Search =====
const searchInput = document.getElementById('searchInput');
const searchResults = document.getElementById('searchResults');
const resultsContainer = document.getElementById('resultsContainer');
const searchLoading = document.getElementById('searchLoading');
let searchTimeout;

if (searchInput) {
    searchInput.addEventListener('input', function(e) {
        const query = e.target.value.trim();
        clearTimeout(searchTimeout);

        if (query.length < 2) {
            searchResults.classList.add('hidden');
            searchLoading.classList.add('hidden');
            return;
        }

        searchLoading.classList.remove('hidden');
        searchResults.classList.add('hidden');

        searchTimeout = setTimeout(function() {
            searchBooks(query);
        }, 500);
    });
}

/**
 * Search books from database using server-side indexed search
 * @param {string} query - Search query
 */
async function searchBooks(query) {
    try {
        // Use relative path from user dashboard location
        const searchUrl = '../../controllers/SearchController.php?q=' + encodeURIComponent(query) + '&limit=10';
        console.log('Searching:', searchUrl);
        
        const response = await fetch(searchUrl);
        console.log('Response status:', response.status);
        
        if (!response.ok) throw new Error('Search failed with status: ' + response.status);
        
        const result = await response.json();
        console.log('Search result:', result);
        
        if (result.success) {
            displaySearchResults(result.data);
        } else {
            console.log('Search not successful:', result.message);
            displaySearchResults([]);
        }
    } catch (error) {
        console.error('Search error:', error);
        displaySearchResults([]);
    }
}

/**
 * Display search results
 * @param {Array} books - Array of book objects
 */
function displaySearchResults(books) {
    searchLoading.classList.add('hidden');

    if (!books || books.length === 0) {
        resultsContainer.innerHTML = '<div class="text-center py-8"><p class="text-gray-500">Buku tidak ditemukan</p></div>';
        searchResults.classList.remove('hidden');
        return;
    }

    resultsContainer.innerHTML = books.map(function(book) {
        const isAvailable = book.book_status === true || book.book_status === 't' || book.book_status === 1;
        const imagePath = book.image_url || book.image_path || '/NOVA-Library/public/img/books/default-book.jpg';
        
        return `<div class="book-result-item flex items-start space-x-4 p-4 rounded-xl cursor-pointer mb-2 hover:bg-purple-50 transition">
                    <img src="${imagePath.startsWith('/') ? imagePath : '/NOVA-Library/' + imagePath}" 
                         alt="${book.book_title}" 
                         class="w-12 h-16 object-cover rounded shadow"
                         onerror="this.src='/NOVA-Library/public/img/books/default-book.jpg'">
                    <div class="flex-1">
                        <h4 class="font-bold text-gray-900 mb-1">${book.book_title}</h4>
                        <p class="text-sm text-gray-600 mb-2">Oleh: ${book.author || 'Unknown'}</p>
                        <p class="text-xs text-gray-500 mb-2">${book.category_name || 'Umum'}</p>
                        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold ${isAvailable ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}">
                            ${isAvailable ? '✓ Tersedia' : '✗ Dipinjam'}
                        </span>
                    </div>
                </div>`;
    }).join('');

    searchResults.classList.remove('hidden');
}

// Close search results when clicking outside
document.addEventListener('click', function(e) {
    if (searchInput && !e.target.closest('#searchInput') && !e.target.closest('#searchResults')) {
        searchResults.classList.add('hidden');
    }
});

// ===== Dashboard Stats =====
async function loadDashboardStats() {
    try {
        // TODO: Create a proper stats controller
        // For now, just set default values to avoid 404 errors
        document.getElementById('borrowedCount').textContent = '-';
        document.getElementById('waitingCount').textContent = '-';
        document.getElementById('historyCount').textContent = '-';
    } catch (error) {
        console.error('Error loading stats:', error);
        document.getElementById('borrowedCount').textContent = '0';
        document.getElementById('waitingCount').textContent = '0';
        document.getElementById('historyCount').textContent = '0';
    }
}

// ===== Navigation =====
function navigateTo(page) {
    window.location.href = `/NOVA-Library/views/user/${page}`;
}

// ===== Initialize =====
document.addEventListener('DOMContentLoaded', function() {
    loadDashboardStats();
});
