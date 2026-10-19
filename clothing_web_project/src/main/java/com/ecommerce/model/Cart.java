package com.ecommerce.model;

import com.ecommerce.dto.CartDTO;
import com.ecommerce.dto.CartItemDTO;
import com.ecommerce.exception.BusinessException;
import com.ecommerce.exception.NotFoundException;
import com.ecommerce.exception.UnauthorizedException;
import com.ecommerce.repository.CartDB;
import com.ecommerce.repository.ProductVariantDB;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.validator.CartValidator;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(
    name = "carts",
    uniqueConstraints = {
        @UniqueConstraint(name = "uk_carts_user_id", columnNames = {"user_id"})
    }
)
public class Cart {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    // 1 Cart - 1 User (Association theo đúng User.java của Module A)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", unique = true, nullable = false)
    private User user;

    // Lưu mã voucher đang áp dụng (nullable)
    @Column(name = "voucher_code", length = 50)
    private String voucherCode;

    // 1 Cart - N CartItem (Composition)
    @OneToMany(mappedBy = "cart", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CartItem> items = new ArrayList<>();

    public Cart() {}

    public Cart(User user) {
        this.user = user;
    }

    public Cart(Long userId) {
        setUserId(userId);
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

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Long getUserId() {
        return (user != null) ? Long.valueOf(user.getId()) : null;
    }

    public void setUserId(Long userId) {
        if (userId != null) {
            User u = new User();
            u.setId(userId.intValue());
            this.user = u;
        } else {
            this.user = null;
        }
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = (voucherCode != null && !voucherCode.trim().isEmpty()) ? voucherCode.trim().toUpperCase() : null;
    }

    public List<CartItem> getItems() {
        return items;
    }

    public void setItems(List<CartItem> items) {
        this.items = (items != null) ? items : new ArrayList<>();
    }

    // ==========================================
    // BUSINESS METHODS (RICH DOMAIN MODEL)
    // ==========================================

    /**
     * Lấy thông tin giỏ hàng của user. Nếu chưa có giỏ hàng trong DB thì tự động tạo mới.
     */
    public static CartDTO getCart(Long userId) {
        validateUserId(userId);
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);
            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Thêm sản phẩm biến thể (ProductVariant) vào giỏ hàng.
     * Nếu variant đã tồn tại trong giỏ thì cộng dồn số lượng.
     */
    public static CartDTO addItem(Long userId, Long variantId, int quantity) {
        validateUserId(userId);
        String errVariant = CartValidator.validateVariantId(variantId);
        if (errVariant != null) {
            throw new BusinessException(errVariant);
        }
        String errQty = CartValidator.validateQuantity(quantity);
        if (errQty != null) {
            throw new BusinessException(errQty);
        }

        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);

            ProductVariant variant = ProductVariantDB.findById(em, variantId.intValue());
            if (variant == null) {
                throw new NotFoundException("Biến thể sản phẩm (id=" + variantId + ") không tồn tại.");
            }
            if (variant.getStatus() != ProductVariantStatus.AVAILABLE) {
                throw new BusinessException("Sản phẩm hiện đang tạm ngừng kinh doanh.");
            }
            if (variant.getProduct() != null && !variant.getProduct().isActive()) {
                throw new BusinessException("Sản phẩm '" + variant.getProduct().getName() + "' hiện đang tạm ngừng kinh doanh.");
            }

            // Tìm xem variant đã có trong giỏ chưa
            CartItem existingItem = null;
            for (CartItem it : cart.getItems()) {
                if (it.getProductVariant() != null && it.getProductVariant().getId() == variant.getId()) {
                    existingItem = it;
                    break;
                }
            }

            int currentQtyInCart = (existingItem != null) ? existingItem.getQuantity() : 0;
            int newTotalQty = currentQtyInCart + quantity;
            CartValidator.validateQuantity(newTotalQty);

            if (existingItem != null) {
                existingItem.setQuantity(newTotalQty);
            } else {
                CartItem newItem = new CartItem(cart, variant, quantity);
                cart.getItems().add(newItem);
            }

            CartDB.update(em, cart);
            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Cập nhật số lượng của một item trong giỏ.
     */
    public static CartDTO updateQuantity(Long userId, Long itemId, int quantity) {
        validateUserId(userId);
        String errQty = CartValidator.validateQuantity(quantity);
        if (errQty != null) {
            throw new BusinessException(errQty);
        }

        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);
            CartItem targetItem = findItemAndVerifyOwnership(cart, itemId);

            targetItem.setQuantity(quantity);
            CartDB.update(em, cart);
            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Xóa một item ra khỏi giỏ hàng.
     */
    public static CartDTO removeItem(Long userId, Long itemId) {
        validateUserId(userId);
        if (itemId == null) {
            throw new BusinessException("Mã sản phẩm cần xóa không hợp lệ.");
        }

        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);
            CartItem targetItem = findItemAndVerifyOwnership(cart, itemId);

            cart.getItems().remove(targetItem);
            CartDB.deleteItem(em, targetItem);
            CartDB.update(em, cart);

            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Xóa toàn bộ sản phẩm trong giỏ hàng và gỡ mã voucher.
     */
    public static CartDTO clearCart(Long userId) {
        validateUserId(userId);
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);
            cart.getItems().clear();
            cart.setVoucherCode(null);
            CartDB.update(em, cart);

            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Áp dụng mã Voucher vào giỏ hàng.
     */
    public static CartDTO applyVoucher(Long userId, String voucherCode) {
        validateUserId(userId);
        String errVoucher = CartValidator.validateVoucherCode(voucherCode);
        if (errVoucher != null) {
            throw new BusinessException(errVoucher);
        }

        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);

            BigDecimal subtotal = BigDecimal.ZERO;
            for (CartItem it : cart.getItems()) {
                subtotal = subtotal.add(it.getSubtotal());
            }

            if (subtotal.compareTo(BigDecimal.ZERO) <= 0) {
                throw new BusinessException("Giỏ hàng của bạn đang trống, không thể áp dụng voucher.");
            }

            Voucher.validateAndCalculate(em, voucherCode, subtotal);

            cart.setVoucherCode(voucherCode);
            CartDB.update(em, cart);

            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    /**
     * Gỡ bỏ mã voucher đang áp dụng khỏi giỏ hàng.
     */
    public static CartDTO removeVoucher(Long userId) {
        validateUserId(userId);
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();
        try {
            trans.begin();
            Cart cart = getOrCreateCart(em, userId);
            cart.setVoucherCode(null);
            CartDB.update(em, cart);

            CartDTO dto = toDTO(em, cart);
            trans.commit();
            return dto;
        } catch (RuntimeException e) {
            if (trans.isActive()) trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    // ==========================================
    // OVERLOAD METHODS CHO MODULE E (ORDER)
    // ==========================================

    /**
     * Lấy thông tin giỏ hàng phục vụ checkout của Module E.
     */
    public static CartDTO getForCheckout(EntityManager em, Long userId) {
        validateUserId(userId);
        Cart cart = CartDB.findByUserId(em, userId);
        if (cart == null || cart.getItems().isEmpty()) {
            throw new BusinessException("Giỏ hàng của bạn đang trống, không thể tiến hành đặt hàng.");
        }

        CartDTO dto = toDTO(em, cart);
        if (!dto.isCanCheckout()) {
            throw new BusinessException("Giỏ hàng có sản phẩm không còn đủ tồn kho hoặc đã ngừng kinh doanh. Vui lòng kiểm tra lại trước khi đặt hàng.");
        }
        return dto;
    }

    /**
     * Xóa sạch giỏ hàng trong transaction checkout của Module E.
     */
    public static void clear(EntityManager em, Long userId) {
        validateUserId(userId);
        Cart cart = CartDB.findByUserId(em, userId);
        if (cart != null) {
            cart.getItems().clear();
            cart.setVoucherCode(null);
            CartDB.update(em, cart);
        }
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================
    private static void validateUserId(Long userId) {
        if (userId == null || userId <= 0) {
            throw new UnauthorizedException("Vui lòng đăng nhập để sử dụng tính năng giỏ hàng.");
        }
    }

    private static Cart getOrCreateCart(EntityManager em, Long userId) {
        Cart cart = CartDB.findByUserId(em, userId);
        if (cart == null) {
            User userRef = em.getReference(User.class, userId.intValue());
            cart = new Cart(userRef);
            CartDB.insert(em, cart);
            em.flush();
        }
        return cart;
    }

    private static CartItem findItemAndVerifyOwnership(Cart cart, Long itemId) {
        for (CartItem it : cart.getItems()) {
            if (itemId.equals((long) it.getId())) {
                return it;
            }
        }
        throw new NotFoundException("Không tìm thấy sản phẩm trong giỏ hàng.");
    }

    /**
     * Ánh xạ Cart Entity sang CartDTO đồng thời đối chiếu dữ liệu ProductVariant thực tế.
     */
    private static CartDTO toDTO(EntityManager em, Cart cart) {
        CartDTO dto = new CartDTO();
        dto.setId((long) cart.getId());
        dto.setUserId(cart.getUserId());
        dto.setVoucherCode(cart.getVoucherCode());

        BigDecimal subtotal = BigDecimal.ZERO;
        int totalQuantity = 0;
        boolean canCheckout = true;

        List<CartItemDTO> itemDTOs = new ArrayList<>();
        List<String> warnings = new ArrayList<>();

        for (CartItem item : cart.getItems()) {
            CartItemDTO itemDTO = new CartItemDTO();
            itemDTO.setId((long) item.getId());

            ProductVariant variant = item.getProductVariant();
            if (variant == null) {
                itemDTO.setAvailable(false);
                itemDTO.setWarningMessage("Sản phẩm không còn tồn tại trên hệ thống.");
                warnings.add("Sản phẩm trong giỏ không còn tồn tại.");
                canCheckout = false;
            } else {
                itemDTO.setProductVariantId((long) variant.getId());
                Product product = variant.getProduct();
                itemDTO.setProductName(product != null ? product.getName() : "Sản phẩm");
                itemDTO.setVariantName(variant.getSize() + " / " + variant.getColor());
                itemDTO.setSku(variant.getSku());
                itemDTO.setUnitPrice(variant.getPrice() != null ? variant.getPrice() : BigDecimal.ZERO);
                itemDTO.setCurrentPrice(variant.getPrice());

                String imageUrl = null;
                if (product != null && product.getImages() != null && !product.getImages().isEmpty()) {
                    imageUrl = product.getImages().get(0).getImageUrl();
                }
                itemDTO.setImageUrl(imageUrl);

                boolean isAvailable = (variant.getStatus() == ProductVariantStatus.AVAILABLE);
                if (product != null && !product.isActive()) {
                    isAvailable = false;
                }

                if (!isAvailable) {
                    itemDTO.setAvailable(false);
                    itemDTO.setWarningMessage("Sản phẩm tạm ngừng kinh doanh.");
                    warnings.add("Sản phẩm '" + itemDTO.getProductName() + "' tạm ngừng kinh doanh.");
                    canCheckout = false;
                }
            }

            itemDTO.setQuantity(item.getQuantity());
            BigDecimal lineSubtotal = item.getSubtotal();
            itemDTO.setSubtotal(lineSubtotal);
            subtotal = subtotal.add(lineSubtotal);
            totalQuantity += item.getQuantity();

            itemDTOs.add(itemDTO);
        }

        dto.setItems(itemDTOs);
        dto.setTotalQuantity(totalQuantity);
        dto.setSubtotal(subtotal);

        if (itemDTOs.isEmpty()) {
            canCheckout = false;
        }

        // Xử lý tính toán voucher (nếu có áp dụng)
        BigDecimal discount = BigDecimal.ZERO;
        if (cart.getVoucherCode() != null && !cart.getVoucherCode().trim().isEmpty()) {
            try {
                discount = Voucher.validateAndCalculate(em, cart.getVoucherCode(), subtotal);
            } catch (BusinessException | NotFoundException ex) {
                dto.setVoucherWarning("Mã voucher '" + cart.getVoucherCode() + "' không còn khả dụng: " + ex.getMessage());
                discount = BigDecimal.ZERO;
            }
        }

        dto.setDiscountAmount(discount);
        BigDecimal total = subtotal.subtract(discount);
        if (total.compareTo(BigDecimal.ZERO) < 0) {
            total = BigDecimal.ZERO;
        }
        dto.setTotalAmount(total);
        dto.setWarnings(warnings);
        dto.setCanCheckout(canCheckout);

        return dto;
    }
}
