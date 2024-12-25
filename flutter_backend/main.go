package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	_ "github.com/lib/pq"
	"github.com/rs/cors"
)

type Product struct {
	ID          int    `json:"product_id"`
	Name        string `json:"p_name"`
	Description string `json:"p_desc"`
	Price       int    `json:"p_cost"`
	ImageUrl    string `json:"image_url"`
	IsLiked     bool   `json:"is_liked"`
	IsInCart    bool   `json:"is_in_art"`
}

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = "qwerty"
	dbname   = "Korporativki10"
)

func connectDB() (*sql.DB, error) {
	connStr := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}
	return db, nil
}

func getProducts(w http.ResponseWriter, r *http.Request) {
	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	rows, err := db.Query("SELECT product_id, p_name, p_desc, p_cost, image_url, is_liked, is_in_cart FROM products")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var product Product
		if err := rows.Scan(&product.ID, &product.Name, &product.Description, &product.Price, &product.ImageUrl, &product.IsLiked, &product.IsInCart); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		products = append(products, product)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}

func removeFromWishlist(w http.ResponseWriter, r *http.Request) {
	// Получаем product_id и user_id из параметров запроса
	productID := r.URL.Query().Get("product_id")
	userID := r.URL.Query().Get("user_id")

	if productID == "" || userID == "" {
		http.Error(w, "Missing product_id or user_id parameter", http.StatusBadRequest)
		return
	}

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Удаляем запись из таблицы wishlist
	result, err := db.Exec("DELETE FROM whishlist WHERE product_id = $1 AND user_id = $2", productID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Проверяем, была ли удалена хотя бы одна запись
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if rowsAffected == 0 {
		http.Error(w, "No matching record found", http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// func getProductsInCart(w http.ResponseWriter, r *http.Request) {
// 	db, err := connectDB()
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		return
// 	}
// 	defer db.Close()

// 	rows, err := db.Query("SELECT id, name, description, price, image_url, is_liked, is_in_cart FROM products WHERE is_in_cart = true")
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		return
// 	}
// 	defer rows.Close()

// 	var products []Product
// 	for rows.Next() {
// 		var product Product
// 		if err := rows.Scan(&product.ID, &product.Name, &product.Description, &product.Price, &product.ImageUrl, &product.IsLiked, &product.IsInCart); err != nil {
// 			http.Error(w, err.Error(), http.StatusInternalServerError)
// 			return
// 		}
// 		products = append(products, product)
// 	}

// 	w.Header().Set("Content-Type", "application/json")
// 	json.NewEncoder(w).Encode(products)
// }

func addToWishlist(w http.ResponseWriter, r *http.Request) {
	// Получаем product_id и user_id из параметров запроса
	productID := r.URL.Query().Get("product_id")
	userID := r.URL.Query().Get("user_id")

	if productID == "" || userID == "" {
		http.Error(w, "Missing product_id or user_id parameter", http.StatusBadRequest)
		return
	}

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Вставляем новую запись в таблицу wishlist
	_, err = db.Exec("INSERT INTO whishlist (product_id, user_id) VALUES ($1, $2)", productID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

// func toggleCart(w http.ResponseWriter, r *http.Request) {
// 	// Получаем id из параметров запроса
// 	id := r.URL.Query().Get("id")
// 	if id == "" {
// 		http.Error(w, "Missing id parameter", http.StatusBadRequest)
// 		return
// 	}

// 	db, err := connectDB()
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		return
// 	}
// 	defer db.Close()

// 	_, err = db.Exec("UPDATE products SET is_in_cart = NOT is_in_cart WHERE id = $1", id)
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		return
// 	}

// 	w.WriteHeader(http.StatusNoContent)
// }

// func deleteProduct(w http.ResponseWriter, r *http.Request) {
// 	// Получаем id из параметров запроса
// 	id := r.URL.Query().Get("id")
// 	if id == "" {
// 		http.Error(w, "Missing id parameter", http.StatusBadRequest)
// 		return
// 	}

// 	db, err := connectDB()
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		return
// 	}
// 	defer db.Close()

// 	_, err = db.Exec("DELETE FROM products WHERE id = $1", id)
// 	if err != nil {
// 		http.Error(w, err.Error(), http.StatusInternalServerError)
// 		return
// 	}

// 	w.WriteHeader(http.StatusNoContent)
// }

func getPersonalWishlist(w http.ResponseWriter, r *http.Request) {
	// Получаем user_id из параметров запроса
	userID := r.URL.Query().Get("user_id")

	if userID == "" {
		http.Error(w, "Missing user_id parameter", http.StatusBadRequest)
		return
	}

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Выполняем запрос для получения информации о продуктах из wishlist
	query := `
		SELECT p.product_id, p.p_name, p.p_desc, p.p_cost, p.image_url, p.is_liked, p.is_in_cart
		FROM whishlist w
		JOIN products p ON w.product_id = p.product_id
		WHERE w.user_id = $1
	`
	rows, err := db.Query(query, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	// Создаем срез для хранения результатов
	var wishlist []struct {
		ProductID          int     `json:"product_id"`
		ProductName        string  `json:"p_name"`
		ProductDescription string  `json:"p_desc"`
		ProductPrice       float64 `json:"p_cost"`
		ProductURL         string  `json:"image_url"`
		ProductIsLiked     bool    `json:"is_liked"`
		ProductIsInCart    bool    `json:"is_in_cart"`
	}

	for rows.Next() {
		var item struct {
			ProductID          int     `json:"product_id"`
			ProductName        string  `json:"p_name"`
			ProductDescription string  `json:"p_desc"`
			ProductPrice       float64 `json:"p_cost"`
			ProductURL         string  `json:"image_url"`
			ProductIsLiked     bool    `json:"is_liked"`
			ProductIsInCart    bool    `json:"is_in_cart"`
		}
		if err := rows.Scan(&item.ProductID, &item.ProductName, &item.ProductDescription, &item.ProductPrice, &item.ProductURL, &item.ProductIsLiked, &item.ProductIsInCart); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		wishlist = append(wishlist, item)
	}

	// Проверяем наличие ошибок после завершения перебора строк
	if err := rows.Err(); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Устанавливаем заголовок ответа и возвращаем список
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(wishlist)
}

func addToCart(w http.ResponseWriter, r *http.Request) {
	// Получаем product_id и user_id из параметров запроса
	productID := r.URL.Query().Get("product_id")
	userID := r.URL.Query().Get("user_id")

	if productID == "" || userID == "" {
		http.Error(w, "Missing product_id or user_id parameter", http.StatusBadRequest)
		return
	}

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Вставляем новую запись в таблицу wishlist
	_, err = db.Exec("INSERT INTO cart (product_id, user_id) VALUES ($1, $2)", productID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func removeFromCart(w http.ResponseWriter, r *http.Request) {
	// Получаем product_id и user_id из параметров запроса
	productID := r.URL.Query().Get("product_id")
	userID := r.URL.Query().Get("user_id")

	if productID == "" || userID == "" {
		http.Error(w, "Missing product_id or user_id parameter", http.StatusBadRequest)
		return
	}

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Удаляем запись из таблицы wishlist
	result, err := db.Exec("DELETE FROM cart WHERE product_id = $1 AND user_id = $2", productID, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Проверяем, была ли удалена хотя бы одна запись
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	if rowsAffected == 0 {
		http.Error(w, "No matching record found", http.StatusNotFound)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}

func getPersonalCart(w http.ResponseWriter, r *http.Request) {
	// Получаем user_id из параметров запроса
	userID := r.URL.Query().Get("user_id")

	if userID == "" {
		http.Error(w, "Missing user_id parameter", http.StatusBadRequest)
		return
	}

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Выполняем запрос для получения информации о продуктах из wishlist
	query := `
		SELECT p.product_id, p.p_name, p.p_desc, p.p_cost 
		FROM cart c
		JOIN products p ON c.product_id = p.product_id
		WHERE c.user_id = $1
	`
	rows, err := db.Query(query, userID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	// Создаем срез для хранения результатов
	var cart []struct {
		ProductID          int     `json:"product_id"`
		ProductName        string  `json:"product_name"`
		ProductDescription string  `json:"product_description"`
		ProductPrice       float64 `json:"product_price"`
	}

	for rows.Next() {
		var item struct {
			ProductID          int     `json:"product_id"`
			ProductName        string  `json:"product_name"`
			ProductDescription string  `json:"product_description"`
			ProductPrice       float64 `json:"product_price"`
		}
		if err := rows.Scan(&item.ProductID, &item.ProductName, &item.ProductDescription, &item.ProductPrice); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		cart = append(cart, item)
	}

	// Проверяем наличие ошибок после завершения перебора строк
	if err := rows.Err(); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Устанавливаем заголовок ответа и возвращаем список
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(cart)
}

func searchProducts(w http.ResponseWriter, r *http.Request) {
	// Получаем параметры запроса
	name := r.URL.Query().Get("name")
	description := r.URL.Query().Get("description")
	minPrice := r.URL.Query().Get("min_price")
	maxPrice := r.URL.Query().Get("max_price")

	db, err := connectDB()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer db.Close()

	// Создаем базовый SQL-запрос
	query := "SELECT product_id, p_name, p_desc, p_cost, image_url, is_liked, is_in_cart FROM products WHERE 1=1"
	var args []interface{}

	// Добавляем условия фильтрации
	if name != "" {
		query += " AND p_name ILIKE $" + fmt.Sprintf("%d", len(args)+1)
		args = append(args, "%"+name+"%")
	}
	if description != "" {
		query += " AND p_desc ILIKE $" + fmt.Sprintf("%d", len(args)+1)
		args = append(args, "%"+description+"%")
	}
	if minPrice != "" {
		query += " AND p_cost >= $" + fmt.Sprintf("%d", len(args)+1)
		args = append(args, minPrice)
	}
	if maxPrice != "" {
		query += " AND p_cost <= $" + fmt.Sprintf("%d", len(args)+1)
		args = append(args, maxPrice)
	}

	// Выполняем запрос
	rows, err := db.Query(query, args...)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var product Product
		if err := rows.Scan(&product.ID, &product.Name, &product.Description, &product.Price, &product.ImageUrl, &product.IsLiked, &product.IsInCart); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		products = append(products, product)
	}

	// Проверяем наличие ошибок после завершения перебора строк
	if err := rows.Err(); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Устанавливаем заголовок ответа и возвращаем список
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(products)
}

func main() {
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"http://localhost:65044", "http://localhost:63068"}, // Добавьте ваш фронтенд
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},          // Разрешите необходимые методы
		AllowedHeaders:   []string{"Content-Type"},                                     // Разрешите необходимые заголовки
		AllowCredentials: true,
	})

	mux := http.NewServeMux()
	mux.HandleFunc("/products", getProducts)
	mux.HandleFunc("/add-whishlist", addToWishlist) // Добавление в избранное
	mux.HandleFunc("/remove-whishlist", removeFromWishlist)
	mux.HandleFunc("/show-personal-whishlist", getPersonalWishlist)
	mux.HandleFunc("/add-cart", addToCart)
	mux.HandleFunc("/remove-cart", removeFromCart)
	mux.HandleFunc("/show-personal-cart", getPersonalCart)
	mux.HandleFunc("/search-products", searchProducts)
	// mux.HandleFunc("/products/in-cart", getProductsInCart) // Новый маршрут для товаров в корзине

	// mux.HandleFunc("/toggle-cart", toggleCart)
	// mux.HandleFunc("/products/delete", deleteProduct) // Удаление товара

	// Оборачиваем наш маршрутизатор в CORS
	handler := c.Handler(mux)

	fmt.Println("Сервер запущен на :8080")
	if err := http.ListenAndServe(":8080", handler); err != nil {
		log.Fatal(err)
	}
}
