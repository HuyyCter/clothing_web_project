package com.ecommerce.controller;

import com.ecommerce.dto.AddressDTO;
import com.ecommerce.dto.OrderDTO;
import com.ecommerce.dto.UserDTO;
import com.ecommerce.model.Address;
import com.ecommerce.model.Order;
import com.ecommerce.model.OrderStatus;
import com.ecommerce.model.User;
import com.ecommerce.repository.OrderDB;
import com.ecommerce.repository.UserRepository;
import com.ecommerce.util.JpaUtil;
import com.ecommerce.util.PasswordUtil;
import com.ecommerce.validator.ProfileValidator;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String PROFILE_VIEW = "/WEB-INF/views/user/profile.jsp";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        User sessionUser = (User) session.getAttribute("user");
        if (userId == null && sessionUser != null) {
            userId = sessionUser.getId();
        }

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        EntityManager em = null;
        try {
            try {
                em = JpaUtil.getEntityManager().createEntityManager();
            } catch (Throwable t) {
                System.err.println("[ProfileServlet] Không thể khởi tạo EntityManager: " + t.getMessage());
            }

            populateProfileData(em, userId, session, request);

            if (request.getAttribute("activeTab") == null) {
                request.setAttribute("activeTab", "profile");
            }

            request.getRequestDispatcher(PROFILE_VIEW).forward(request, response);
        } catch (Throwable ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi tải thông tin hồ sơ: " + ex.getMessage());
            request.getRequestDispatcher(PROFILE_VIEW).forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        User sessionUser = (User) session.getAttribute("user");
        if (userId == null && sessionUser != null) {
            userId = sessionUser.getId();
        }

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "updateName";
        }

        EntityManager em = null;
        try {
            try {
                em = JpaUtil.getEntityManager().createEntityManager();
            } catch (Throwable t) {
                System.err.println("[ProfileServlet] Không thể khởi tạo EntityManager trong doPost: " + t.getMessage());
            }

            User user = null;
            if (em != null) {
                UserRepository userRepo = new UserRepository(em);
                user = userRepo.findById(em, userId).orElse(null);
            }
            if (user == null) {
                user = sessionUser;
            }

            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            if ("updateName".equalsIgnoreCase(action)) {
                handleUpdateName(request, session, em, user);
            } else if ("changePassword".equalsIgnoreCase(action)) {
                handleChangePassword(request, session, em, user);
            } else if ("addAddress".equalsIgnoreCase(action)) {
                handleAddAddress(request, em, user);
            } else if ("editAddress".equalsIgnoreCase(action)) {
                handleEditAddress(request, em, userId);
            } else if ("deleteAddress".equalsIgnoreCase(action)) {
                handleDeleteAddress(request, em, userId);
            } else if ("setDefaultAddress".equalsIgnoreCase(action)) {
                handleSetDefaultAddress(request, em, userId);
            } else if ("cancelOrder".equalsIgnoreCase(action)) {
                handleCancelOrder(request, em, userId);
            } else if ("updatePhone".equalsIgnoreCase(action)) {
                handleUpdatePhone(request, session, em, user, userId);
            }

            populateProfileData(em, userId, session, request);
            request.getRequestDispatcher(PROFILE_VIEW).forward(request, response);

        } catch (Throwable ex) {
            if (em != null && em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý: " + ex.getMessage());
            populateProfileData(em, userId, session, request);
            request.getRequestDispatcher(PROFILE_VIEW).forward(request, response);
        } finally {
            if (em != null && em.isOpen()) {
                em.close();
            }
        }
    }

    private void handleUpdateName(HttpServletRequest request, HttpSession session, EntityManager em, User user) {
        String fullName = request.getParameter("fullName");
        String error = ProfileValidator.validateUpdateName(fullName);

        request.setAttribute("activeTab", "profile");
        if (error != null) {
            request.setAttribute("errorMessage", error);
            return;
        }

        if (em != null) {
            em.getTransaction().begin();
            user.setFullName(fullName.trim());
            em.merge(user);
            em.getTransaction().commit();
        } else {
            user.setFullName(fullName.trim());
        }

        session.setAttribute("user", user);
        session.setAttribute("logoName", user.getFullName());
        request.setAttribute("successMessage", "Cập nhật họ và tên thành công!");
    }

    private void handleUpdatePhone(HttpServletRequest request, HttpSession session, EntityManager em, User user, int userId) {
        String newPhone = request.getParameter("newPhone");
        String confirmCommand = request.getParameter("confirmCommand");

        request.setAttribute("activeTab", "profile");

        String error = ProfileValidator.validateUpdatePhone(user.getPhone(), newPhone, confirmCommand);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            return;
        }

        if (em != null) {
            UserRepository userRepo = new UserRepository(em);
            Optional<User> existingUser = userRepo.findByPhone(em, newPhone.trim());
            if (existingUser.isPresent() && existingUser.get().getId() != userId) {
                request.setAttribute("errorMessage", "Số điện thoại này đã được sử dụng bởi một tài khoản khác.");
                return;
            }

            em.getTransaction().begin();
            user.setPhone(newPhone.trim());
            em.merge(user);
            em.getTransaction().commit();
        } else {
            user.setPhone(newPhone.trim());
        }

        session.setAttribute("user", user);
        request.setAttribute("successMessage", "Thay đổi số điện thoại thành công thành: " + newPhone.trim());
    }

    private void handleChangePassword(HttpServletRequest request, HttpSession session, EntityManager em, User user) {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        request.setAttribute("activeTab", "password");

        String error = ProfileValidator.validateChangePassword(currentPassword, newPassword, confirmPassword);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            return;
        }

        if (!PasswordUtil.checkPassword(currentPassword, user.getPasswordHash())) {
            request.setAttribute("errorMessage", "Mật khẩu hiện tại không chính xác.");
            return;
        }

        if (em != null) {
            em.getTransaction().begin();
            String newPasswordHash = PasswordUtil.hashPassword(newPassword);
            user.setPasswordHash(newPasswordHash);
            em.merge(user);
            em.getTransaction().commit();
        }

        session.setAttribute("user", user);
        request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
    }

    private void handleAddAddress(HttpServletRequest request, EntityManager em, User user) {
        String recipientName = request.getParameter("recipientName");
        String phone = request.getParameter("phone");
        String street = request.getParameter("street");
        String ward = request.getParameter("ward");
        String district = request.getParameter("district");
        String city = request.getParameter("city");
        boolean isDefault = "true".equalsIgnoreCase(request.getParameter("isDefault"))
                || "on".equalsIgnoreCase(request.getParameter("isDefault"));

        request.setAttribute("activeTab", "address");

        String error = ProfileValidator.validateAddress(recipientName, phone, street, city);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            return;
        }

        if (em != null) {
            em.getTransaction().begin();
            if (isDefault) {
                try {
                    em.createQuery("UPDATE Address a SET a.isDefault = false WHERE a.user.id = :userId")
                            .setParameter("userId", user.getId())
                            .executeUpdate();
                } catch (Throwable t) {
                    System.err.println("[ProfileServlet] Không thể cập nhật default address: " + t.getMessage());
                }
            }

            Address address = new Address(
                    user,
                    recipientName.trim(),
                    phone.trim(),
                    street.trim(),
                    ward != null ? ward.trim() : "",
                    district != null ? district.trim() : "",
                    city.trim(),
                    isDefault
            );
            em.persist(address);
            em.getTransaction().commit();
        }

        request.setAttribute("successMessage", "Thêm địa chỉ giao hàng thành công!");
    }

    private void handleEditAddress(HttpServletRequest request, EntityManager em, int userId) {
        String addressIdStr = request.getParameter("addressId");
        request.setAttribute("activeTab", "address");

        if (addressIdStr == null || addressIdStr.isBlank()) {
            request.setAttribute("errorMessage", "Mã địa chỉ không hợp lệ.");
            return;
        }

        int addressId;
        try {
            addressId = Integer.parseInt(addressIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã địa chỉ không hợp lệ.");
            return;
        }

        String recipientName = request.getParameter("recipientName");
        String phone = request.getParameter("phone");
        String street = request.getParameter("street");
        String ward = request.getParameter("ward");
        String district = request.getParameter("district");
        String city = request.getParameter("city");
        boolean isDefault = "true".equalsIgnoreCase(request.getParameter("isDefault"))
                || "on".equalsIgnoreCase(request.getParameter("isDefault"));

        String error = ProfileValidator.validateAddress(recipientName, phone, street, city);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            return;
        }

        if (em != null) {
            Address address = em.find(Address.class, addressId);
            if (address == null || address.getUser() == null || address.getUser().getId() != userId) {
                request.setAttribute("errorMessage", "Bạn không có quyền chỉnh sửa địa chỉ này hoặc địa chỉ không tồn tại.");
                return;
            }

            em.getTransaction().begin();
            if (isDefault) {
                try {
                    em.createQuery("UPDATE Address a SET a.isDefault = false WHERE a.user.id = :userId")
                            .setParameter("userId", userId)
                            .executeUpdate();
                } catch (Throwable t) {
                    System.err.println("[ProfileServlet] Lỗi reset default address: " + t.getMessage());
                }
            }

            address.setRecipientName(recipientName.trim());
            address.setPhone(phone.trim());
            address.setStreet(street.trim());
            address.setWard(ward != null ? ward.trim() : "");
            address.setDistrict(district != null ? district.trim() : "");
            address.setCity(city.trim());
            address.setDefault(isDefault);

            em.merge(address);
            em.getTransaction().commit();
        }

        request.setAttribute("successMessage", "Cập nhật địa chỉ thành công!");
    }

    private void handleDeleteAddress(HttpServletRequest request, EntityManager em, int userId) {
        String addressIdStr = request.getParameter("addressId");
        request.setAttribute("activeTab", "address");

        if (addressIdStr == null || addressIdStr.isBlank()) {
            request.setAttribute("errorMessage", "Mã địa chỉ không hợp lệ.");
            return;
        }

        int addressId;
        try {
            addressId = Integer.parseInt(addressIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã địa chỉ không hợp lệ.");
            return;
        }

        if (em != null) {
            Address address = em.find(Address.class, addressId);
            if (address == null || address.getUser() == null || address.getUser().getId() != userId) {
                request.setAttribute("errorMessage", "Bạn không có quyền xóa địa chỉ này hoặc địa chỉ không tồn tại.");
                return;
            }

            em.getTransaction().begin();
            em.remove(address);
            em.getTransaction().commit();
        }

        request.setAttribute("successMessage", "Đã xóa địa chỉ thành công!");
    }

    private void handleSetDefaultAddress(HttpServletRequest request, EntityManager em, int userId) {
        String addressIdStr = request.getParameter("addressId");
        request.setAttribute("activeTab", "address");

        if (addressIdStr == null || addressIdStr.isBlank()) {
            request.setAttribute("errorMessage", "Mã địa chỉ không hợp lệ.");
            return;
        }

        int addressId;
        try {
            addressId = Integer.parseInt(addressIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã địa chỉ không hợp lệ.");
            return;
        }

        if (em != null) {
            Address address = em.find(Address.class, addressId);
            if (address == null || address.getUser() == null || address.getUser().getId() != userId) {
                request.setAttribute("errorMessage", "Bạn không có quyền thao tác trên địa chỉ này.");
                return;
            }

            em.getTransaction().begin();
            try {
                em.createQuery("UPDATE Address a SET a.isDefault = false WHERE a.user.id = :userId")
                        .setParameter("userId", userId)
                        .executeUpdate();
            } catch (Throwable t) {
                System.err.println("[ProfileServlet] Lỗi reset default: " + t.getMessage());
            }

            address.setDefault(true);
            em.merge(address);
            em.getTransaction().commit();
        }

        request.setAttribute("successMessage", "Đã đặt làm địa chỉ giao hàng mặc định!");
    }

    private void handleCancelOrder(HttpServletRequest request, EntityManager em, int userId) {
        String orderIdStr = request.getParameter("orderId");
        request.setAttribute("activeTab", "orders");

        if (orderIdStr == null || orderIdStr.isBlank()) {
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
            return;
        }

        if (em != null) {
            Order order = OrderDB.findByIdAndUserId(em, orderId, userId);
            if (order == null) {
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng hoặc bạn không có quyền hủy đơn hàng này.");
                return;
            }

            // Theo Invariant 2: Hủy chỉ được phép thực hiện từ "Chờ xác nhận" hoặc "Đã xác nhận"
            if (order.getStatus() != OrderStatus.PENDING && order.getStatus() != OrderStatus.CONFIRMED) {
                request.setAttribute("errorMessage", "Đơn hàng đang ở trạng thái không thể hủy trực tiếp.");
                return;
            }

            em.getTransaction().begin();
            order.setStatus(OrderStatus.CANCELLED);
            OrderDB.update(em, order);
            em.getTransaction().commit();

            request.setAttribute("successMessage", "Đã hủy đơn hàng #" + String.format("%05d", orderId) + " thành công.");
        }
    }

    private void populateProfileData(EntityManager em, int userId, HttpSession session, HttpServletRequest request) {
        UserDTO userDTO = null;
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
        if (sessionUser != null) {
            userDTO = new UserDTO(sessionUser);
        }

        if (em != null) {
            try {
                UserRepository userRepo = new UserRepository(em);
                Optional<User> userOpt = userRepo.findById(em, userId);
                if (userOpt.isPresent()) {
                    User user = userOpt.get();
                    userDTO = new UserDTO(user);
                    if (session != null) {
                        session.setAttribute("user", user);
                    }
                }
            } catch (Throwable t) {
                System.err.println("[ProfileServlet] Không thể tải user từ DB: " + t.getMessage());
            }
        }

        if (userDTO == null) {
            userDTO = new UserDTO();
            userDTO.setId(userId);
            String defaultName = (session != null && session.getAttribute("logoName") != null)
                    ? (String) session.getAttribute("logoName")
                    : "Khách hàng";
            userDTO.setFullName(defaultName);
            userDTO.setEmail("");
        }

        List<AddressDTO> addressDTOs = new ArrayList<>();
        if (em != null) {
            try {
                TypedQuery<Address> query = em.createQuery(
                        "SELECT a FROM Address a WHERE a.user.id = :userId ORDER BY a.isDefault DESC, a.id DESC",
                        Address.class
                );
                query.setParameter("userId", userId);
                List<Address> addresses = query.getResultList();
                for (Address addr : addresses) {
                    addressDTOs.add(new AddressDTO(addr));
                }
            } catch (Throwable t) {
                System.err.println("[ProfileServlet] Không thể tải danh sách address: " + t.getMessage());
            }
        }

        List<OrderDTO> orderDTOs = new ArrayList<>();
        if (em != null) {
            try {
                List<Order> orders = OrderDB.findByUserId(em, userId);
                for (Order order : orders) {
                    orderDTOs.add(new OrderDTO(order));
                }
            } catch (Throwable t) {
                System.err.println("[ProfileServlet] Không thể tải danh sách orders: " + t.getMessage());
            }
        }

        userDTO.setAddresses(addressDTOs);
        request.setAttribute("userDTO", userDTO);
        request.setAttribute("addresses", addressDTOs);
        request.setAttribute("orders", orderDTOs);
    }
}
