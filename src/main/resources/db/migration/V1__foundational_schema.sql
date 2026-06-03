-- Table: users
CREATE TABLE users
(
    id       BIGINT IDENTITY(1,1) PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    email    VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- Table: addresses
CREATE TABLE addresses
(
    id       BIGINT IDENTITY(1,1) PRIMARY KEY,
    street   VARCHAR(255) NOT NULL,
    city     VARCHAR(255) NOT NULL,
    zip      VARCHAR(255) NOT NULL,
    state    VARCHAR(255) NOT NULL,
    user_id  BIGINT NOT NULL,
    CONSTRAINT addresses_users_id_fk
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

-- Table: profiles
CREATE TABLE profiles
(
    id             BIGINT PRIMARY KEY,
    bio            VARCHAR(MAX),
    phone_number   VARCHAR(15),
    date_of_birth  DATE,
    loyalty_points INT DEFAULT 0,
    FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: tags
CREATE TABLE tags
(
    id   INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: user_tags (join table)
CREATE TABLE user_tags
(
    user_id BIGINT NOT NULL,
    tag_id  INT NOT NULL,
    PRIMARY KEY (user_id, tag_id),
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
);

-- Table: categories
CREATE TABLE categories
(
    id   TINYINT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: products
CREATE TABLE products
(
    id            BIGINT IDENTITY(1,1) PRIMARY KEY,
    name          VARCHAR(255) NOT NULL,
    price         DECIMAL(10, 2) NOT NULL,
    description   VARCHAR(MAX) NOT NULL,
    category_id   TINYINT,
    CONSTRAINT fk_category
        FOREIGN KEY (category_id) REFERENCES categories (id)
            ON DELETE NO ACTION
);

-- Table: wishlist
CREATE TABLE wishlist
(
    product_id BIGINT NOT NULL,
    user_id    BIGINT NOT NULL,
    CONSTRAINT pk_wishlist PRIMARY KEY (product_id, user_id),
    CONSTRAINT fk_wishlist_on_product
        FOREIGN KEY (product_id) REFERENCES products (id)
            ON DELETE CASCADE,
    CONSTRAINT fk_wishlist_on_user
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

GO

-- Procedure: findProductsByPrice
CREATE PROCEDURE findProductsByPrice
    @minPrice DECIMAL(10, 2),
    @maxPrice DECIMAL(10, 2)
AS
BEGIN
    SELECT id, name, description, price, category_id
    FROM products
    WHERE price BETWEEN @minPrice AND @maxPrice
    ORDER BY name;
END

GO
