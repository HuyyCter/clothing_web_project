# Class Diagram vs. Code — Discrepancy Report

**Date:** 2026-09-27

**Project:** `clothing_web_project` (Java + JPA)

---

## 🔴 Critical Issues

### 1. `Review.java` has extra `product` field
- **Diagram:** `Review` has `id, user, productVariant, rating, comment`
- **Code:** `Review` has `id, user, product, productVariant, rating, comment, createdAt`
- **Problem:** The `product` field (`@ManyToOne @JoinColumn(name = "product_id")`) and `createdAt` are not present in the class diagram.
- **File:** `src/main/java/com/ecommerce/model/Review.java`

### 2. `Category.java` missing `products` relationship
- **Diagram:** Shows a **1 → 0..*** relationship from Category to Product (Category has many Products)
- **Code:** `Category.java` has **no `products` list field**. `Product.java` has `@ManyToOne @JoinColumn(name = "category_id") private Category category;` but there is no inverse side.
- **File:** `src/main/java/com/ecommerce/model/Category.java`
- **Expected:** Should have `@OneToMany(mappedBy = "category") private List<Product> products;`

---

## 🟡 Minor Issues

### 3. `Voucher` field type mismatch
- **Diagram:** `minOrderAmount: long`, `maxDiscountAmount: long`
- **Code:** `minOrderAmount: BigDecimal`, `maxDiscountAmount: BigDecimal`
- **File:** `src/main/java/com/ecommerce/model/Voucher.java`
- **Note:** `BigDecimal` is a better choice for monetary values, but it doesn't match the diagram's `long` type.

### 4. `ProductImage` has extra `isPrimary` field
- **Diagram:** `ProductImage` has only `id, imageUrl, color`
- **Code:** `ProductImage` has an additional `isPrimary` (`boolean`) field
- **File:** `src/main/java/com/ecommerce/model/ProductImage.java`

### 5. `createdAt` audit fields not in diagram
Multiple classes have `createdAt` (`@Column(name = "created_at", updatable = false)`) and some have `updatedAt`:
- `Order.java` — `createdAt`, `updatedAt`
- `User.java` — `createdAt`
- `Address.java` — `createdAt`
- `Voucher.java` — `createdAt`
- `Review.java` — `createdAt`
- `Payment.java` — `createdAt`
- **Note:** These are implementation details not shown in the diagram.

### 6. Date/time type difference
- **Diagram:** Uses `DateTime` for date fields
- **Code:** Uses `LocalDateTime` throughout
- **Note:** `LocalDateTime` is the standard JPA type, so the code is correct, but it doesn't match the diagram notation.

### 7. `Product` missing `category` and `variants` from diagram attributes
- **Diagram:** `Product` lists only `id, name, description, images`
- **Code:** `Product` also has `category` (`@ManyToOne`) and `variants` (`@OneToMany`)
- **Note:** The diagram does show relationship lines from Product to Category, ProductVariant, and ProductImage, so the associations exist. The attributes are just not listed in the class box — this follows UML convention but is inconsistent with how other classes (like Cart, Order, Address) list their relationship fields.

---

## ✅ Correctly Implemented

The following classes match the diagram perfectly:
- `OrderStatus` enum
- `UserRole` enum
- `PaymentMethod` enum
- `Order` (core fields)
- `User` (core fields)
- `ProductImage` (core fields)
- `ProductVariant` (core fields)
- `Cart` (core fields)
- `CartItem` (core fields)
- `Address` (core fields)
- `OrderItem` (core fields)
- `Payment` (core fields)
- `Category`
- `Voucher` (except type mismatch)

---

## 📊 Relationship Verification

| Diagram Relationship | Code Implementation | Status |
|---------------------|---------------------|--------|
| Order → OrderItem (Composition, 1..*) | ✅ `@OneToMany(mappedBy="order", cascade=ALL)` | ✅ |
| Order ← User (1) | ✅ `@ManyToOne` in Order | ✅ |
| User → Address (0..*, 1) | ✅ `@OneToMany(mappedBy="user")` | ✅ |
| User → Cart (1, 1) | ✅ `@OneToOne` bidirectional | ✅ |
| Product → ProductImage (Composition, 1 → 0..*) | ✅ `@OneToMany(mappedBy="product", cascade=ALL)` | ✅ |
| Product → ProductVariant (1 → 1..*) | ⚠️ Product has `@ManyToOne` in variant, no `products` list in Category | ⚠️ Partial |
| Category → Product (1 → 0..*) | ⚠️ No `products` list in Category | ❌ Missing |
| ProductVariant → OrderItem (1 → 0..*) | ✅ `@ManyToOne` in OrderItem | ✅ |
| ProductVariant → CartItem (1 → 0..*) | ✅ `@ManyToOne` in CartItem | ✅ |
| User → Review (1) | ✅ `@ManyToOne` in Review | ✅ |
| ProductVariant → Review (1) | ✅ `@ManyToOne` in Review | ✅ |
| Cart → CartItem (Composition, 0..*) | ✅ `@OneToMany(mappedBy="cart", cascade=ALL)` | ✅ |
| Product → Wishlist (0..*) | ❌ Wishlist.java did not exist (now created) | ❌→✅ Fixed |

---

## ✅ Resolution: Wishlist.java Created

The `Wishlist` class has been created at:  
`src/main/java/com/ecommerce/model/Wishlist.java`

It includes:
- `id: int` — auto-generated
- `userId: int` — simple int field (as shown in diagram)
- `products: List<Product>` — `@ManyToMany` with `@JoinTable` for the wishlist_products join table
