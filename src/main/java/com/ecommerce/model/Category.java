package com.ecommerce.model;

import java.util.ArrayList;
import java.util.List;
import com.ecommerce.dto.CategoryDTO;
import com.ecommerce.repository.CategoryDB;
import com.ecommerce.util.*;
import com.ecommerce.exception.*;
import jakarta.persistence.*;

@Entity
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name")
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "slug", unique = true)
    private String slug;

    public Category() {}

    public Category(String name, String slug, String description) {
        this.name = name;
        this.slug = slug;
        this.description = description;
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

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    // ==========================================
    // METHODS
    // ==========================================
    public static CategoryDTO create(CategoryDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        String name = dto.getName().trim();
        String description = dto.getDescription();
        String slug = buildSlug(name);

        try {
            trans.begin();

            if (CategoryDB.isSlugExists(em, slug)) {
                throw new BusinessException("Danh mục /" + slug + " đã tồn tại.");
            }
            Category category = new Category(name, slug, description);
            CategoryDB.insert(em, category);

            trans.commit();
            return CategoryDTO.fromEntity(category);
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static CategoryDTO update(int id, CategoryDTO dto) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();
        EntityTransaction trans = em.getTransaction();

        String name = dto.getName().trim();
        String description = dto.getDescription();
        String slug = buildSlug(name);

        try {
            trans.begin();

            if (!CategoryDB.isCategoryIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy danh mục có id = " + id);
            }
            if (CategoryDB.isSlugExcludingIdExists(em, slug, id)) {
                throw new BusinessException("Danh mục /" + slug + " đã tồn tại.");
            }

            Category category = CategoryDB.findById(em, id);
            category.setName(name);
            category.setDescription(description);
            category.setSlug(slug);
            CategoryDB.update(em, category);

            trans.commit();
            return CategoryDTO.fromEntity(category);
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

            if (!CategoryDB.isCategoryIdExists(em, id)) {
                throw new NotFoundException("Không tìm thấy danh mục có id = " + id);
            }
            // TODO: chặn xóa nếu còn sản phẩm thuộc danh mục (thêm khi có entity Product)

            Category category = CategoryDB.findById(em, id);
            CategoryDB.delete(em, category);

            trans.commit();
        } catch (RuntimeException e) {
            trans.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public static CategoryDTO getById(int id) {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            Category category = CategoryDB.findById(em, id);
            if (category == null) {
                throw new NotFoundException("Không tìm thấy danh mục có id = " + id);
            }
            return CategoryDTO.fromEntity(category);
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    public static List<CategoryDTO> getAll() {
        EntityManager em = JpaUtil.getEntityManager().createEntityManager();

        try {
            List<CategoryDTO> categories = new ArrayList<>();
            for (Category category : CategoryDB.findAll(em)) {
                categories.add(CategoryDTO.fromEntity(category));
            }
            return categories;
        } catch (RuntimeException e) {
            throw e;
        } finally {
            em.close();
        }
    }

    // ==========================================
    // PRIVATE HELPERS
    // ==========================================
    private static String buildSlug(String name) {
        String slug = SlugUtil.toSlug(name);
        if (slug.isEmpty()) {
            throw new BusinessException("Tên danh mục không được để trống.");
        }
        return slug;
    }
}
