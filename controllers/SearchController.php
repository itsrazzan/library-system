<?php
/**
 * Book Search Controller
 * Server-side search using B-tree indexed columns
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/Book.php';

$query = isset($_GET['q']) ? trim($_GET['q']) : '';
$limit = isset($_GET['limit']) ? min((int)$_GET['limit'], 50) : 20;

// Minimum 2 characters for search
if (strlen($query) < 2) {
    echo json_encode([
        'success' => false,
        'message' => 'Query minimal 2 karakter',
        'data' => []
    ]);
    exit;
}

try {
    $database = new Database();
    $conn = $database->getConnection();
    
    if (!$conn) {
        throw new Exception('Database connection failed');
    }
    
    $book = new Book($conn);
    $result = $book->searchBooks($query, $limit);
    
    if ($result) {
        $books = $result->fetchAll(PDO::FETCH_ASSOC);
        
        // Fix image paths for display
        foreach ($books as &$b) {
            $b['image_url'] = !empty($b['image_path']) 
                ? '/NOVA-Library/' . $b['image_path']
                : '/NOVA-Library/public/img/books/default-book.jpg';
        }
        
        echo json_encode([
            'success' => true,
            'count' => count($books),
            'data' => $books
        ]);
    } else {
        echo json_encode([
            'success' => true,
            'count' => 0,
            'data' => []
        ]);
    }
} catch (Exception $e) {
    error_log("Search Error: " . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'Terjadi kesalahan saat mencari',
        'data' => []
    ]);
}
?>
