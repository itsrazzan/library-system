<?php
/**
 * Application Constants
 * Global configuration values
 */

// Penalty Configuration
define('PENALTY_BASE_RATE', 2000);  // Rp 2.000 per hari terlambat
define('PENALTY_TYPE', 'linear');   // 'linear' = base × hari

// Loan Configuration
define('LOAN_DURATION_DAYS', 14);   // Durasi pinjaman default (14 hari)
define('MAX_LOANS_PER_USER', 3);    // Maksimal buku yang bisa dipinjam sekaligus

// Search Configuration  
define('SEARCH_LIMIT', 20);         // Limit hasil pencarian
?>
