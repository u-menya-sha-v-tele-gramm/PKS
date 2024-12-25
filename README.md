Практика 12

Маркин Егор

ЭФБО-02-22

Переписана БД, добавлены несколько таблиц: wishlist и cart 

![image](https://github.com/user-attachments/assets/06a5ea3c-af21-4ae1-8fe6-a5ef2fc27ee7)
![image](https://github.com/user-attachments/assets/4ba1f9e5-bfd8-4ba4-a243-13ff4894ddee)


Для того чтобы узнать wishlist или cart требуется id пользователя который берется из supabase

![image](https://github.com/user-attachments/assets/81463426-ffde-4a62-ac85-b4270ad5e237)


Написана функция отвечающая за фильтрацию и поиск


`func searchProducts(w http.ResponseWriter, r *http.Request) {
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

}`


 ![image](https://github.com/user-attachments/assets/850cd036-16f4-472a-9b0d-e4e48f9ef6fa)
 ![image](https://github.com/user-attachments/assets/0c4c1d29-4cf5-440a-9a29-e68dbaccd4ec)

