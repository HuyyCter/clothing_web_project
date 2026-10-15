/**
 * Cart AJAX Interactions (Module D) - Fashion Shop
 * Vanilla JavaScript, không phụ thuộc thư viện ngoài.
 */
document.addEventListener("DOMContentLoaded", function () {
    const contextPath = document.body.dataset.contextPath || "";

    // Lắng nghe nút tăng / giảm số lượng qua AJAX
    document.querySelectorAll(".js-qty-btn").forEach(function (btn) {
        btn.addEventListener("click", function (e) {
            e.preventDefault();
            const itemId = this.dataset.itemId;
            const delta = parseInt(this.dataset.delta, 10);
            const input = document.getElementById("qty-input-" + itemId);
            if (!input) return;

            let currentVal = parseInt(input.value, 10) || 1;
            let newVal = currentVal + delta;
            if (newVal < 1) newVal = 1;
            if (newVal > 99) newVal = 99;

            if (newVal !== currentVal) {
                updateItemQuantity(itemId, newVal, input);
            }
        });
    });

    // Lắng nghe khi nhập số lượng trực tiếp
    document.querySelectorAll(".js-qty-input").forEach(function (input) {
        input.addEventListener("change", function () {
            const itemId = this.dataset.itemId;
            let val = parseInt(this.value, 10);
            if (isNaN(val) || val < 1) {
                val = 1;
                this.value = 1;
            } else if (val > 99) {
                val = 99;
                this.value = 99;
            }
            updateItemQuantity(itemId, val, this);
        });
    });

    function updateItemQuantity(itemId, quantity, inputElem) {
        const formData = new URLSearchParams();
        formData.append("action", "update");
        formData.append("itemId", itemId);
        formData.append("quantity", quantity);

        fetch(contextPath + "/cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: formData.toString()
        })
        .then(function (response) {
            if (!response.ok) {
                return response.json().then(function (err) {
                    throw new Error(err.detail || err.title || "Lỗi khi cập nhật số lượng.");
                });
            }
            return response.json();
        })
        .then(function (data) {
            if (data.success) {
                // Tải lại trang nhẹ nhàng để đồng bộ giá và voucher, hoặc reload
                window.location.reload();
            }
        })
        .catch(function (error) {
            alert(error.message);
            window.location.reload();
        });
    }
});
