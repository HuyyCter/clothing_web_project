package com.ecommerce.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.util.*;
import com.ecommerce.dto.ProductVariantDTO;
import com.ecommerce.exception.*;
import com.ecommerce.repository.ProductDB;
import com.ecommerce.repository.ProductVariantDB;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.validator.ProductVariantValidator;

@Entity
@Table(name = "product_variants")
public class ProductVariant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @Column(name = "size")
    private String size;

    @Column(name = "color")
    private String color;

    @Column(name = "sku")
    private String sku;

    @Column(name = "price", precision = 12, scale = 2)
    private BigDecimal price;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private ProductVariantStatus status;

    public ProductVariant() {}

    public ProductVariant(Product product, String size, String color, String sku, BigDecimal price) {
        this.product = product;
        this.size = size;
        this.color = color;
        this.sku = sku;
        this.price = price;
        this.status = ProductVariantStatus.AVAILABLE;
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

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public ProductVariantStatus getStatus() {
        return status;
    }

    public void setStatus(ProductVariantStatus status) {
        this.status = status;
    }

    // ==========================================
    // METHODS
    // ==========================================
    public static void addVariants(ProductVariantDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        normalizeDTO(dto, true);
        int productId = dto.getProductId();
        String size = dto.getSize();
        String color = dto.getColor();
        String sku = dto.getSku();
        BigDecimal price = dto.getPrice();
        int quantity = dto.getQuantity();

        try {
            trans.begin();

            if (!ProductDB.isProductIdExists(em, productId)) {
                throw new NotFoundException("Không tìm thấy sản phẩm có id = " + productId);
            }
            if (ProductVariantDB.isVariantExists(em, productId, size, color)) {
                throw new BusinessException("Loại size " + size + " / màu " + color + " đã tồn tại. Hãy dùng chức năng nhập thêm.");
            }

            Product product = ProductDB.findById(em, productId);
            for (int i = 1; i <= quantity; i++) {
                ProductVariant productVariant = new ProductVariant(product, size, color, sku, price);
                ProductVariantDB.insert(em, productVariant);
            }

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static void restockVariants(ProductVariantDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        normalizeDTO(dto, true);
        int productId = dto.getProductId();
        String size = dto.getSize();
        String color = dto.getColor();
        String sku = dto.getSku();
        BigDecimal price = dto.getPrice();
        int quantity = dto.getQuantity();

        try {
            trans.begin();

            if (!ProductVariantDB.isVariantExists(em, productId, size, color)) {
                throw new NotFoundException("Không tìm thấy loại size " + size + " / màu " + color + ".");
            }

            boolean discontinued = ProductVariantDB.countVariantByStatus(em, productId, size, color, ProductVariantStatus.DISCONTINUED) > 0;
            ProductVariantStatus status = discontinued ? ProductVariantStatus.DISCONTINUED : ProductVariantStatus.AVAILABLE;

            Product product = ProductDB.findById(em, productId);
            for (int i = 1; i <= quantity; i++) {
                ProductVariant productVariant = new ProductVariant(product, size, color, sku, price);
                productVariant.setStatus(status);
                ProductVariantDB.insert(em, productVariant);
            }

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static void updateVariants(ProductVariantDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        normalizeDTO(dto, false);
        int productId = dto.getProductId();
        String size = dto.getSize();
        String color = dto.getColor();
        String sku = dto.getSku();
        BigDecimal price = dto.getPrice();

        try {
            trans.begin();

            if (!ProductVariantDB.isVariantExists(em, productId, size, color)) {
                throw new NotFoundException("Không tìm thấy loại size " + size + " / màu " + color + ".");
            }

            ProductVariantDB.updateVariantInfo(em, productId, size, color, sku, price);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static void discontinueType(int productId, String size, String color) {
        changeVariantStatus(productId, size, color, ProductVariantStatus.AVAILABLE, ProductVariantStatus.DISCONTINUED,
                "Loại này không có chiếc nào đang bán để ngừng.");
    }

    public static void resumeType(int productId, String size, String color) {
        changeVariantStatus(productId, size, color, ProductVariantStatus.DISCONTINUED, ProductVariantStatus.AVAILABLE,
                "Loại này không có chiếc nào đang ngừng bán để bán lại.");
    }

    public static List<ProductVariantDTO> groupVariantByTypeToDTOs(List<ProductVariant> variants) {
        Map<String, ProductVariantDTO> types = new LinkedHashMap<>();

        for (ProductVariant variant : variants) {
            String key = variant.getSize() + "|" + variant.getColor();
            ProductVariantDTO type = types.get(key);

            if (type == null) {
                type = ProductVariantDTO.fromEntity(variant);
                type.setQuantity(0);
                type.setStatus(ProductVariantStatus.SOLD);
                types.put(key, type);
            }

            if (variant.getStatus() == ProductVariantStatus.AVAILABLE) {
                type.setQuantity(type.getQuantity() + 1);
                type.setStatus(ProductVariantStatus.AVAILABLE);
            } else if (variant.getStatus() == ProductVariantStatus.DISCONTINUED) {
                type.setStatus(ProductVariantStatus.DISCONTINUED);
            }
        }
        return new ArrayList<>(types.values());
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================
    public static String normalizeSize(String size) {
        return size.trim().toUpperCase(Locale.ROOT);
    }

    public static String normalizeColor(String color) {
        return color.trim().replaceAll("\\s+", "-").toLowerCase(Locale.ROOT);
    }

    private static void normalizeDTO(ProductVariantDTO dto, boolean isRequiredQuantity) {
        String error = ProductVariantValidator.validate(dto, isRequiredQuantity);
        if (error != null) {
            throw new BusinessException(error);
        }

        int productId = dto.getProductId();
        String size = normalizeSize(dto.getSize());
        String color = normalizeColor(dto.getColor());
        String sku = dto.getSku().trim();
        BigDecimal price = dto.getPrice();

        dto.setProductId(productId);
        dto.setSize(size);
        dto.setColor(color);
        dto.setSku(sku);
        dto.setPrice(price);
    }

    public static void changeVariantStatus(int productId, String size, String color, ProductVariantStatus from, ProductVariantStatus to,
            String noRowMessage) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        size = normalizeSize(size);
        color = normalizeColor(color);

        try {
            trans.begin();

            if (!ProductVariantDB.isVariantExists(em, productId, size, color)) {
                throw new NotFoundException("Không tìm thấy loại size " + size + " / màu " + color + ".");
            }

            int updatedCount = ProductVariantDB.updateStatusByVariant(em, productId, size, color, from, to);
            if (updatedCount == 0) {
                throw new BusinessException(noRowMessage);
            }

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
