CREATE DATABASE IF NOT EXISTS homerent_rr7;
USE homerent_rr7;

-- Xóa bảng theo đúng thứ tự ràng buộc khóa ngoại để tránh lỗi
DROP TABLE IF EXISTS TicketFeedback;
DROP TABLE IF EXISTS TicketResponses;
DROP TABLE IF EXISTS SupportTickets;
DROP TABLE IF EXISTS SupportCategory;
DROP TABLE IF EXISTS Users;

-- ====================================================================
-- PHẦN 1: DDL - TẠO CẤU TRÚC BẢNG CƠ SỞ DỮ LIỆU
-- ====================================================================

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('Admin', 'Manager', 'Staff', 'Customer') NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE SupportCategory (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE SupportTickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    room_code VARCHAR(20) NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'In_Progress', 'Resolved', 'Closed') DEFAULT 'Pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES SupportCategory(category_id)
);

CREATE TABLE TicketResponses (
    response_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    responder_id INT NOT NULL,
    message TEXT NOT NULL,
    responded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES SupportTickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (responder_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE TicketFeedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL UNIQUE,
    rating_stars INT NOT NULL CHECK (rating_stars BETWEEN 1 AND 5),
    feedback_comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES SupportTickets(ticket_id) ON DELETE CASCADE
);

-- ====================================================================
-- PHẦN 2: DML - NẠP DỮ LIỆU THỬ NGHIỆM (MOCK DATA)
-- ====================================================================

INSERT INTO Users (user_id, full_name, role, phone, email) VALUES
(1, 'Trần Văn Quản Lý', 'Manager', '0901234567', 'manager@homerent.com'),
(2, 'Nguyễn Thị Thu (Kỹ thuật)', 'Staff', '0907654321', 'staff@homerent.com'),
(3, 'Lê Hoàng Nam (Khách P.302)', 'Customer', '0912334455', 'hoangnam@gmail.com'),
(4, 'Phạm Thu Trang (Khách P.105)', 'Customer', '0988776655', 'thutrang@gmail.com');

INSERT INTO SupportCategory (category_id, category_name, description) VALUES
(1, 'Sự cố Điện / Nước', 'Rò rỉ nước, mất điện, hỏng bóng đèn'),
(2, 'Hỏng hóc thiết bị', 'Lỗi điều hòa, máy giặt, tủ lạnh'),
(3, 'Hợp đồng & Tiền cọc', 'Thắc mắc thời hạn thuê và hoàn tiền cọc'),
(4, 'Vệ sinh & An ninh', 'Vệ sinh hành lang, trật tự chung');

INSERT INTO SupportTickets (ticket_id, user_id, category_id, room_code, title, description, status, created_at) VALUES
(101, 3, 1, 'P.302', 'Vòi sen phòng tắm bị rò rỉ nước', 'Vòi sen rò ở chân van từ tối qua, nhờ ban quản lý kiểm tra.', 'In_Progress', '2026-09-29 08:30:00'),
(102, 4, 2, 'P.105', 'Máy lạnh không mát', 'Bật 16 độ nhưng chỉ có gió thoảng, nhờ thợ kiểm tra bảo dưỡng.', 'Resolved', '2026-09-28 14:15:00'),
(927, 3, 1, 'P.302', 'Vòi nước rò rỉ', 'Vòi nước bồn rửa mặt bị lỏng chân van.', 'Pending', '2026-09-30 09:00:00');

INSERT INTO TicketResponses (ticket_id, responder_id, message, responded_at) VALUES
(101, 3, 'vòi nước phòng em rò rỉ từ tối qua ạ', '2026-09-29 08:31:00'),
(101, 2, 'Chào bạn Nam, chiều nay 14h kỹ thuật sẽ ghé kiểm tra nhé.', '2026-09-29 09:00:00'),
(101, 3, 'Dạ 14h em có ở phòng, anh qua sớm giúp em!', '2026-09-29 09:05:00'),
(102, 2, 'Thợ đã nạp gas và vệ sinh lưới lọc hoàn tất rồi bạn nhé.', '2026-09-28 16:30:00');

INSERT INTO TicketFeedback (ticket_id, rating_stars, feedback_comment, created_at) VALUES
(102, 5, 'Kỹ thuật nhiệt tình, xử lý nhanh chóng.', '2026-09-28 17:00:00');
SELECT * FROM homerent_rr7.supportcategory;
SELECT * FROM homerent_rr7.supporttickets;
SELECT * FROM homerent_rr7.ticketfeedback;
SELECT * FROM homerent_rr7.ticketresponses;