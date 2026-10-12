package com.ecommerce.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
@Entity
@Table(name = "products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name")
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private Category category;

    @Column(name = "price", precision = 12, scale = 2)
    private BigDecimal price;
    // 1 Product - N ProductVariant (Association)
    @OneToMany(mappedBy = "product")
    private List<ProductVariant> variants = new ArrayList<>();

    // 1 Product - N ProductImage (Composition)
    @OneToMany(mappedBy = "product", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ProductImage> images = new ArrayList<>();

    @Column(name = "is_active", nullable = false)
    private boolean isActive;

    public Product() {}

    public Product(
            String name,
            String description,
            Category category,
            BigDecimal price) {

        this.name = name;
        this.description = description;
        this.category = category;
        this.price = price;
    }

    // ==========================================
    // GETTERS & SETTERS
    // ==========================================
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }
    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    // ==========================================
    // METHODS
    // ==========================================
    public static ProductDTO create(ProductDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        normalizeDTO(dto);
        String name = dto.getName();
        String description = dto.getDescription();
        int categoryId = dto.getCategoryId();

        try {
            trans.begin();

            if (!CategoryDB.isCategoryIdExists(em, categoryId)) {
                throw new NotFoundException("Không tìm thấy danh mục có id = " + categoryId);
            }

            Category category = CategoryDB.findById(em, categoryId);
            Product product = new Product(name, description, category);
            ProductDB.insert(em, product);

            trans.commit();
            return ProductDTO.fromEntity(product);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static ProductDTO update(int id, ProductDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        normalizeDTO(dto);
        String name = dto.getName();
        String description = dto.getDescription();
        int categoryId = dto.getCategoryId();

        try {
            trans.begin();

            if (!ProductDB.isProductIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy sản phẩm có id = " + id);
            }
            if (!CategoryDB.isCategoryIdExists(em, categoryId)) {
                throw new NotFoundException("Không tìm thấy danh mục có id = " + categoryId);
            }

            Product product = ProductDB.findById(em, id);
            product.setName(name);
            product.setDescription(description);
            product.setCategory(CategoryDB.findById(em, categoryId));
            ProductDB.update(em, product);

            trans.commit();
            return ProductDTO.fromEntity(product);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static void setActive(int id, boolean active) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            if (!ProductDB.isProductIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy sản phẩm có id = " + id);
            }

            Product product = ProductDB.findById(em, id);
            product.setActive(active);
            ProductDB.update(em, product);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static ProductDTO getById(int id) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            Product product = ProductDB.findById(em, id);
            if (product == null) {
                throw new NotFoundException("Không tìm thấy sản phẩm có id = " + id);
            }

            ProductDTO dto = ProductDTO.fromEntity(product);
            List<ProductVariant> variants = ProductVariantDB.findByProductId(em, id);
            List<ProductImage> images = ProductImageDB.findByProductId(em, id);

            dto.setVariants(ProductVariant.groupVariantByTypeToDTOs(variants));
            dto.setImages(ProductImage.toDTOs(images));

            return dto;
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<ProductDTO> getAll() {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<ProductDTO> products = new ArrayList<>();
            for (Product product : ProductDB.findAll(em)) {
                products.add(ProductDTO.fromEntity(product));
            }
            return products;
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    public static Long countAll() {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            return ProductDB.countAll(em);
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================
    private static void normalizeDTO(ProductDTO dto) {
        String error = ProductValidator.validate(dto);
        if (error != null) {
            throw new BusinessException(error);
        }

        String name = dto.getName().trim();
        String description = dto.getDescription().trim();
        int categoryId = dto.getCategoryId();

        dto.setName(name);
        dto.setDescription(description);
        dto.setCategoryId(categoryId);
    }

}
