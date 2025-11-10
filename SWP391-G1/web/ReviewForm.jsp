<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đánh giá sản phẩm</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 30px auto;
                padding: 20px;
                background: #f9f9f9;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #ff6600;
            }
            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end;
                font-size: 30px;
                gap: 5px;
            }
            .star {
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s;
            }
            .star:hover,
            .star:hover ~ .star,
            .star.selected,
            .star.selected ~ .star {
                color: #ffcc00;
            }
            textarea {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                resize: vertical;
            }
            .btn {
                background: #ff6600;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
            .btn:hover {
                background: #e65c00;
            }
            .back-link {
                display: block;
                text-align: center;
                margin-top: 20px;
                color: #666;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <h2>Đánh giá sản phẩm</h2>

        <form action="review" method="post">
            <input type="hidden" name="itemID" value="${param.itemID}">

            <label><strong>Mức độ hài lòng:</strong></label><br>
            <div class="star-rating">
                <c:forEach var="i" begin="1" end="5">
                    <span class="star" data-value="${6-i}">★</span>
                </c:forEach>
            </div>
            <input type="hidden" name="rating" id="rating" value="${review != null ? review.rating : 5}">

            <br><br>
            <label><strong>Bình luận:</strong></label><br>
            <textarea name="comment" placeholder="Chia sẻ trải nghiệm của bạn..." required>${review != null ? review.comment : ''}</textarea>
            <br><br>

            <button type="submit" class="btn">
                ${review != null ? 'Cập nhật đánh giá' : 'Gửi đánh giá'}
            </button>
        </form>

        <a href="orderhistory" class="back-link">Quay lại lịch sử mua hàng</a>

        <script>
            const stars = document.querySelectorAll('.star');
            const hiddenRating = document.getElementById('rating');
            const currentRating = ${review != null ? review.rating : 5};

            // Khôi phục đánh giá cũ
            function updateStars(rating) {
                stars.forEach(star => {
                    star.classList.toggle('selected', parseInt(star.getAttribute('data-value')) <= rating);
                });
            }
            updateStars(currentRating);

            stars.forEach(star => {
                star.addEventListener('click', function () {
                    const value = this.getAttribute('data-value');
                    hiddenRating.value = value;
                    updateStars(value);
                });
            });
        </script>
    </body>
</html>