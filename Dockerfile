FROM nginx:alpine

# Копіюємо наші HTML і CSS файли в директорію /usr/share/nginx/html
COPY index.html /usr/share/nginx/html/
COPY styles.css /usr/share/nginx/html/

# Налаштування прав доступу
RUN chmod -R 755 /usr/share/nginx/html

# Nginx працює на порту 80 за замовчуванням
EXPOSE 80

# Запуск Nginx
CMD ["nginx", "-g", "daemon off;"]