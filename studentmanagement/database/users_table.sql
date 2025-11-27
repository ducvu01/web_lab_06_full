CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(10) DEFAULT 'user' 
        CHECK (role IN ('admin', 'user')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL
);

-- Insert sample users
INSERT INTO users (username, password, full_name, role) VALUES
('admin', '$2a$10$1wNY5zMzIZepADZRvcck4.e5knD8GuI3nk3zXGNhS4dkT2J5mP9Vq', 'Admin User', 'admin'),
('john', '$2a$10$1wNY5zMzIZepADZRvcck4.e5knD8GuI3nk3zXGNhS4dkT2J5mP9Vq', 'John Doe', 'user'),
('jane', '$2a$10$1wNY5zMzIZepADZRvcck4.e5knD8GuI3nk3zXGNhS4dkT2J5mP9Vq', 'Jane Smith', 'user');


--I use postgresql instead of mysql