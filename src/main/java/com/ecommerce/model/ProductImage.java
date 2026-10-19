package com.ecommerce.model;

import jakarta.persistence.*;
import java.util.*;
import com.ecommerce.dto.ProductImageDTO;
import com.ecommerce.exception.*;
import com.ecommerce.repository.ProductImageDB;
import com.ecommerce.repository.ProductDB;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.validator.ProductImageValidator;

@Entity
@Table(name = "product_images")
public class ProductImage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "color")
    private String color;

    public ProductImage() {}

    public ProductImage(Product product, String imageUrl, String color) {
        this.product = product;
        this.imageUrl = imageUrl;
        this.color = color;
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

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    // ==========================================
    // METHODS
    // ==========================================
    public static ProductImageDTO add(ProductImageDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        normalizeDTO(dto);
        int productId = dto.getProductId();
        String imageUrl = dto.getImageUrl();
        String color = dto.getColor();

        try {
            trans.begin();

            if (!ProductDB.isProductIdExists(em, productId)) {
                throw new NotFoundException("Không tìm thấy sản phẩm có id = " + productId);
            }

            Product product = ProductDB.findById(em, productId);
            ProductImage productImage = new ProductImage(product, imageUrl, color);
            ProductImageDB.insert(em, productImage);

            trans.commit();
            return ProductImageDTO.fromEntity(productImage);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static void delete(int id) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        try {
            trans.begin();

            if (!ProductImageDB.isProductImageIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy ảnh sản phẩm có id = " + id);
            }

            ProductImage productImage = ProductImageDB.findById(em, id);
            ProductImageDB.delete(em, productImage);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<ProductImageDTO> getByProductId(int productId) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<ProductImageDTO> images = new ArrayList<>();
            for (ProductImage productImage : ProductImageDB.findByProductId(em, productId)) {
                images.add(ProductImageDTO.fromEntity(productImage));
            }
            return images;
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<ProductImageDTO> toDTOs(List<ProductImage> images) {
        List<ProductImageDTO> result = new ArrayList<>();
        for (ProductImage image : images) {
            result.add(ProductImageDTO.fromEntity(image));
        }
        return result;
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================
    public static String normalizeColor(String color) {
        return color.trim().replaceAll("\\s+", "-").toLowerCase(Locale.ROOT);
    }

    private static void normalizeDTO(ProductImageDTO dto) {
        String error = ProductImageValidator.validate(dto);
        if (error != null) {
            throw new BusinessException(error);
        }

        String imageUrl = dto.getImageUrl().trim();
        String color = normalizeColor(dto.getColor());

        dto.setImageUrl(imageUrl);
        dto.setColor(color);
    }
}
