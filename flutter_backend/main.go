package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
)

type Product struct {
	ID          int    `json:"id"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Price       int    `json:"price"`
	ImageUrl    string `json:"imageUrl"`
	IsLiked     bool   `json:"IsLiked"`
	IsInCart    bool   `json:"isInCart"`
}

// Переменная для хранения продуктов
var products = []Product{
	{ID: 0, Name: "iPhone", Description: "iPhone — самый стильный телефон", Price: 1000, ImageUrl: "lib/assets/images/iphone.jpeg", IsLiked: false, IsInCart: true},
	{ID: 1, Name: "Pixel", Description: "Pixel — самый многофункциональный телефон", Price: 800, ImageUrl: "lib/assets/images/pixel.jpg", IsLiked: false, IsInCart: false},
	{ID: 2, Name: "popka", Description: "fbwyefvb", Price: 1488, ImageUrl: "", IsLiked: false, IsInCart: true},
}

func main() {
	// Установка обработчиков для маршрутов
	http.HandleFunc("/products", getProducts)
	http.HandleFunc("/toggle-like", toggleLike)
	http.HandleFunc("/toggle-cart", toggleCart)
	http.HandleFunc("/delete-product", deleteProduct) // Новый маршрут для удаления продукта
	http.HandleFunc("/cart-items", getCartItems)      // Новый маршрут для получения товаров в корзине

	// Запуск сервера
	port := ":8080"
	fmt.Printf("Сервер запущен на порту %s\n", port)
	if err := http.ListenAndServe(port, nil); err != nil {
		fmt.Println("Ошибка при запуске сервера:", err)
	}
}

func getProducts(w http.ResponseWriter, r *http.Request) {
	// Установка заголовков CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	fmt.Println("Получен запрос на /products")
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}

func toggleLike(w http.ResponseWriter, r *http.Request) {
	// Установка заголовков CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	productIDStr := r.URL.Query().Get("id")
	productID, err := strconv.Atoi(productIDStr)
	if err != nil || productID < 0 || productID >= len(products) {
		http.Error(w, "Неверный ID продукта", http.StatusBadRequest)
		return
	}
	fmt.Println("Получен запрос на /like")
	products[productID].IsLiked = !products[productID].IsLiked
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products[productID])
}

func toggleCart(w http.ResponseWriter, r *http.Request) {
	// Установка заголовков CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	productIDStr := r.URL.Query().Get("id")
	productID, err := strconv.Atoi(productIDStr)
	if err != nil || productID < 0 || productID >= len(products) {
		http.Error(w, "Неверный ID продукта", http.StatusBadRequest)
		return
	}
	fmt.Println("Получен запрос на /cart")
	products[productID].IsInCart = !products[productID].IsInCart
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products[productID])
}

func deleteProduct(w http.ResponseWriter, r *http.Request) {
	// Установка заголовков CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "DELETE, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	productIDStr := r.URL.Query().Get("id")
	productID, err := strconv.Atoi(productIDStr)
	if err != nil || productID < 0 || productID >= len(products) {
		http.Error(w, "Неверный ID продукта", http.StatusBadRequest)
		return
	}

	fmt.Println("Получен запрос на /delete-product")

	products = append(products[:productID], products[productID+1:]...)

	w.WriteHeader(http.StatusNoContent)
}

func getCartItems(w http.ResponseWriter, r *http.Request) {
	// Установка заголовков CORS
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Methods", "GET, OPTIONS")
	w.Header().Set("Access-Control-Allow-Headers", "Content-Type")

	if r.Method == http.MethodOptions {
		w.WriteHeader(http.StatusOK)
		return
	}

	fmt.Println("Получен запрос на /cart-items")
	w.Header().Set("Content-Type", "application/json")

	var cartItems []Product
	for _, product := range products {
		if product.IsInCart {
			cartItems = append(cartItems, product)
		}
	}

	json.NewEncoder(w).Encode(cartItems)
}
