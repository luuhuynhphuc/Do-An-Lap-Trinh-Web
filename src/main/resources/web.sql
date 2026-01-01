/*
 Navicat Premium Dump SQL

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 90100 (9.1.0)
 Source Host           : localhost:3306
 Source Schema         : web

 Target Server Type    : MySQL
 Target Server Version : 90100 (9.1.0)
 File Encoding         : 65001

 Date: 02/01/2026 00:05:07
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for banners
-- ----------------------------
DROP TABLE IF EXISTS `banners`;
CREATE TABLE `banners`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `position` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banners
-- ----------------------------
INSERT INTO `banners` VALUES (1, 'assets/images/login/1.webp', '/list-product?categoryId=1', 'Giày chạy bộ mới', 'HOME_MAIN', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (2, '/images/banners/football.jpg', '/list-product?categoryId=2', 'Sân cỏ bùng nổ', 'HOME_SUB_1', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (3, '/images/banners/lifestyle.jpg', '/list-product?categoryId=4', 'Sneaker lifestyle', 'HOME_SUB_2', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (4, '/images/banners/sale.jpg', '/list-product?sale=1', 'Giảm giá đến 50%', 'HOME_SALE', 1, '2025-12-11 23:45:53');
INSERT INTO `banners` VALUES (5, '/images/banners/new.jpg', '/list-product?new=1', 'Hàng mới về mỗi tuần', 'HOME_NEW', 1, '2025-12-11 23:45:53');

-- ----------------------------
-- Table structure for brands
-- ----------------------------
DROP TABLE IF EXISTS `brands`;
CREATE TABLE `brands`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `slug` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of brands
-- ----------------------------
INSERT INTO `brands` VALUES (1, 'Nike', 'nike', '/images/brands/nike.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (2, 'Adidas', 'adidas', '/images/brands/adidas.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (3, 'Puma', 'puma', '/images/brands/puma.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (4, 'New Balance', 'new-balance', '/images/brands/new_balance.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (5, 'Converse', 'converse', '/images/brands/converse.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (6, 'Vans', 'vans', '/images/brands/vans.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (7, 'Asics', 'asics', '/images/brands/asics.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (8, 'Reebok', 'reebok', '/images/brands/reebok.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (9, 'Under Armour', 'under-armour', '/images/brands/under_armour.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');
INSERT INTO `brands` VALUES (10, 'Mizuno', 'mizuno', '/images/brands/mizuno.png', 1, '2025-12-11 23:45:23', '2025-12-11 23:45:23');

-- ----------------------------
-- Table structure for cart_items
-- ----------------------------
DROP TABLE IF EXISTS `cart_items`;
CREATE TABLE `cart_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int NULL DEFAULT NULL,
  `quantity` int NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_cart_items_cart`(`cart_id` ASC) USING BTREE,
  INDEX `fk_cart_items_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_cart_items_variant`(`variant_id` ASC) USING BTREE,
  CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_cart_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cart_items
-- ----------------------------
INSERT INTO `cart_items` VALUES (1, 1, 1, NULL, 2, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (2, 1, 3, NULL, 1, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (3, 1, 7, NULL, 1, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (4, 2, 2, NULL, 1, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (5, 2, 8, NULL, 2, '2025-12-15 23:36:34');
INSERT INTO `cart_items` VALUES (13, 5, 1, 1, 2, '2025-12-31 14:57:30');

-- ----------------------------
-- Table structure for carts
-- ----------------------------
DROP TABLE IF EXISTS `carts`;
CREATE TABLE `carts`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'ACTIVE',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `active_key` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_carts_active_key`(`active_key` ASC) USING BTREE,
  INDEX `idx_carts_user_active`(`user_id` ASC, `is_active` ASC) USING BTREE,
  CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carts
-- ----------------------------
INSERT INTO `carts` VALUES (1, 3, '2025-12-15 23:36:21', '2026-01-01 23:31:47', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (2, 4, '2025-12-15 23:36:21', '2026-01-01 23:31:47', 'ORDERED', 0, NULL);
INSERT INTO `carts` VALUES (3, 3, '2025-12-15 23:36:34', '2026-01-01 23:31:53', 'ACTIVE', 1, 3);
INSERT INTO `carts` VALUES (4, 4, '2025-12-15 23:36:34', '2026-01-01 23:31:53', 'ACTIVE', 1, 4);
INSERT INTO `carts` VALUES (5, 1, '2025-12-31 01:27:40', '2026-01-01 23:31:53', 'ACTIVE', 1, 1);
INSERT INTO `carts` VALUES (6, 5, '2026-01-01 23:38:32', '2026-01-01 23:38:32', 'ACTIVE', 1, 5);

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_featured` tinyint(1) NULL DEFAULT 0,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES (1, 'Giày chạy bộ', '/images/categories/running.jpg', '/category/running', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (2, 'Giày bóng đá', '/images/categories/football.jpg', '/category/football', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (3, 'Giày bóng rổ', '/images/categories/basket.jpg', '/category/basket', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (4, 'Sneaker lifestyle', '/images/categories/lifestyle.jpg', '/category/lifestyle', 1, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (5, 'Dép & Sandal', '/images/categories/sandal.jpg', '/category/sandal', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (6, 'Giày tennis', '/images/categories/tennis.jpg', '/category/tennis', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (7, 'Giày training / gym', '/images/categories/training.jpg', '/category/training', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');
INSERT INTO `categories` VALUES (8, 'Phụ kiện chăm sóc giày', '/images/categories/access.jpg', '/category/access', 0, 1, '2025-12-11 23:45:33', '2025-12-11 23:45:33');

-- ----------------------------
-- Table structure for contact_messages
-- ----------------------------
DROP TABLE IF EXISTS `contact_messages`;
CREATE TABLE `contact_messages`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NULL DEFAULT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NEW',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_contact_messages_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_contact_messages_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of contact_messages
-- ----------------------------
INSERT INTO `contact_messages` VALUES (1, 3, 'Nguyễn Văn A', 'user1@example.com', '0909000001', 'Shop cho em hỏi size giày chạy Nike Pegasus 40.', 'NEW', '2025-12-11 23:45:59');
INSERT INTO `contact_messages` VALUES (2, NULL, 'Khách lạ', 'guest@example.com', '0909555666', 'Shop có ship về Bình Dương không ạ?', 'NEW', '2025-12-11 23:45:59');

-- ----------------------------
-- Table structure for order_items
-- ----------------------------
DROP TABLE IF EXISTS `order_items`;
CREATE TABLE `order_items`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int NULL DEFAULT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `quantity` int NOT NULL,
  `unit_price` double NOT NULL,
  `subtotal` double NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_order_items_order`(`order_id` ASC) USING BTREE,
  INDEX `fk_order_items_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_order_items_variant`(`variant_id` ASC) USING BTREE,
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_order_items_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order_items
-- ----------------------------
INSERT INTO `order_items` VALUES (1, 1, 1, NULL, NULL, NULL, 1, 2990000, 2990000);
INSERT INTO `order_items` VALUES (2, 1, 2, NULL, NULL, NULL, 2, 3590000, 7180000);
INSERT INTO `order_items` VALUES (3, 2, 7, NULL, NULL, NULL, 2, 1590000, 3180000);

-- ----------------------------
-- Table structure for orders
-- ----------------------------
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `address_id` int NOT NULL,
  `total_amount` double NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_orders_user`(`user_id` ASC) USING BTREE,
  INDEX `fk_orders_address`(`address_id` ASC) USING BTREE,
  CONSTRAINT `fk_orders_address` FOREIGN KEY (`address_id`) REFERENCES `user_addresses` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orders
-- ----------------------------
INSERT INTO `orders` VALUES (1, 3, 1, 10170000, 'PENDING', '2025-12-11 23:45:59', '2025-12-11 23:45:59');
INSERT INTO `orders` VALUES (2, 4, 2, 3190000, 'PAID', '2025-12-11 23:45:59', '2025-12-11 23:45:59');

-- ----------------------------
-- Table structure for product_images
-- ----------------------------
DROP TABLE IF EXISTS `product_images`;
CREATE TABLE `product_images`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `alt` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_main` tinyint(1) NULL DEFAULT 0,
  `sort_order` int NULL DEFAULT 0,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_product_images_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_images
-- ----------------------------
INSERT INTO `product_images` VALUES (1, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-womens-road-cw7358-002-01-2c8c3f6e-99ff-4997-8c71-3732c331e62d-ee1f7fdf-e631-416d-a15b-2e573bce5876.jpg?v=1712173686633', 'Nike Air Zoom Pegasus 40 - main', 1, 0, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (2, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-02-d5408a9e-3404-47e5-8cea-7f15e5620299.png?v=1712173686633', 'Nike Air Zoom Pegasus 40 - side', 0, 1, 1, '2025-12-11 23:45:49', 'Black');
INSERT INTO `product_images` VALUES (3, 2, '/images/products/ultraboost_light_main.jpg', 'Adidas Ultraboost Light - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (4, 2, '/images/products/ultraboost_light_side.jpg', 'Adidas Ultraboost Light - side', 0, 1, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (5, 3, '/images/products/mercurial_vapor15_main.jpg', 'Nike Mercurial Vapor 15 Elite - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (6, 4, '/images/products/predator_accuracy_main.jpg', 'Adidas Predator Accuracy. - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (7, 5, '/images/products/lebron_witness8_main.jpg', 'Nike Lebron Witness 8 - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (8, 6, '/images/products/puma_all_pro_nitro_main.jpg', 'Puma All Pro Nitro - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (9, 7, '/images/products/converse_chuck_hi_main.jpg', 'Converse Chuck Taylor All Star - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (10, 8, '/images/products/vans_old_skool_main.jpg', 'Vans Old Skool Classic - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (11, 9, '/images/products/gel_nimbus26_main.jpg', 'Asics Gel-Nimbus 26 - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (12, 10, '/images/products/wave_rider27_main.jpg', 'Mizuno Wave Rider 27 - main', 1, 0, 1, '2025-12-11 23:45:49', NULL);
INSERT INTO `product_images` VALUES (13, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-03-d1812fdf-1a78-474f-a96a-5b57402e8438.png?v=1712173686633', NULL, 1, 1, 1, '2025-12-25 13:33:10', 'Black');
INSERT INTO `product_images` VALUES (14, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-04-7952d5a4-9b1b-4151-b5d5-3cdf33d7f008.png?v=1712173686633', NULL, 0, 2, 1, '2025-12-25 13:33:10', 'Black');
INSERT INTO `product_images` VALUES (15, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-0-air-zoom-pegasus-38-cw7356-002-05-7b3f4ce2-e4fe-4536-b8c1-677756d04596.png?v=1712173686633', NULL, 0, 3, 1, '2025-12-25 13:33:10', 'Black');
INSERT INTO `product_images` VALUES (16, 1, '/images/products/p1_blue_1.jpg', NULL, 1, 1, 1, '2025-12-25 13:33:10', 'Blue');
INSERT INTO `product_images` VALUES (17, 1, '/images/products/p1_blue_2.jpg', NULL, 0, 2, 1, '2025-12-25 13:33:10', 'Blue');
INSERT INTO `product_images` VALUES (18, 1, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/663c3749-e7a7-4a6d-8111-32398a36b1cf.jpg', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (19, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-bq9647-101-02.jpg?v=1679400171817', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (20, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-37-bq9647-101-03.jpg?v=1679400173177', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (21, 1, 'https://bizweb.dktcdn.net/100/347/092/products/95124a7c-371b-4c90-b0f3-e015c87f9f7a.jpg?v=1679400174423', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (22, 1, 'https://bizweb.dktcdn.net/100/347/092/products/83b45721-c27f-4e1b-ba1f-9756977196af.jpg?v=1679400175697', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (23, 1, 'https://bizweb.dktcdn.net/100/347/092/products/ee5a12bd-ad4a-45db-bff5-5adc4d2d0dc7.jpg?v=1679400181080', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');
INSERT INTO `product_images` VALUES (24, 1, 'https://bizweb.dktcdn.net/100/347/092/products/nike-air-zoom-pegasus-38-womens-road-cw7358-002-07.jpg?v=1643141108047', 'Nike Air Zoom Pegasus 40 - main', 1, 1, 1, '2025-12-29 22:58:11', 'White');

-- ----------------------------
-- Table structure for product_specs
-- ----------------------------
DROP TABLE IF EXISTS `product_specs`;
CREATE TABLE `product_specs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `spec_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `spec_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_order` int NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_product_specs_product`(`product_id` ASC, `sort_order` ASC) USING BTREE,
  CONSTRAINT `fk_product_specs_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_specs
-- ----------------------------
INSERT INTO `product_specs` VALUES (1, 1, 'Chất liệu Upper', 'Mesh thoáng khí', 1, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (2, 1, 'Đế ngoài', 'Cao su chống trượt', 2, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (3, 1, 'Công nghệ đệm', 'Air Zoom', 3, '2025-12-21 22:18:01', '2025-12-21 22:18:01');
INSERT INTO `product_specs` VALUES (4, 1, 'Mục đích', 'Chạy bộ đường trường', 4, '2025-12-21 22:18:01', '2025-12-21 22:18:01');

-- ----------------------------
-- Table structure for product_variants
-- ----------------------------
DROP TABLE IF EXISTS `product_variants`;
CREATE TABLE `product_variants`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `size` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `stock_qty` int NOT NULL DEFAULT 0,
  `sku` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `price` double NULL DEFAULT NULL,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_product_color_size`(`product_id` ASC, `color` ASC, `size` ASC) USING BTREE,
  INDEX `idx_variant_product`(`product_id` ASC) USING BTREE,
  CONSTRAINT `fk_variant_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product_variants
-- ----------------------------
INSERT INTO `product_variants` VALUES (1, 1, 'Black', '40', 10, 'P1-BLK-40', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (2, 1, 'Black', '41', 5, 'P1-BLK-41', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (3, 1, 'White', '40', 3, 'P1-WHT-40', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (4, 2, 'Black', '42', 8, 'P2-BLK-42', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (5, 2, 'Blue', '41', 0, 'P2-BLU-41', NULL, '2025-12-19 21:41:01', '2025-12-19 21:41:01');
INSERT INTO `product_variants` VALUES (6, 1, 'BLUE', '39', 5, 'P1-BLU-39', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (7, 1, 'BLUE', '42', 7, 'P1-BLU-42', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (8, 1, 'RED', '39', 4, 'P1-RED-39', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');
INSERT INTO `product_variants` VALUES (9, 1, 'RED', '42', 0, 'P1-RED-42', NULL, '2025-12-20 21:52:22', '2025-12-20 21:52:22');

-- ----------------------------
-- Table structure for products
-- ----------------------------
DROP TABLE IF EXISTS `products`;
CREATE TABLE `products`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `price` double NOT NULL,
  `old_price` double NULL DEFAULT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `category_id` int NOT NULL,
  `brand_id` int NOT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_products_category`(`category_id` ASC) USING BTREE,
  INDEX `fk_products_brand`(`brand_id` ASC) USING BTREE,
  CONSTRAINT `fk_products_brand` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of products
-- ----------------------------
INSERT INTO `products` VALUES (1, 'Nike Air Zoom Pegasus 40', 'Giày chạy bộ Nike Air Zoom Pegasus 40 êm ái, phù hợp chạy bộ hằng ngày.', 2990000, 3490000, 'https://bizweb.dktcdn.net/thumb/1024x1024/100/347/092/products/air-zoom-pegasus-40-older-road-running-shoes-jqwr5f.jpg', 'men', 1, 1, 1, '2025-12-11 23:45:43', '2025-12-17 11:27:36');
INSERT INTO `products` VALUES (2, 'Adidas Ultraboost Light', 'Giày chạy bộ Adidas Ultraboost Light đệm Boost nhẹ và đàn hồi.', 3590000, 3990000, '/images/products/ultraboost_light_main.jpg', 'men', 1, 2, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (3, 'Nike Mercurial Vapor 15 Elite', 'Giày đá bóng Nike Mercurial Vapor 15 Elite cho sân cỏ nhân tạo.', 4290000, 5490000, '/images/products/mercurial_vapor15_main.jpg', 'men', 2, 1, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (4, 'Adidas Predator Accuracy.', 'Giày đá bóng Adidas Predator Accuracy. kiểm soát bóng tốt.', 4290000, 4690000, '/images/products/predator_accuracy_main.jpg', 'men', 2, 2, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (5, 'Nike Lebron Witness 8', 'Giày bóng rổ Nike Lebron Witness 8 hỗ trợ cổ chân và bật nhảy.', 3290000, 3990000, '/images/products/lebron_witness8_main.jpg', 'men', 3, 1, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (6, 'Puma All Pro Nitro', 'Giày bóng rổ Puma All Pro Nitro nhẹ, bám sân tốt.', 2690000, 3290000, '/images/products/puma_all_pro_nitro_main.jpg', 'men', 3, 3, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (7, 'Converse Chuck Taylor All Star', 'Giày sneaker Converse Chuck Taylor All Star cổ điển.', 1590000, 1990000, '/images/products/converse_chuck_hi_main.jpg', 'unisex', 4, 5, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (8, 'Vans Old Skool Classic', 'Giày sneaker Vans Old Skool Classic cho phong cách streetwear.', 1690000, 1990000, '/images/products/vans_old_skool_main.jpg', 'unisex', 4, 6, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (9, 'Asics Gel-Nimbus 26', 'Giày chạy bộ Asics Gel-Nimbus 26 hỗ trợ long run.', 4490000, 4990000, '/images/products/gel_nimbus26_main.jpg', 'women', 1, 7, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');
INSERT INTO `products` VALUES (10, 'Mizuno Wave Rider 27', 'Giày chạy bộ Mizuno Wave Rider 27 cân bằng giữa êm và phản hồi lực.', 2990000, 3490000, '/images/products/wave_rider27_main.jpg', 'men', 1, 10, 1, '2025-12-11 23:45:43', '2025-12-11 23:45:43');

-- ----------------------------
-- Table structure for reviews
-- ----------------------------
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE `reviews`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `user_id` int NOT NULL,
  `rating` int NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'PENDING',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_reviews_product`(`product_id` ASC) USING BTREE,
  INDEX `fk_reviews_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of reviews
-- ----------------------------
INSERT INTO `reviews` VALUES (1, 1, 3, 5, 'Giày chạy rất êm, form đúng size.', 'APPROVED', '2025-12-11 23:45:59');
INSERT INTO `reviews` VALUES (2, 2, 4, 4, 'Đệm êm nhưng hơi nóng chân khi chạy dài.', 'APPROVED', '2025-12-11 23:45:59');
INSERT INTO `reviews` VALUES (3, 1, 2, 4, 'giày oke đó, đáng tiền mua', 'APPROVED', '2025-12-24 11:02:00');

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, 'ADMIN', 'Quản trị hệ thống', 'Toàn quyền quản lý hệ thống');
INSERT INTO `roles` VALUES (2, 'STAFF', 'Nhân viên', 'Quản lý đơn hàng, sản phẩm, khách hàng');
INSERT INTO `roles` VALUES (3, 'USER', 'Khách hàng', 'Người mua hàng trên website');

-- ----------------------------
-- Table structure for user_addresses
-- ----------------------------
DROP TABLE IF EXISTS `user_addresses`;
CREATE TABLE `user_addresses`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address_line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `district` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ward` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `is_default` tinyint(1) NULL DEFAULT 0,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_user_addresses_user`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_addresses
-- ----------------------------
INSERT INTO `user_addresses` VALUES (1, 3, 'Nguyễn Văn A', '0909000001', '123 Lê Lợi', 'TP.HCM', 'Quận 1', 'Bến Thành', 1, '2025-12-11 23:45:59');
INSERT INTO `user_addresses` VALUES (2, 4, 'Trần Thị B', '0909000002', '89 Phan Xích Long', 'TP.HCM', 'Phú Nhuận', 'Phường 3', 1, '2025-12-11 23:45:59');

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE,
  INDEX `fk_user_roles_role`(`role_id` ASC) USING BTREE,
  CONSTRAINT `fk_user_roles_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_user_roles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES (1, 1);
INSERT INTO `user_roles` VALUES (2, 2);
INSERT INTO `user_roles` VALUES (3, 3);
INSERT INTO `user_roles` VALUES (4, 3);
INSERT INTO `user_roles` VALUES (5, 3);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `active` tinyint(1) NULL DEFAULT 1,
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'admin@japansport.com', 'admin123', 'Admin JapanSport', 1, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (2, 'staff1@japansport.com', 'staff123', 'Nhân viên kho', 1, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (3, 'user1@example.com', 'user123', 'Nguyễn Văn A', 1, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (4, 'user2@example.com', 'user123', 'Trần Thị B', 1, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (5, 'user3@example.com', 'user123', 'Lê C', 0, '2025-12-11 23:44:51', '2025-12-11 23:44:51');
INSERT INTO `users` VALUES (6, 'tronglinh2708@...', 'pbkdf2$...', 'linh', 1, '2025-12-30 01:38:48', '2025-12-30 01:38:48');

SET FOREIGN_KEY_CHECKS = 1;
