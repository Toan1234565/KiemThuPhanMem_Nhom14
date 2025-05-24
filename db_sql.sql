CREATE DATABASE GOATBOOKING

GO

USE GOATBOOKING
GO


CREATE TABLE Users(
	user_id BIGINT  NOT NULL,
	user_name VARCHAR(255) NOT NULL,
	password VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	phone_number VARCHAR(255) NOT NULL,
	gender INT,
	full_name VARCHAR(255) NOT NULL,
	avatar VARCHAR(255),
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	role INT NOT NULL,
	CONSTRAINT pk_Users PRIMARY KEY(user_id)
);



CREATE TABLE Bookings(
	booking_id BIGINT  NOT NULL,
	check_in_date BIGINT NOT NULL,
	check_out_date BIGINT NOT NULL,
	deposit_price DECIMAL(10,2),
	total_price DECIMAL(10,2),
	status INT,
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	user_id BIGINT,
	CONSTRAINT pk_Bookings PRIMARY KEY(booking_id),
	CONSTRAINT fk_Users FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

-- Bảng Homestays
CREATE TABLE Homestays(
	homestay_id BIGINT  NOT NULL,
	name VARCHAR(255) NOT NULL,
	description TEXT,
	ward VARCHAR(255),
	district VARCHAR(255),
	province VARCHAR(255),
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	user_id BIGINT,
	CONSTRAINT pk_Homestays PRIMARY KEY(homestay_id),
	CONSTRAINT fk_Users_Homestays FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

-- Bảng Rooms
CREATE TABLE Rooms(
	room_id BIGINT  NOT NULL,
	room_name VARCHAR(255) NOT NULL,
	room_type INT NOT NULL,
	price DECIMAL(10,2),
	status INT,
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	homestay_id BIGINT NOT NULL,
	booking_id BIGINT NOT NULL,
	CONSTRAINT pk_Rooms PRIMARY KEY(room_id),
	CONSTRAINT fk_Rooms_Homestays FOREIGN KEY(homestay_id) REFERENCES Homestays(homestay_id),
	CONSTRAINT fk_Rooms_Bookings FOREIGN KEY(booking_id) REFERENCES Bookings(booking_id)
);

-- Bảng Reviews
CREATE TABLE Reviews(
	review_id BIGINT  NOT NULL,
	rate INT,
	comment TEXT,
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	homestay_id BIGINT NOT NULL,
	user_id BIGINT NOT NULL,
	CONSTRAINT pk_Reviews PRIMARY KEY(review_id),
	CONSTRAINT fk_Reviews_Homestays FOREIGN KEY(homestay_id) REFERENCES Homestays(homestay_id),
	CONSTRAINT fk_Reviews_Users FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

-- Bảng Photos
CREATE TABLE Photos(
	photo_id BIGINT  NOT NULL,
	name_photo VARCHAR(255),
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	homestay_id BIGINT NOT NULL,
	CONSTRAINT pk_Photos PRIMARY KEY(photo_id),
	CONSTRAINT fk_Photos_Homestays FOREIGN KEY(homestay_id) REFERENCES Homestays(homestay_id)
);

-- Bảng Services
CREATE TABLE Services(
	service_id BIGINT  NOT NULL,
	service_name VARCHAR(255),
	description TEXT,
	price DECIMAL(10,2),
	created_at BIGINT NOT NULL,
	updated_at BIGINT NOT NULL,
	CONSTRAINT pk_Services PRIMARY KEY(service_id)
);

-- Bảng Services_advantage
CREATE TABLE Services_advantage(
	homestay_id BIGINT NOT NULL,
	service_id BIGINT NOT NULL,
	description VARCHAR(255) NOT NULL,
	CONSTRAINT pk_Services_advantage PRIMARY KEY(homestay_id, service_id),
	CONSTRAINT fk_Services_advantage_Homestays FOREIGN KEY(homestay_id) REFERENCES Homestays(homestay_id),
	CONSTRAINT fk_Services_advantage_Services FOREIGN KEY(service_id) REFERENCES Services(service_id)
);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES 
    (1, 'john_doe', 'password123', 'john.doe@example.com', '1234567890', 1, 'John Doe', 'avatar1.png', 20241001, 20241001, 1),
    (2, 'jane_smith', 'mypassword', 'jane.smith@example.com', '0987654321', 0, 'Jane Smith', 'avatar2.png', 20241002, 20241002, 2),
    (3, 'alice_nguyen', 'alicepass', 'alice.nguyen@example.com', '1122334455', 1, 'Alice Nguyen', 'avatar3.png', 20241003, 20241003, 1),
    (4, 'bob_lee', 'bobsecure', 'bob.lee@example.com', '4433221100', 1, 'Bob Lee', 'avatar4.png', 20241004, 20241004, 2),
    (5, 'sara_connor', 'sarapass', 'sara.connor@example.com', '5544332211', 0, 'Sara Connor', 'avatar5.png', 20241005, 20241005, 1);

INSERT INTO Bookings (booking_id, check_in_date, check_out_date, deposit_price, total_price, status, created_at, updated_at, user_id)
VALUES 
    (1, 20241010, 20241015, 200.00, 1000.00, 1, 20241001, 20241001, 1),
    (2, 20241012, 20241016, 150.00, 800.00, 1, 20241002, 20241002, 2),
    (3, 20241014, 20241018, 100.00, 600.00, 0, 20241003, 20241003, 3),
    (4, 20241016, 20241020, 250.00, 1200.00, 1, 20241004, 20241004, 4),
    (5, 20241018, 20241022, 180.00, 900.00, 0, 20241005, 20241005, 5);


INSERT INTO Homestays (homestay_id, name, description, ward, district, province, created_at, updated_at, user_id)
VALUES 
    (1, 'Homestay Hanoi Central', 'A cozy homestay located in the heart of Hanoi', 'Phuong 7', 'Quan Ba Dinh', 'Ha Noi', 20241001, 20241001, 1),
    (2, 'Saigon Riverside Homestay', 'Beautiful homestay with a view of Saigon River', 'Phuong Binh Thanh', 'Quan 1', 'Ho Chi Minh', 20241002, 20241002, 2),
    (3, 'Homestay Da Nang Beach', 'Relaxing homestay just minutes from the beach', 'Phuong Ngu Hanh Son', 'Quan Ngu Hanh Son', 'Da Nang', 20241003, 20241003, 3),
    (4, 'Ninh Binh Nature Homestay', 'Experience nature and stunning views in Ninh Binh', 'Phuong Tam Coc', 'Huyen Hoa Lu', 'Ninh Binh', 20241004, 20241004, 1),
    (5, 'Sapa Mountain Homestay', 'Beautiful homestay in the mountains of Sapa', 'Phuong Sa Pa', 'Huyen Sa Pa', 'Lao Cai', 20241005, 20241005, 2);
INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES 
    (1, 'Deluxe Room', 1, 150.00, 1, 20241015, 20241015, 1, 1),
    (2, 'Standard Room', 2, 100.00, 1, 20241015, 20241015, 1, 2),
    (3, 'Family Room', 1, 200.00, 0, 20241017, 20241017, 2, 3),
    (4, 'Single Room', 2, 80.00, 1, 20241018, 20241018, 3, 4),
    (5, 'Superior Suite', 3, 300.00, 1, 20241019, 20241019, 4, 5);
INSERT INTO Reviews (review_id, rate, comment, created_at, updated_at, homestay_id, user_id)
VALUES 
    (1, 5, 'Wonderful stay! The place was beautiful and very clean.', 20241015, 20241015, 1, 1),
    (2, 4, 'Very nice location, but the room could be bigger.', 20241016, 20241016, 1, 2),
    (3, 3, 'Average experience. The service was okay, but not great.', 20241017, 20241017, 2, 3),
    (4, 5, 'Loved it! Perfect for families, very spacious and clean.', 20241018, 20241018, 3, 4),
    (5, 2, 'Not as expected. The photos were misleading.', 20241019, 20241019, 4, 5);
INSERT INTO Photos (photo_id, name_photo, created_at, updated_at, homestay_id)
VALUES 
    (1, 'Cozy Cottage Living Room', 20241015, 20241015, 1),
    (2, 'Beachside Bungalow View', 20241016, 20241016, 2),
    (3, 'Mountain Retreat Exterior', 20241017, 20241017, 3),
    (4, 'Luxurious Suite with Ocean View', 20241018, 20241018, 4),
    (5, 'Charming Garden Area', 20241019, 20241019, 5);
INSERT INTO Services (service_id, service_name, description, price, created_at, updated_at)
VALUES 
    (1, 'Free WiFi', 'High-speed internet available throughout the homestay.', 0.00, 20241001, 20241001),
    (2, 'Airport Pickup', 'Convenient airport pickup service.', 30.00, 20241002, 20241002),
    (3, 'Breakfast Included', 'Delicious breakfast served every morning.', 10.00, 20241003, 20241003),
    (4, 'Guided Tours', 'Explore the local area with our guided tours.', 50.00, 20241004, 20241004),
    (5, 'Spa Access', 'Relax and enjoy our on-site spa services.', 100.00, 20241005, 20241005);
INSERT INTO Services_advantage (homestay_id, service_id, description)
VALUES 
    (1, 1, 'Enjoy complimentary high-speed WiFi in all areas.'),
    (1, 3, 'Breakfast included in your stay.'),
    (2, 2, 'Airport pickup available upon request.'),
    (2, 4, 'Guided tours can be arranged for your convenience.'),
    (3, 1, 'Free WiFi available for all guests.');

-- Thêm dữ liệu vào bảng Users
INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES (0, '', '', '', '', 1, '', '', '', '', '');
INSERT INTO Bookings (booking_id, check_in_date, check_out_date, deposit_price, total_price, status, created_at, updated_at, user_id)
VALUES (0, 0, 0, 0.00, 0.00, 0, 0, 0, 0);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES 
    (6, 'michael_brown', 'passmike', 'michael.brown@example.com', '1234561111', 1, 'Michael Brown', 'avatar6.png', 20241006, 20241006, 1),
    (7, 'lisa_white', 'lisapass', 'lisa.white@example.com', '6543212222', 0, 'Lisa White', 'avatar7.png', 20241007, 20241007, 2),
    (8, 'charles_tan', 'charlessecure', 'charles.tan@example.com', '5556667777', 1, 'Charles Tan', 'avatar8.png', 20241008, 20241008, 1),
    (9, 'nancy_lee', 'nancy123', 'nancy.lee@example.com', '1112223333', 0, 'Nancy Lee', 'avatar9.png', 20241009, 20241009, 2),
    (10, 'george_miller', 'georgepass', 'george.miller@example.com', '9998887777', 1, 'George Miller', 'avatar10.png', 20241010, 20241010, 1),
    (11, 'emma_davis', 'emmapass', 'emma.davis@example.com', '3332221111', 0, 'Emma Davis', 'avatar11.png', 20241011, 20241011, 2),
    (12, 'jack_wilson', 'jacksecure', 'jack.wilson@example.com', '6665554444', 1, 'Jack Wilson', 'avatar12.png', 20241012, 20241012, 1),
    (13, 'anna_thompson', 'annapass', 'anna.thompson@example.com', '7776665555', 0, 'Anna Thompson', 'avatar13.png', 20241013, 20241013, 2),
    (14, 'robert_clark', 'robertsecure', 'robert.clark@example.com', '8887776666', 1, 'Robert Clark', 'avatar14.png', 20241014, 20241014, 1),
    (15, 'sophia_moore', 'sophiapass', 'sophia.moore@example.com', '4443332222', 0, 'Sophia Moore', 'avatar15.png', 20241015, 20241015, 2);

-- Thêm dữ liệu vào bảng Bookings
INSERT INTO Bookings (booking_id, check_in_date, check_out_date, deposit_price, total_price, status, created_at, updated_at, user_id)
VALUES 
    (6, 20241020, 20241025, 220.00, 1100.00, 1, 20241006, 20241006, 6),
    (7, 20241021, 20241026, 180.00, 900.00, 1, 20241007, 20241007, 7),
    (8, 20241022, 20241027, 150.00, 750.00, 0, 20241008, 20241008, 8),
    (9, 20241023, 20241028, 240.00, 1200.00, 1, 20241009, 20241009, 9),
    (10, 20241024, 20241029, 200.00, 1000.00, 1, 20241010, 20241010, 10),
    (11, 20241025, 20241030, 210.00, 1050.00, 1, 20241011, 20241011, 11),
    (12, 20241026, 20241031, 170.00, 850.00, 0, 20241012, 20241012, 12),
    (13, 20241027, 20241101, 190.00, 950.00, 1, 20241013, 20241013, 13),
    (14, 20241028, 20241102, 230.00, 1150.00, 0, 20241014, 20241014, 14),
    (15, 20241029, 20241103, 250.00, 1250.00, 1, 20241015, 20241015, 15);

-- Thêm dữ liệu vào bảng Homestays
INSERT INTO Homestays (homestay_id, name, description, ward, district, province, created_at, updated_at, user_id)
VALUES 
    (6, 'Hue Imperial Homestay', 'Elegant homestay near the ancient city', 'Phuong 5', 'Quan Thanh Pho', 'Hue', 20241006, 20241006, 6),
    (7, 'Hoi An Riverside Homestay', 'Charming homestay by the river', 'Phuong 2', 'Quan Hoi An', 'Quang Nam', 20241007, 20241007, 7),
    (8, 'Phu Quoc Paradise Homestay', 'Tropical retreat with beach access', 'Phuong 3', 'Quan Phu Quoc', 'Kien Giang', 20241008, 20241008, 8),
    (9, 'Can Tho Eco Homestay', 'Eco-friendly homestay in the Mekong Delta', 'Phuong 4', 'Quan Ninh Kieu', 'Can Tho', 20241009, 20241009, 9),
    (10, 'Da Lat Flower Homestay', 'Beautiful homestay surrounded by flowers', 'Phuong 6', 'Quan Da Lat', 'Lam Dong', 20241010, 20241010, 10),
    (11, 'Ha Giang Loop Homestay', 'Homestay with scenic mountain views', 'Phuong 7', 'Huyen Dong Van', 'Ha Giang', 20241011, 20241011, 11),
    (12, 'Vung Tau Coastal Homestay', 'Relaxing homestay with sea views', 'Phuong 8', 'Quan Vung Tau', 'Ba Ria - Vung Tau', 20241012, 20241012, 12),
    (13, 'Con Dao Hideaway Homestay', 'Isolated retreat on Con Dao Island', 'Phuong 9', 'Quan Con Dao', 'Ba Ria - Vung Tau', 20241013, 20241013, 13),
    (14, 'Bac Ninh Heritage Homestay', 'Traditional homestay near pagodas', 'Phuong 10', 'Quan Bac Ninh', 'Bac Ninh', 20241014, 20241014, 14),
    (15, 'Sa Dec Garden Homestay', 'Homestay with beautiful garden views', 'Phuong 11', 'Huyen Sa Dec', 'Dong Thap', 20241015, 20241015, 15);

-- Thêm dữ liệu vào bảng Rooms
INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES 
    (6, 'Garden Room', 1, 140.00, 1, 20241020, 20241020, 6, 6),
    (7, 'Twin Room', 2, 120.00, 1, 20241021, 20241021, 7, 7),
    (8, 'King Room', 1, 180.00, 1, 20241022, 20241022, 8, 8),
    (9, 'Double Room', 2, 110.00, 1, 20241023, 20241023, 9, 9),
    (10, 'Executive Suite', 3, 250.00, 1, 20241024, 20241024, 10, 10),
    (11, 'Budget Room', 2, 90.00, 0, 20241025, 20241025, 11, 11),
    (12, 'Studio Room', 1, 160.00, 1, 20241026, 20241026, 12, 12),
    (13, 'Suite Room', 3, 280.00, 1, 20241027, 20241027, 13, 13),
    (14, 'Panorama Room', 1, 200.00, 0, 20241028, 20241028, 14, 14),
    (15, 'Penthouse Suite', 3, 350.00, 1, 20241029, 20241029, 15, 15);
	INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES 
    (699, 'ô', 1, 140.00, 1, 20241020, 20241020, 6, 0)
-- Thêm dữ liệu vào bảng Reviews
INSERT INTO Reviews (review_id, rate, comment, created_at, updated_at, homestay_id, user_id)
VALUES 
    (6, 5, 'Amazing stay with lovely hosts!', 20241020, 20241020, 6, 6),
    (7, 4, 'Great location but slightly overpriced.', 20241021, 20241021, 7, 7),
    (8, 3, 'Decent experience but could be cleaner.', 20241022, 20241022, 8, 8),
    (9, 4, 'Nice homestay with friendly staff.', 20241023, 20241023, 9, 9),
    (10, 5, 'Exceptional view and service!', 20241024, 20241024, 10, 10),
    (11, 2, 'Room didn’t match the photos.', 20241025, 20241025, 11, 11),
    (12, 3, 'Comfortable but could be better.', 20241026, 20241026, 12, 12),
    (13, 4, 'Good value for the price.', 20241027, 20241027, 13, 13),
    (14, 1, 'Not as expected, too noisy.', 20241028, 20241028, 14, 14),
    (15, 5, 'Perfect place for a getaway!', 20241029, 20241029, 15, 15);

-- Thêm dữ liệu vào bảng Photos
INSERT INTO Photos (photo_id, name_photo, created_at, updated_at, homestay_id)
VALUES 
    (6, 'Hue Homestay Interior', 20241020, 20241020, 6),
    (7, 'Riverside Balcony', 20241021, 20241021, 7),
    (8, 'Beachfront Bungalow', 20241022, 20241022, 8),
    (9, 'Mekong Delta View', 20241023, 20241023, 9),
    (10, 'Garden Area', 20241024, 20241024, 10),
    (11, 'Mountain Scenery', 20241025, 20241025, 11),
    (12, 'Ocean Suite', 20241026, 20241026, 12),
    (13, 'Island Retreat', 20241027, 20241027, 13),
    (14, 'Heritage House', 20241028, 20241028, 14),
    (15, 'Garden Pathway', 20241029, 20241029, 15);

-- Thêm dữ liệu vào bảng Services
INSERT INTO Services (service_id, service_name, description, price, created_at, updated_at)
VALUES 
    (6, 'Laundry Service', 'Convenient laundry services available.', 15.00, 20241006, 20241006),
    (7, 'Room Service', 'Order food and drinks to your room.', 20.00, 20241007, 20241007),
    (8, 'Yoga Class', 'Morning yoga classes offered.', 25.00, 20241008, 20241008),
    (9, 'BBQ Facility', 'Access to outdoor BBQ area.', 30.00, 20241009, 20241009),
    (10, 'Bike Rental', 'Rent bikes for local sightseeing.', 10.00, 20241010, 20241010),
    (11, 'Kids Club', 'Activities and fun for children.', 40.00, 20241011, 20241011),
    (12, 'Airport Drop-off', 'Convenient airport drop-off service.', 35.00, 20241012, 20241012),
    (13, 'Cooking Class', 'Learn to cook local dishes.', 50.00, 20241013, 20241013),
    (14, 'Car Rental', 'Rent a car for your stay.', 60.00, 20241014, 20241014),
    (15, 'Massage Therapy', 'Relaxing massage therapy.', 80.00, 20241015, 20241015);

-- Thêm dữ liệu vào bảng Services_advantage
INSERT INTO Services_advantage (homestay_id, service_id, description)
VALUES 
    (6, 1, 'High-speed internet in all rooms.'),
    (7, 2, 'Free airport pickup for all guests.'),
    (8, 3, 'Daily breakfast included.'),
    (9, 4, 'Guided tours to local attractions.'),
    (10, 5, 'Spa and wellness services available.'),
    (11, 6, 'Laundry service on request.'),
    (12, 7, 'Room service from 7 AM to 10 PM.'),
    (13, 8, 'Yoga classes available in the mornings.'),
    (14, 9, 'BBQ area available for guests.'),
    (15, 10, 'Bike rental for easy exploration.');

INSERT INTO Homestays (homestay_id, name, description, ward, district, province, created_at, updated_at, user_id)
VALUES
    (20, 'Sapa Mountain Homestay', 'A retreat with breathtaking mountain views', 'Cau May Ward', 'Sapa Town', 'Lao Cai', 20241207, 20241207, 0),
    (21, 'Hanoi Old Quarter Homestay', 'Homestay near the heart of Hanoi Old Quarter', 'Hang Buom Ward', 'Hoan Kiem District', 'Hanoi', 20241207, 20241207, 0),
    (22, 'Danang Beach Homestay', 'Comfortable homestay near My Khe Beach', 'An Hai Bac Ward', 'Son Tra District', 'Da Nang', 20241207, 20241207, 0),
    (23, 'Saigon Central Homestay', 'Luxury homestay in the heart of Saigon', 'Ben Nghe Ward', 'District 1', 'Ho Chi Minh City', 20241207, 20241207, 0),
    (24, 'Quy Nhon Blue Sea Homestay', 'Peaceful homestay with blue sea views', 'Hai Cang Ward', 'Quy Nhon City', 'Binh Dinh', 20241207, 20241207, 0),
    (25, 'Phong Nha Scenic Homestay', 'Homestay near the Phong Nha natural heritage', 'Son Trach Ward', 'Bo Trach District', 'Quang Binh', 20241207, 20241207, 0),
    (26, 'Can Tho Mekong Homestay', 'Peaceful homestay with views of the Mekong River', 'Xuan Khanh Ward', 'Ninh Kieu District', 'Can Tho', 20241207, 20241207, 0),
    (27, 'Da Lat Flower Hill Homestay', 'Homestay surrounded by beautiful flower hills', 'Ward 8', 'Da Lat City', 'Lam Dong', 20241207, 20241207, 0),
    (28, 'Hoi An Countryside Homestay', 'Peaceful homestay in the ancient countryside', 'Cam Chau Ward', 'Hoi An City', 'Quang Nam', 20241207, 20241207, 0),
    (29, 'Hue Imperial Homestay', 'Homestay near the historic Hue Imperial City', 'Thuan Thanh Ward', 'Hue City', 'Thua Thien Hue', 20241207, 20241207, 0),
    (30, 'Ha Long Bay Homestay', 'Homestay near the beautiful Ha Long Bay', 'Bai Chay Ward', 'Ha Long City', 'Quang Ninh', 20241207, 20241207, 0),
    (31, 'Tay Ninh Mountain Homestay', 'Homestay near the Ba Den Mountain tourist area', 'Ninh Son Ward', 'Tay Ninh City', 'Tay Ninh', 20241207, 20241207, 0),
    (32, 'Vung Tau Coastal Homestay', 'Well-equipped homestay with sea views', 'Thang Tam Ward', 'Vung Tau City', 'Ba Ria - Vung Tau', 20241207, 20241207, 0),
    (33, 'Ha Giang Highland Homestay', 'Homestay near the Dong Van Karst Plateau', 'Tam Son Ward', 'Dong Van District', 'Ha Giang', 20241207, 20241207, 0),
    (34, 'Moc Chau Tea Hill Homestay', 'Homestay located in the middle of Moc Chau tea hills', 'Tan Lap Ward', 'Moc Chau District', 'Son La', 20241207, 20241207, 0),
    (35, 'Nha Trang Beach Homestay', 'Homestay near Nha Trang beach', 'Loc Tho Ward', 'Nha Trang City', 'Khanh Hoa', 20241207, 20241207, 0),
    (36, 'Phu Quoc Paradise Homestay', 'Homestay in the paradise island of Phu Quoc', 'Duong Dong Ward', 'Phu Quoc City', 'Kien Giang', 20241207, 20241207, 0);
-- Insert into Rooms for Homestay ID 1 to 36, each having 7 rooms with actual room names and types (1 or 2)
INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES
    -- Homestay Hanoi CITY (ID 1)
    (16, 'Hanoi City Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 1, 0),
    (17, 'Hanoi City Standard Room', 2, 120.00, 1, 20241207, 20241207, 1, 0),
    (18, 'Hanoi City Economy Room', 1, 110.00, 1, 20241207, 20241207, 1, 0),
    (19, 'Hanoi City Family Suite', 2, 130.00, 1, 20241207, 20241207, 1, 0),
    (20, 'Hanoi City Executive Suite', 1, 140.00, 1, 20241207, 20241207, 1, 0),
    (21, 'Hanoi City Premium Room', 2, 150.00, 1, 20241207, 20241207, 1, 0),
    (22, 'Hanoi City Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 1, 0),

    -- Homestay Saigon Riverside (ID 2)
    (23, 'Saigon Riverside Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 2, 0),
    (24, 'Saigon Riverside Standard Room', 2, 120.00, 1, 20241207, 20241207, 2, 0),
    (25, 'Saigon Riverside Economy Room', 1, 110.00, 1, 20241207, 20241207, 2, 0),
    (26, 'Saigon Riverside Family Suite', 2, 130.00, 1, 20241207, 20241207, 2, 0),
    (27, 'Saigon Riverside Executive Suite', 1, 140.00, 1, 20241207, 20241207, 2, 0),
    (28, 'Saigon Riverside Premium Room', 2, 150.00, 1, 20241207, 20241207, 2, 0),
    (29, 'Saigon Riverside Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 2, 0),

    -- Homestay Da Nang Beach (ID 3)
    (30, 'Da Nang Beach Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 3, 0),
    (31, 'Da Nang Beach Standard Room', 2, 120.00, 1, 20241207, 20241207, 3, 0),
    (32, 'Da Nang Beach Economy Room', 1, 110.00, 1, 20241207, 20241207, 3, 0),
    (33, 'Da Nang Beach Family Suite', 2, 130.00, 1, 20241207, 20241207, 3, 0),
    (34, 'Da Nang Beach Executive Suite', 1, 140.00, 1, 20241207, 20241207, 3, 0),
    (35, 'Da Nang Beach Premium Room', 2, 150.00, 1, 20241207, 20241207, 3, 0),
    (36, 'Da Nang Beach Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 3, 0),

    -- Homestay Ninh Binh Nature (ID 4)
    (37, 'Ninh Binh Nature Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 4, 0),
    (38, 'Ninh Binh Nature Standard Room', 2, 120.00, 1, 20241207, 20241207, 4, 0),
    (39, 'Ninh Binh Nature Economy Room', 1, 110.00, 1, 20241207, 20241207, 4, 0),
    (40, 'Ninh Binh Nature Family Suite', 2, 130.00, 1, 20241207, 20241207, 4, 0),
    (41, 'Ninh Binh Nature Executive Suite', 1, 140.00, 1, 20241207, 20241207, 4, 0),
    (42, 'Ninh Binh Nature Premium Room', 2, 150.00, 1, 20241207, 20241207, 4, 0),
    (43, 'Ninh Binh Nature Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 4, 0),

    -- Homestay Sapa Mountain (ID 5)
    (44, 'Sapa Mountain Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 5, 0),
    (45, 'Sapa Mountain Standard Room', 2, 120.00, 1, 20241207, 20241207, 5, 0),
    (46, 'Sapa Mountain Economy Room', 1, 110.00, 1, 20241207, 20241207, 5, 0),
    (47, 'Sapa Mountain Family Suite', 2, 130.00, 1, 20241207, 20241207, 5, 0),
    (48, 'Sapa Mountain Executive Suite', 1, 140.00, 1, 20241207, 20241207, 5, 0),
    (49, 'Sapa Mountain Premium Room', 2, 150.00, 1, 20241207, 20241207, 5, 0),
    (50, 'Sapa Mountain Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 5, 0),

    -- Homestay Hue Imperial (ID 6)
    (51, 'Hue Imperial Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 6, 0),
    (52, 'Hue Imperial Standard Room', 2, 120.00, 1, 20241207, 20241207, 6, 0),
    (53, 'Hue Imperial Economy Room', 1, 110.00, 1, 20241207, 20241207, 6, 0),
    (54, 'Hue Imperial Family Suite', 2, 130.00, 1, 20241207, 20241207, 6, 0),
    (55, 'Hue Imperial Executive Suite', 1, 140.00, 1, 20241207, 20241207, 6, 0),
    (56, 'Hue Imperial Premium Room', 2, 150.00, 1, 20241207, 20241207, 6, 0),
    (57, 'Hue Imperial Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 6, 0),

    -- Homestay Hoi An Riverside (ID 7)
    (58, 'Hoi An Riverside Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 7, 0),
    (59, 'Hoi An Riverside Standard Room', 2, 120.00, 1, 20241207, 20241207, 7, 0),
    (60, 'Hoi An Riverside Economy Room', 1, 110.00, 1, 20241207, 20241207, 7, 0),
    (61, 'Hoi An Riverside Family Suite', 2, 130.00, 1, 20241207, 20241207, 7, 0),
    (62, 'Hoi An Riverside Executive Suite', 1, 140.00, 1, 20241207, 20241207, 7, 0),
    (63, 'Hoi An Riverside Premium Room', 2, 150.00, 1, 20241207, 20241207, 7, 0),
    (64, 'Hoi An Riverside Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 7, 0)

  
-- Homestay Phu Quoc Paradise (ID 8)
INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES
    (65, 'Phu Quoc Paradise Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 8, 0),
    (66, 'Phu Quoc Paradise Standard Room', 2, 120.00, 1, 20241207, 20241207, 8, 0),
    (67, 'Phu Quoc Paradise Economy Room', 1, 110.00, 1, 20241207, 20241207, 8, 0),
    (68, 'Phu Quoc Paradise Family Suite', 2, 130.00, 1, 20241207, 20241207, 8, 0),
    (69, 'Phu Quoc Paradise Executive Suite', 1, 140.00, 1, 20241207, 20241207, 8, 0),
    (70, 'Phu Quoc Paradise Premium Room', 2, 150.00, 1, 20241207, 20241207, 8, 0),
    (71, 'Phu Quoc Paradise Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 8, 0),

-- Homestay Can Tho Eco (ID 9)
    (72, 'Can Tho Eco Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 9, 0),
    (73, 'Can Tho Eco Standard Room', 2, 120.00, 1, 20241207, 20241207, 9, 0),
    (74, 'Can Tho Eco Economy Room', 1, 110.00, 1, 20241207, 20241207, 9, 0),
    (75, 'Can Tho Eco Family Suite', 2, 130.00, 1, 20241207, 20241207, 9, 0),
    (76, 'Can Tho Eco Executive Suite', 1, 140.00, 1, 20241207, 20241207, 9, 0),
    (77, 'Can Tho Eco Premium Room', 2, 150.00, 1, 20241207, 20241207, 9, 0),
    (78, 'Can Tho Eco Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 9, 0),

-- Homestay Da Lat Flower (ID 10)
    (79, 'Da Lat Flower Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 10, 0),
    (80, 'Da Lat Flower Standard Room', 2, 120.00, 1, 20241207, 20241207, 10, 0),
    (81, 'Da Lat Flower Economy Room', 1, 110.00, 1, 20241207, 20241207, 10, 0),
    (82, 'Da Lat Flower Family Suite', 2, 130.00, 1, 20241207, 20241207, 10, 0),
    (83, 'Da Lat Flower Executive Suite', 1, 140.00, 1, 20241207, 20241207, 10, 0),
    (84, 'Da Lat Flower Premium Room', 2, 150.00, 1, 20241207, 20241207, 10, 0),
    (85, 'Da Lat Flower Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 10, 0),

-- Homestay Ha Giang Loop (ID 11)
    (86, 'Ha Giang Loop Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 11, 0),
    (87, 'Ha Giang Loop Standard Room', 2, 120.00, 1, 20241207, 20241207, 11, 0),
    (88, 'Ha Giang Loop Economy Room', 1, 110.00, 1, 20241207, 20241207, 11, 0),
    (89, 'Ha Giang Loop Family Suite', 2, 130.00, 1, 20241207, 20241207, 11, 0),
    (90, 'Ha Giang Loop Executive Suite', 1, 140.00, 1, 20241207, 20241207, 11, 0),
    (91, 'Ha Giang Loop Premium Room', 2, 150.00, 1, 20241207, 20241207, 11, 0),
    (92, 'Ha Giang Loop Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 11, 0),

-- Homestay Vung Tau Coastal (ID 12)
    (93, 'Vung Tau Coastal Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 12, 0),
    (94, 'Vung Tau Coastal Standard Room', 2, 120.00, 1, 20241207, 20241207, 12, 0),
    (95, 'Vung Tau Coastal Economy Room', 1, 110.00, 1, 20241207, 20241207, 12, 0),
    (96, 'Vung Tau Coastal Family Suite', 2, 130.00, 1, 20241207, 20241207, 12, 0),
    (97, 'Vung Tau Coastal Executive Suite', 1, 140.00, 1, 20241207, 20241207, 12, 0),
    (98, 'Vung Tau Coastal Premium Room', 2, 150.00, 1, 20241207, 20241207, 12, 0),
    (99, 'Vung Tau Coastal Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 12, 0),

-- Homestay Con Dao Hideaway (ID 13)
    (100, 'Con Dao Hideaway Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 13, 0),
    (101, 'Con Dao Hideaway Standard Room', 2, 120.00, 1, 20241207, 20241207, 13, 0),
    (102, 'Con Dao Hideaway Economy Room', 1, 110.00, 1, 20241207, 20241207, 13, 0),
    (103, 'Con Dao Hideaway Family Suite', 2, 130.00, 1, 20241207, 20241207, 13, 0),
    (104, 'Con Dao Hideaway Executive Suite', 1, 140.00, 1, 20241207, 20241207, 13, 0),
    (105, 'Con Dao Hideaway Premium Room', 2, 150.00, 1, 20241207, 20241207, 13, 0),
    (106, 'Con Dao Hideaway Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 13, 0),

-- Homestay Bac Ninh Heritage (ID 14)
    (107, 'Bac Ninh Heritage Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 14, 0),
    (108, 'Bac Ninh Heritage Standard Room', 2, 120.00, 1, 20241207, 20241207, 14, 0),
    (109, 'Bac Ninh Heritage Economy Room', 1, 110.00, 1, 20241207, 20241207, 14, 0),
    (110, 'Bac Ninh Heritage Family Suite', 2, 130.00, 1, 20241207, 20241207, 14, 0),
    (111, 'Bac Ninh Heritage Executive Suite', 1, 140.00, 1, 20241207, 20241207, 14, 0),
    (112, 'Bac Ninh Heritage Premium Room', 2, 150.00, 1, 20241207, 20241207, 14, 0),
    (113, 'Bac Ninh Heritage Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 14, 0),

-- Homestay Sapa Mountain (ID 20)
    (114, 'Sapa Mountain Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 20, 0),
    (115, 'Sapa Mountain Standard Room', 2, 120.00, 1, 20241207, 20241207, 20, 0),
    (116, 'Sapa Mountain Economy Room', 1, 110.00, 1, 20241207, 20241207, 20, 0),
    (117, 'Sapa Mountain Family Suite', 2, 130.00, 1, 20241207, 20241207, 20, 0),
    (118, 'Sapa Mountain Executive Suite', 1, 140.00, 1, 20241207, 20241207, 20, 0),
    (119, 'Sapa Mountain Premium Room', 2, 150.00, 1, 20241207, 20241207, 20, 0),
    (120, 'Sapa Mountain Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 20, 0)

-- Continue with the rest of the homestays (ID 21 to 36)
-- Please let me know if you want me to continue or have any adjustments!
INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES
    (121, 'Hanoi Old Quarter Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 21, 0),
    (122, 'Hanoi Old Quarter Standard Room', 2, 120.00, 1, 20241207, 20241207, 21, 0),
    (123, 'Hanoi Old Quarter Economy Room', 1, 110.00, 1, 20241207, 20241207, 21, 0),
    (124, 'Hanoi Old Quarter Family Suite', 2, 130.00, 1, 20241207, 20241207, 21, 0),
    (125, 'Hanoi Old Quarter Executive Suite', 1, 140.00, 1, 20241207, 20241207, 21, 0),
    (126, 'Hanoi Old Quarter Premium Room', 2, 150.00, 1, 20241207, 20241207, 21, 0),
    (127, 'Hanoi Old Quarter Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 21, 0),

-- Homestay Danang Beach (ID 22)
    (128, 'Danang Beach Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 22, 0),
    (129, 'Danang Beach Standard Room', 2, 120.00, 1, 20241207, 20241207, 22, 0),
    (130, 'Danang Beach Economy Room', 1, 110.00, 1, 20241207, 20241207, 22, 0),
    (131, 'Danang Beach Family Suite', 2, 130.00, 1, 20241207, 20241207, 22, 0),
    (132, 'Danang Beach Executive Suite', 1, 140.00, 1, 20241207, 20241207, 22, 0),
    (133, 'Danang Beach Premium Room', 2, 150.00, 1, 20241207, 20241207, 22, 0),
    (134, 'Danang Beach Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 22, 0),

-- Homestay Saigon Central (ID 23)
    (135, 'Saigon Central Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 23, 0),
    (136, 'Saigon Central Standard Room', 2, 120.00, 1, 20241207, 20241207, 23, 0),
    (137, 'Saigon Central Economy Room', 1, 110.00, 1, 20241207, 20241207, 23, 0),
    (138, 'Saigon Central Family Suite', 2, 130.00, 1, 20241207, 20241207, 23, 0),
    (139, 'Saigon Central Executive Suite', 1, 140.00, 1, 20241207, 20241207, 23, 0),
    (140, 'Saigon Central Premium Room', 2, 150.00, 1, 20241207, 20241207, 23, 0),
    (141, 'Saigon Central Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 23, 0),

-- Homestay Quy Nhon Blue Sea (ID 24)
    (142, 'Quy Nhon Blue Sea Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 24, 0),
    (143, 'Quy Nhon Blue Sea Standard Room', 2, 120.00, 1, 20241207, 20241207, 24, 0),
    (144, 'Quy Nhon Blue Sea Economy Room', 1, 110.00, 1, 20241207, 20241207, 24, 0),
    (145, 'Quy Nhon Blue Sea Family Suite', 2, 130.00, 1, 20241207, 20241207, 24, 0),
    (146, 'Quy Nhon Blue Sea Executive Suite', 1, 140.00, 1, 20241207, 20241207, 24, 0),
    (147, 'Quy Nhon Blue Sea Premium Room', 2, 150.00, 1, 20241207, 20241207, 24, 0),
    (148, 'Quy Nhon Blue Sea Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 24, 0),

-- Homestay Phong Nha Scenic (ID 25)
    (149, 'Phong Nha Scenic Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 25, 0),
    (150, 'Phong Nha Scenic Standard Room', 2, 120.00, 1, 20241207, 20241207, 25, 0),
    (151, 'Phong Nha Scenic Economy Room', 1, 110.00, 1, 20241207, 20241207, 25, 0),
    (152, 'Phong Nha Scenic Family Suite', 2, 130.00, 1, 20241207, 20241207, 25, 0),
    (153, 'Phong Nha Scenic Executive Suite', 1, 140.00, 1, 20241207, 20241207, 25, 0),
    (154, 'Phong Nha Scenic Premium Room', 2, 150.00, 1, 20241207, 20241207, 25, 0),
    (155, 'Phong Nha Scenic Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 25, 0),

-- Homestay Can Tho Mekong (ID 26)
    (156, 'Can Tho Mekong Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 26, 0),
    (157, 'Can Tho Mekong Standard Room', 2, 120.00, 1, 20241207, 20241207, 26, 0),
    (158, 'Can Tho Mekong Economy Room', 1, 110.00, 1, 20241207, 20241207, 26, 0),
    (159, 'Can Tho Mekong Family Suite', 2, 130.00, 1, 20241207, 20241207, 26, 0),
    (160, 'Can Tho Mekong Executive Suite', 1, 140.00, 1, 20241207, 20241207, 26, 0),
    (161, 'Can Tho Mekong Premium Room', 2, 150.00, 1, 20241207, 20241207, 26, 0),
    (162, 'Can Tho Mekong Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 26, 0),

-- Homestay Da Lat Flower Hill (ID 27)
    (163, 'Da Lat Flower Hill Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 27, 0),
    (164, 'Da Lat Flower Hill Standard Room', 2, 120.00, 1, 20241207, 20241207, 27, 0),
    (165, 'Da Lat Flower Hill Economy Room', 1, 110.00, 1, 20241207, 20241207, 27, 0),
    (166, 'Da Lat Flower Hill Family Suite', 2, 130.00, 1, 20241207, 20241207, 27, 0),
    (167, 'Da Lat Flower Hill Executive Suite', 1, 140.00, 1, 20241207, 20241207, 27, 0),
    (168, 'Da Lat Flower Hill Premium Room', 2, 150.00, 1, 20241207, 20241207, 27, 0),
    (169, 'Da Lat Flower Hill Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 27, 0),

-- Homestay Hoi An Countryside (ID 28)
    (170, 'Hoi An Countryside Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 28, 0),
    (171, 'Hoi An Countryside Standard Room', 2, 120.00, 1, 20241207, 20241207, 28, 0),
    (172, 'Hoi An Countryside Economy Room', 1, 110.00, 1, 20241207, 20241207, 28, 0),
    (173, 'Hoi An Countryside Family Suite', 2, 130.00, 1, 20241207, 20241207, 28, 0),
    (174, 'Hoi An Countryside Executive Suite', 1, 140.00, 1, 20241207, 20241207, 28, 0),
    (175, 'Hoi An Countryside Premium Room', 2, 150.00, 1, 20241207, 20241207, 28, 0),
    (176, 'Hoi An Countryside Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 28, 0)
-- Homestay Hue Imperial (ID 29)
INSERT INTO Rooms (room_id, room_name, room_type, price, status, created_at, updated_at, homestay_id, booking_id)
VALUES
    (177, 'Hue Imperial Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 29, 0),
    (178, 'Hue Imperial Standard Room', 2, 120.00, 1, 20241207, 20241207, 29, 0),
    (179, 'Hue Imperial Economy Room', 1, 110.00, 1, 20241207, 20241207, 29, 0),
    (180, 'Hue Imperial Family Suite', 2, 130.00, 1, 20241207, 20241207, 29, 0),
    (181, 'Hue Imperial Executive Suite', 1, 140.00, 1, 20241207, 20241207, 29, 0),
    (182, 'Hue Imperial Premium Room', 2, 150.00, 1, 20241207, 20241207, 29, 0),
    (183, 'Hue Imperial Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 29, 0),

-- Homestay Ha Long Bay (ID 30)
    (184, 'Ha Long Bay Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 30, 0),
    (185, 'Ha Long Bay Standard Room', 2, 120.00, 1, 20241207, 20241207, 30, 0),
    (186, 'Ha Long Bay Economy Room', 1, 110.00, 1, 20241207, 20241207, 30, 0),
    (187, 'Ha Long Bay Family Suite', 2, 130.00, 1, 20241207, 20241207, 30, 0),
    (188, 'Ha Long Bay Executive Suite', 1, 140.00, 1, 20241207, 20241207, 30, 0),
    (189, 'Ha Long Bay Premium Room', 2, 150.00, 1, 20241207, 20241207, 30, 0),
    (190, 'Ha Long Bay Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 30, 0),

-- Homestay Tay Ninh Mountain (ID 31)
    (191, 'Tay Ninh Mountain Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 31, 0),
    (192, 'Tay Ninh Mountain Standard Room', 2, 120.00, 1, 20241207, 20241207, 31, 0),
    (193, 'Tay Ninh Mountain Economy Room', 1, 110.00, 1, 20241207, 20241207, 31, 0),
    (194, 'Tay Ninh Mountain Family Suite', 2, 130.00, 1, 20241207, 20241207, 31, 0),
    (195, 'Tay Ninh Mountain Executive Suite', 1, 140.00, 1, 20241207, 20241207, 31, 0),
    (196, 'Tay Ninh Mountain Premium Room', 2, 150.00, 1, 20241207, 20241207, 31, 0),
    (197, 'Tay Ninh Mountain Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 31, 0),

-- Homestay Vung Tau Coastal (ID 32)
    (198, 'Vung Tau Coastal Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 32, 0),
    (199, 'Vung Tau Coastal Standard Room', 2, 120.00, 1, 20241207, 20241207, 32, 0),
    (200, 'Vung Tau Coastal Economy Room', 1, 110.00, 1, 20241207, 20241207, 32, 0),
    (201, 'Vung Tau Coastal Family Suite', 2, 130.00, 1, 20241207, 20241207, 32, 0),
    (202, 'Vung Tau Coastal Executive Suite', 1, 140.00, 1, 20241207, 20241207, 32, 0),
    (203, 'Vung Tau Coastal Premium Room', 2, 150.00, 1, 20241207, 20241207, 32, 0),
    (204, 'Vung Tau Coastal Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 32, 0),

-- Homestay Ha Giang Highland (ID 33)
    (205, 'Ha Giang Highland Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 33, 0),
    (206, 'Ha Giang Highland Standard Room', 2, 120.00, 1, 20241207, 20241207, 33, 0),
    (207, 'Ha Giang Highland Economy Room', 1, 110.00, 1, 20241207, 20241207, 33, 0),
    (208, 'Ha Giang Highland Family Suite', 2, 130.00, 1, 20241207, 20241207, 33, 0),
    (209, 'Ha Giang Highland Executive Suite', 1, 140.00, 1, 20241207, 20241207, 33, 0),
    (210, 'Ha Giang Highland Premium Room', 2, 150.00, 1, 20241207, 20241207, 33, 0),
    (211, 'Ha Giang Highland Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 33, 0),

-- Homestay Moc Chau Tea Hill (ID 34)
    (212, 'Moc Chau Tea Hill Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 34, 0),
    (213, 'Moc Chau Tea Hill Standard Room', 2, 120.00, 1, 20241207, 20241207, 34, 0),
    (214, 'Moc Chau Tea Hill Economy Room', 1, 110.00, 1, 20241207, 20241207, 34, 0),
    (215, 'Moc Chau Tea Hill Family Suite', 2, 130.00, 1, 20241207, 20241207, 34, 0),
    (216, 'Moc Chau Tea Hill Executive Suite', 1, 140.00, 1, 20241207, 20241207, 34, 0),
    (217, 'Moc Chau Tea Hill Premium Room', 2, 150.00, 1, 20241207, 20241207, 34, 0),
    (218, 'Moc Chau Tea Hill Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 34, 0),

-- Homestay Nha Trang Beach (ID 35)
    (219, 'Nha Trang Beach Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 35, 0),
    (220, 'Nha Trang Beach Standard Room', 2, 120.00, 1, 20241207, 20241207, 35, 0),
    (221, 'Nha Trang Beach Economy Room', 1, 110.00, 1, 20241207, 20241207, 35, 0),
    (222, 'Nha Trang Beach Family Suite', 2, 130.00, 1, 20241207, 20241207, 35, 0),
    (223, 'Nha Trang Beach Executive Suite', 1, 140.00, 1, 20241207, 20241207, 35, 0),
    (224, 'Nha Trang Beach Premium Room', 2, 150.00, 1, 20241207, 20241207, 35, 0),
    (225, 'Nha Trang Beach Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 35, 0),

-- Homestay Phu Quoc Paradise (ID 36)
    (226, 'Phu Quoc Paradise Deluxe Room', 1, 100.00, 1, 20241207, 20241207, 36, 0),
    (227, 'Phu Quoc Paradise Standard Room', 2, 120.00, 1, 20241207, 20241207, 36, 0),
    (228, 'Phu Quoc Paradise Economy Room', 1, 110.00, 1, 20241207, 20241207, 36, 0),
    (229, 'Phu Quoc Paradise Family Suite', 2, 130.00, 1, 20241207, 20241207, 36, 0),
    (230, 'Phu Quoc Paradise Executive Suite', 1, 140.00, 1, 20241207, 20241207, 36, 0),
    (231, 'Phu Quoc Paradise Premium Room', 2, 150.00, 1, 20241207, 20241207, 36, 0),
    (232, 'Phu Quoc Paradise Presidential Suite', 1, 160.00, 1, 20241207, 20241207, 36, 0)
INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(16, 'william_jones', 'williampass', 'william.jones@example.com', '9991112222', 1, 'William Jones', 'avatar16.png', 20241016, 20241016, 1),
(17, 'olivia_smith', 'oliviapass', 'olivia.smith@example.com', '8889997777', 0, 'Olivia Smith', 'avatar17.png', 20241017, 20241017, 2),
(18, 'daniel_taylor', 'danielpass', 'daniel.taylor@example.com', '7778886666', 1, 'Daniel Taylor', 'avatar18.png', 20241018, 20241018, 1),
(19, 'sophia_martin', 'sophiapass', 'sophia.martin@example.com', '6667775555', 0, 'Sophia Martin', 'avatar19.png', 20241019, 20241019, 2),
(20, 'james_clark', 'jamespass', 'james.clark@example.com', '5556664444', 1, 'James Clark', 'avatar20.png', 20241020, 20241020, 1),
(21, 'mia_king', 'miapass', 'mia.king@example.com', '4445553333', 0, 'Mia King', 'avatar21.png', 20241021, 20241021, 2),
(22, 'lucas_harris', 'lucaspass', 'lucas.harris@example.com', '3334442222', 1, 'Lucas Harris', 'avatar22.png', 20241022, 20241022, 1),
(23, 'isabella_davis', 'isabellapass', 'isabella.davis@example.com', '2223331111', 0, 'Isabella Davis', 'avatar23.png', 20241023, 20241023, 2),
(24, 'henry_walker', 'henrypass', 'henry.walker@example.com', '1112220000', 1, 'Henry Walker', 'avatar24.png', 20241024, 20241024, 1),
(25, 'ava_lee', 'avapass', 'ava.lee@example.com', '9998887777', 0, 'Ava Lee', 'avatar25.png', 20241025, 20241025, 2),
(26, 'jackson_hall', 'jacksonpass', 'jackson.hall@example.com', '8887776666', 1, 'Jackson Hall', 'avatar26.png', 20241026, 20241026, 1),
(27, 'emily_allen', 'emilypass', 'emily.allen@example.com', '7776665555', 0, 'Emily Allen', 'avatar27.png', 20241027, 20241027, 2),
(28, 'logan_sanders', 'loganpass', 'logan.sanders@example.com', '6665554444', 1, 'Logan Sanders', 'avatar28.png', 20241028, 20241028, 1),
(29, 'amelia_baker', 'ameliapass', 'amelia.baker@example.com', '5554443333', 0, 'Amelia Baker', 'avatar29.png', 20241029, 20241029, 2),
(30, 'sebastian_adams', 'sebastianpass', 'sebastian.adams@example.com', '4443332222', 1, 'Sebastian Adams', 'avatar30.png', 20241030, 20241030, 1),
(31, 'harper_collins', 'harperpass', 'harper.collins@example.com', '3332221111', 0, 'Harper Collins', 'avatar31.png', 20241031, 20241031, 2),
(32, 'grayson_hernandez', 'graysonpass', 'grayson.hernandez@example.com', '2221110000', 1, 'Grayson Hernandez', 'avatar32.png', 20241101, 20241101, 1),
(33, 'scarlett_evans', 'scarlettpass', 'scarlett.evans@example.com', '1110009999', 0, 'Scarlett Evans', 'avatar33.png', 20241102, 20241102, 2),
(34, 'luke_morris', 'lukepass', 'luke.morris@example.com', '9998887777', 1, 'Luke Morris', 'avatar34.png', 20241103, 20241103, 1),
(35, 'chloe_thomas', 'chloepass', 'chloe.thomas@example.com', '8887776666', 0, 'Chloe Thomas', 'avatar35.png', 20241104, 20241104, 2),
(36, 'elijah_thompson', 'elijahpass', 'elijah.thompson@example.com', '7776665555', 1, 'Elijah Thompson', 'avatar36.png', 20241105, 20241105, 1),
(37, 'sofia_anderson', 'sofiapass', 'sofia.anderson@example.com', '6665554444', 0, 'Sofia Anderson', 'avatar37.png', 20241106, 20241106, 2),
(38, 'aiden_white', 'aidenpass', 'aiden.white@example.com', '5554443333', 1, 'Aiden White', 'avatar38.png', 20241107, 20241107, 1),
(39, 'aria_wilson', 'ariapass', 'aria.wilson@example.com', '4443332222', 0, 'Aria Wilson', 'avatar39.png', 20241108, 20241108, 2),
(40, 'mason_taylor', 'masonpass', 'mason.taylor@example.com', '3332221111', 1, 'Mason Taylor', 'avatar40.png', 20241109, 20241109, 1),
(41, 'lily_clark', 'lilypass', 'lily.clark@example.com', '2221110000', 0, 'Lily Clark', 'avatar41.png', 20241110, 20241110, 2);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(42, 'ethan_moore', 'ethanpass', 'ethan.moore@example.com', '1110009998', 1, 'Ethan Moore', 'avatar42.png', 20241111, 20241111, 1),
(43, 'zoe_brown', 'zoepass', 'zoe.brown@example.com', '9998887776', 0, 'Zoe Brown', 'avatar43.png', 20241112, 20241112, 2),
(44, 'alexander_davis', 'alexanderpass', 'alexander.davis@example.com', '8887776665', 1, 'Alexander Davis', 'avatar44.png', 20241113, 20241113, 1),
(45, 'ella_jones', 'ellapass', 'ella.jones@example.com', '7776665554', 0, 'Ella Jones', 'avatar45.png', 20241114, 20241114, 2),
(46, 'ryan_williams', 'ryanpass', 'ryan.williams@example.com', '6665554443', 1, 'Ryan Williams', 'avatar46.png', 20241115, 20241115, 1),
(47, 'aria_taylor', 'ariapass', 'aria.taylor@example.com', '5554443332', 0, 'Aria Taylor', 'avatar47.png', 20241116, 20241116, 2),
(48, 'noah_anderson', 'noahpass', 'noah.anderson@example.com', '4443332221', 1, 'Noah Anderson', 'avatar48.png', 20241117, 20241117, 1),
(49, 'sofia_clark', 'sofiapass', 'sofia.clark@example.com', '3332221110', 0, 'Sofia Clark', 'avatar49.png', 20241118, 20241118, 2),
(50, 'logan_thomas', 'loganpass', 'logan.thomas@example.com', '2221110009', 1, 'Logan Thomas', 'avatar50.png', 20241119, 20241119, 1),
(51, 'chloe_johnson', 'chloepass', 'chloe.johnson@example.com', '1110009997', 0, 'Chloe Johnson', 'avatar51.png', 20241120, 20241120, 2),
(52, 'liam_harris', 'liampass', 'liam.harris@example.com', '9998887775', 1, 'Liam Harris', 'avatar52.png', 20241121, 20241121, 1),
(53, 'mia_evans', 'miapass', 'mia.evans@example.com', '8887776664', 0, 'Mia Evans', 'avatar53.png', 20241122, 20241122, 2),
(54, 'oliver_white', 'oliverpass', 'oliver.white@example.com', '7776665553', 1, 'Oliver White', 'avatar54.png', 20241123, 20241123, 1),
(55, 'ava_wilson', 'avapass', 'ava.wilson@example.com', '6665554442', 0, 'Ava Wilson', 'avatar55.png', 20241124, 20241124, 2),
(56, 'lucas_martin', 'lucaspass', 'lucas.martin@example.com', '5554443331', 1, 'Lucas Martin', 'avatar56.png', 20241125, 20241125, 1),
(57, 'emma_brown', 'emmapass', 'emma.brown@example.com', '4443332220', 0, 'Emma Brown', 'avatar57.png', 20241126, 20241126, 2),
(58, 'jacob_king', 'jacobpass', 'jacob.king@example.com', '3332221119', 1, 'Jacob King', 'avatar58.png', 20241127, 20241127, 1),
(59, 'amelia_moore', 'ameliapass', 'amelia.moore@example.com', '2221110008', 0, 'Amelia Moore', 'avatar59.png', 20241128, 20241128, 2),
(60, 'elijah_allen', 'elijahpass', 'elijah.allen@example.com', '1110009996', 1, 'Elijah Allen', 'avatar60.png', 20241129, 20241129, 1),
(61, 'harper_adams', 'harperpass', 'harper.adams@example.com', '9998887774', 0, 'Harper Adams', 'avatar61.png', 20241130, 20241130, 2);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(62, 'james_scott', 'jamespass', 'james.scott@example.com', '8887776663', 1, 'James Scott', 'avatar62.png', 20241201, 20241201, 1),
(63, 'isabella_hill', 'isabellapass', 'isabella.hill@example.com', '7776665552', 0, 'Isabella Hill', 'avatar63.png', 20241202, 20241202, 2),
(64, 'benjamin_green', 'benjaminpass', 'benjamin.green@example.com', '6665554441', 1, 'Benjamin Green', 'avatar64.png', 20241203, 20241203, 1),
(65, 'sophia_edwards', 'sophiapass', 'sophia.edwards@example.com', '5554443330', 0, 'Sophia Edwards', 'avatar65.png', 20241204, 20241204, 2),
(66, 'matthew_turner', 'matthewpass', 'matthew.turner@example.com', '4443332229', 1, 'Matthew Turner', 'avatar66.png', 20241205, 20241205, 1),
(67, 'ava_carter', 'avacarterpass', 'ava.carter@example.com', '3332221118', 0, 'Ava Carter', 'avatar67.png', 20241206, 20241206, 2),
(68, 'daniel_bailey', 'danielpass', 'daniel.bailey@example.com', '2221110007', 1, 'Daniel Bailey', 'avatar68.png', 20241207, 20241207, 1),
(69, 'charlotte_cooper', 'charlottepass', 'charlotte.cooper@example.com', '1110009995', 0, 'Charlotte Cooper', 'avatar69.png', 20241208, 20241208, 2),
(70, 'henry_ward', 'henrypass', 'henry.ward@example.com', '9998887773', 1, 'Henry Ward', 'avatar70.png', 20241209, 20241209, 1),
(71, 'mia_perez', 'miaperezpass', 'mia.perez@example.com', '8887776662', 0, 'Mia Perez', 'avatar71.png', 20241210, 20241210, 2),
(72, 'jackson_kelly', 'jacksonpass', 'jackson.kelly@example.com', '7776665551', 1, 'Jackson Kelly', 'avatar72.png', 20241211, 20241211, 1),
(73, 'scarlett_davis', 'scarlettpass', 'scarlett.davis@example.com', '6665554440', 0, 'Scarlett Davis', 'avatar73.png', 20241212, 20241212, 2),
(74, 'gabriel_morgan', 'gabrielpass', 'gabriel.morgan@example.com', '5554443329', 1, 'Gabriel Morgan', 'avatar74.png', 20241213, 20241213, 1),
(75, 'zoey_foster', 'zoeypass', 'zoey.foster@example.com', '4443332228', 0, 'Zoey Foster', 'avatar75.png', 20241214, 20241214, 2),
(76, 'aaron_bennett', 'aaronpass', 'aaron.bennett@example.com', '3332221117', 1, 'Aaron Bennett', 'avatar76.png', 20241215, 20241215, 1),
(77, 'layla_griffin', 'laylapass', 'layla.griffin@example.com', '2221110006', 0, 'Layla Griffin', 'avatar77.png', 20241216, 20241216, 2),
(78, 'joshua_sanders', 'joshuapass', 'joshua.sanders@example.com', '1110009994', 1, 'Joshua Sanders', 'avatar78.png', 20241217, 20241217, 1),
(79, 'hannah_fisher', 'hannahpass', 'hannah.fisher@example.com', '9998887772', 0, 'Hannah Fisher', 'avatar79.png', 20241218, 20241218, 2),
(80, 'samuel_reed', 'samuelpass', 'samuel.reed@example.com', '8887776661', 1, 'Samuel Reed', 'avatar80.png', 20241219, 20241219, 1),
(81, 'bella_hayes', 'bellapass', 'bella.hayes@example.com', '7776665550', 0, 'Bella Hayes', 'avatar81.png', 20241220, 20241220, 2);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(82, 'logan_bryant', 'loganpass', 'logan.bryant@example.com', '6665554439', 1, 'Logan Bryant', 'avatar82.png', 20241221, 20241221, 1),
(83, 'nora_mitchell', 'norapass', 'nora.mitchell@example.com', '5554443328', 0, 'Nora Mitchell', 'avatar83.png', 20241222, 20241222, 2),
(84, 'lucas_brooks', 'lucaspass', 'lucas.brooks@example.com', '4443332217', 1, 'Lucas Brooks', 'avatar84.png', 20241223, 20241223, 1),
(85, 'lily_powell', 'lilypass', 'lily.powell@example.com', '3332221106', 0, 'Lily Powell', 'avatar85.png', 20241224, 20241224, 2),
(86, 'julian_long', 'julianpass', 'julian.long@example.com', '2221110095', 1, 'Julian Long', 'avatar86.png', 20241225, 20241225, 1),
(87, 'ellie_barnes', 'elliepass', 'ellie.barnes@example.com', '1110009984', 0, 'Ellie Barnes', 'avatar87.png', 20241226, 20241226, 2),
(88, 'sebastian_wright', 'sebastianpass', 'sebastian.wright@example.com', '9998887763', 1, 'Sebastian Wright', 'avatar88.png', 20241227, 20241227, 1),
(89, 'sofia_clark', 'sofiapass', 'sofia.clark@example.com', '8887776652', 0, 'Sofia Clark', 'avatar89.png', 20241228, 20241228, 2),
(90, 'david_king', 'davidpass', 'david.king@example.com', '7776665541', 1, 'David King', 'avatar90.png', 20241229, 20241229, 1),
(91, 'hazel_evans', 'hazelpass', 'hazel.evans@example.com', '6665554430', 0, 'Hazel Evans', 'avatar91.png', 20241230, 20241230, 2),
(92, 'isaac_hill', 'isaacpass', 'isaac.hill@example.com', '5554443319', 1, 'Isaac Hill', 'avatar92.png', 20241231, 20241231, 1),
(93, 'madison_green', 'madisonpass', 'madison.green@example.com', '4443332208', 0, 'Madison Green', 'avatar93.png', 20250101, 20250101, 2),
(94, 'andrew_adams', 'andrewpass', 'andrew.adams@example.com', '3332221097', 1, 'Andrew Adams', 'avatar94.png', 20250102, 20250102, 1),
(95, 'grace_morris', 'gracepass', 'grace.morris@example.com', '2221110086', 0, 'Grace Morris', 'avatar95.png', 20250103, 20250103, 2),
(96, 'owen_patterson', 'owenpass', 'owen.patterson@example.com', '1110009975', 1, 'Owen Patterson', 'avatar96.png', 20250104, 20250104, 1),
(97, 'aria_bailey', 'ariapass', 'aria.bailey@example.com', '9998887754', 0, 'Aria Bailey', 'avatar97.png', 20250105, 20250105, 2),
(98, 'liam_ward', 'liampass', 'liam.ward@example.com', '8887776643', 1, 'Liam Ward', 'avatar98.png', 20250106, 20250106, 1),
(99, 'zoe_robinson', 'zoepass', 'zoe.robinson@example.com', '7776665532', 0, 'Zoe Robinson', 'avatar99.png', 20250107, 20250107, 2),
(100, 'elijah_reed', 'elijahpass', 'elijah.reed@example.com', '6665554421', 1, 'Elijah Reed', 'avatar100.png', 20250108, 20250108, 1),
(101, 'hannah_walker', 'hannahpass', 'hannah.walker@example.com', '5554443302', 0, 'Hannah Walker', 'avatar101.png', 20250109, 20250109, 2);
	
INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(102, 'ella_foster', 'ellapass', 'ella.foster@example.com', '4443332216', 0, 'Ella Foster', 'avatar102.png', 20250110, 20250110, 2),
(103, 'jackson_stevens', 'jacksonpass', 'jackson.stevens@example.com', '3332221105', 1, 'Jackson Stevens', 'avatar103.png', 20250111, 20250111, 1),
(104, 'lucy_king', 'lucypass', 'lucy.king@example.com', '2221110094', 0, 'Lucy King', 'avatar104.png', 20250112, 20250112, 2),
(105, 'ethan_james', 'ethanpass', 'ethan.james@example.com', '1110009983', 1, 'Ethan James', 'avatar105.png', 20250113, 20250113, 1),
(106, 'mia_lee', 'miapass', 'mia.lee@example.com', '9998887762', 0, 'Mia Lee', 'avatar106.png', 20250114, 20250114, 2),
(107, 'benjamin_clark', 'benjaminpass', 'benjamin.clark@example.com', '8887776651', 1, 'Benjamin Clark', 'avatar107.png', 20250115, 20250115, 1),
(108, 'lucas_smith', 'lucassmithpass', 'lucas.smith@example.com', '7776665530', 1, 'Lucas Smith', 'avatar108.png', 20250116, 20250116, 1),
(109, 'sofia_martinez', 'sofiamartinezpass', 'sofia.martinez@example.com', '6665554419', 0, 'Sofia Martinez', 'avatar109.png', 20250117, 20250117, 2),
(110, 'nathan_davis', 'nathanpass', 'nathan.davis@example.com', '5554443301', 1, 'Nathan Davis', 'avatar110.png', 20250118, 20250118, 1),
(111, 'ava_thompson', 'avathompsonpass', 'ava.thompson@example.com', '4443332207', 0, 'Ava Thompson', 'avatar111.png', 20250119, 20250119, 2),
(112, 'william_johnson', 'williamjohnsonpass', 'william.johnson@example.com', '3332221096', 1, 'William Johnson', 'avatar112.png', 20250120, 20250120, 1),
(113, 'isabella_jones', 'isabellapass', 'isabella.jones@example.com', '2221110085', 0, 'Isabella Jones', 'avatar113.png', 20250121, 20250121, 2),
(114, 'sebastian_taylor', 'sebastianpass', 'sebastian.taylor@example.com', '1110009974', 1, 'Sebastian Taylor', 'avatar114.png', 20250122, 20250122, 1),
(115, 'lily_harris', 'lilyharrispass', 'lily.harris@example.com', '9998887753', 0, 'Lily Harris', 'avatar115.png', 20250123, 20250123, 2),
(116, 'andrew_martin', 'andrewmartinpass', 'andrew.martin@example.com', '8887776642', 1, 'Andrew Martin', 'avatar116.png', 20250124, 20250124, 1),
(117, 'zoe_perez', 'zoeperezpass', 'zoe.perez@example.com', '7776665529', 0, 'Zoe Perez', 'avatar117.png', 20250125, 20250125, 2),
(118, 'owen_white', 'owenwhitepass', 'owen.white@example.com', '6665554418', 1, 'Owen White', 'avatar118.png', 20250126, 20250126, 1),
(119, 'ella_davis', 'elladavispass', 'ella.davis@example.com', '5554443299', 0, 'Ella Davis', 'avatar119.png', 20250127, 20250127, 2),
(120, 'luca_rodriquez', 'lucapass', 'luca.rodriquez@example.com', '4443332206', 1, 'Luca Rodriquez', 'avatar120.png', 20250128, 20250128, 1);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(121, 'madison_jackson', 'madisonpass', 'madison.jackson@example.com', '3332221095', 0, 'Madison Jackson', 'avatar121.png', 20250129, 20250129, 2),
(122, 'jackson_lee', 'jacksonlee123', 'jackson.lee@example.com', '2221110074', 1, 'Jackson Lee', 'avatar122.png', 20250130, 20250130, 1),
(123, 'lucy_brown', 'lucybrown123', 'lucy.brown@example.com', '1110009963', 0, 'Lucy Brown', 'avatar123.png', 20250131, 20250131, 2),
(124, 'elijah_white', 'elijahpass', 'elijah.white@example.com', '9998887744', 1, 'Elijah White', 'avatar124.png', 20250201, 20250201, 1),
(125, 'olivia_martin', 'oliviamartin123', 'olivia.martin@example.com', '8887776633', 0, 'Olivia Martin', 'avatar125.png', 20250202, 20250202, 2),
(126, 'joseph_williams', 'josephwilliamspass', 'joseph.williams@example.com', '7776665517', 1, 'Joseph Williams', 'avatar126.png', 20250203, 20250203, 1),
(127, 'emily_smith', 'emilysmith123', 'emily.smith@example.com', '6665554407', 0, 'Emily Smith', 'avatar127.png', 20250204, 20250204, 2),
(128, 'michael_taylor', 'michaelpass', 'michael.taylor@example.com', '5554443288', 1, 'Michael Taylor', 'avatar128.png', 20250205, 20250205, 1),
(129, 'isabella_johnson', 'isabellajohnsonpass', 'isabella.johnson@example.com', '4443332195', 0, 'Isabella Johnson', 'avatar129.png', 20250206, 20250206, 2),
(130, 'caleb_harris', 'calebharris123', 'caleb.harris@example.com', '3332221087', 1, 'Caleb Harris', 'avatar130.png', 20250207, 20250207, 1),
(131, 'ava_jones', 'avajonespass', 'ava.jones@example.com', '2221110063', 0, 'Ava Jones', 'avatar131.png', 20250208, 20250208, 2),
(132, 'jack_wilson', 'jackwilsonpass', 'jack.wilson@example.com', '1110009952', 1, 'Jack Wilson', 'avatar132.png', 20250209, 20250209, 1),
(133, 'oliver_king', 'oliverking123', 'oliver.king@example.com', '9998887733', 1, 'Oliver King', 'avatar133.png', 20250210, 20250210, 1),
(134, 'mia_taylor', 'miataylorpass', 'mia.taylor@example.com', '8887776624', 0, 'Mia Taylor', 'avatar134.png', 20250211, 20250211, 2),
(135, 'nathan_rodriquez', 'nathanpass', 'nathan.rodriquez@example.com', '7776665508', 1, 'Nathan Rodriquez', 'avatar135.png', 20250212, 20250212, 1),
(136, 'emily_williams', 'emilywilliamspass', 'emily.williams@example.com', '6665554396', 0, 'Emily Williams', 'avatar136.png', 20250213, 20250213, 2),
(137, 'hannah_smith', 'hannahsmith123', 'hannah.smith@example.com', '5554443277', 0, 'Hannah Smith', 'avatar137.png', 20250214, 20250214, 2),
(138, 'benjamin_davis', 'benjamindavispass', 'benjamin.davis@example.com', '4443332186', 1, 'Benjamin Davis', 'avatar138.png', 20250215, 20250215, 1),
(139, 'olivia_rodriquez', 'oliviarodriquezpass', 'olivia.rodriquez@example.com', '3332221076', 0, 'Olivia Rodriquez', 'avatar139.png', 20250216, 20250216, 2),
(140, 'lucas_white', 'lucaswhitepass', 'lucas.white@example.com', '2221110052', 1, 'Lucas White', 'avatar140.png', 20250217, 20250217, 1);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(141, 'emma_brown', 'emmataylorpass', 'emma.brown@example.com', '1110009941', 0, 'Emma Brown', 'avatar141.png', 20250218, 20250218, 2),
(142, 'henry_green', 'henrygreen123', 'henry.green@example.com', '9998887722', 1, 'Henry Green', 'avatar142.png', 20250219, 20250219, 1),
(143, 'lucy_moore', 'lucymoorepass', 'lucy.moore@example.com', '8887776615', 0, 'Lucy Moore', 'avatar143.png', 20250220, 20250220, 2),
(144, 'liam_king', 'liamkingpass', 'liam.king@example.com', '7776665499', 1, 'Liam King', 'avatar144.png', 20250221, 20250221, 1),
(145, 'sofia_lee', 'sofialee123', 'sofia.lee@example.com', '6665554385', 0, 'Sofia Lee', 'avatar145.png', 20250222, 20250222, 2),
(146, 'jackson_walker', 'jacksonwalkerpass', 'jackson.walker@example.com', '5554443260', 1, 'Jackson Walker', 'avatar146.png', 20250223, 20250223, 1),
(147, 'grace_johnson', 'gracejohnson123', 'grace.johnson@example.com', '4443332174', 0, 'Grace Johnson', 'avatar147.png', 20250224, 20250224, 2),
(148, 'logan_evans', 'loganevans123', 'logan.evans@example.com', '3332221064', 1, 'Logan Evans', 'avatar148.png', 20250225, 20250225, 1),
(149, 'zoe_martinez', 'zoemartinezpass', 'zoe.martinez@example.com', '2221110041', 0, 'Zoe Martinez', 'avatar149.png', 20250226, 20250226, 2),
(150, 'noah_garcia', 'noahgarciapass', 'noah.garcia@example.com', '1110009930', 1, 'Noah Garcia', 'avatar150.png', 20250227, 20250227, 1),
(151, 'aiden_harris', 'aidenharris123', 'aiden.harris@example.com', '9998887711', 1, 'Aiden Harris', 'avatar151.png', 20250228, 20250228, 1),
(152, 'mason_hernandez', 'masonhernandezpass', 'mason.hernandez@example.com', '8887776600', 1, 'Mason Hernandez', 'avatar152.png', 20250301, 20250301, 1),
(153, 'amelia_wilson', 'ameliawilson123', 'amelia.wilson@example.com', '7776665483', 0, 'Amelia Wilson', 'avatar153.png', 20250302, 20250302, 2),
(154, 'jacob_davis', 'jacobdavispass', 'jacob.davis@example.com', '6665554373', 1, 'Jacob Davis', 'avatar154.png', 20250303, 20250303, 1),
(155, 'elizabeth_taylor', 'elizabethtaylor123', 'elizabeth.taylor@example.com', '5554443251', 0, 'Elizabeth Taylor', 'avatar155.png', 20250304, 20250304, 2),
(156, 'james_martin', 'jamesmartinpass', 'james.martin@example.com', '4443332162', 1, 'James Martin', 'avatar156.png', 20250305, 20250305, 1),
(157, 'ava_clark', 'avaclarkpass', 'ava.clark@example.com', '3332221055', 0, 'Ava Clark', 'avatar157.png', 20250306, 20250306, 2),
(158, 'daniel_white', 'danielwhitepass', 'daniel.white@example.com', '2221110033', 1, 'Daniel White', 'avatar158.png', 20250307, 20250307, 1),
(159, 'elena_williams', 'elenawilliams123', 'elena.williams@example.com', '1110009919', 0, 'Elena Williams', 'avatar159.png', 20250308, 20250308, 2),
(160, 'jackson_taylor', 'jacksontaylorpass', 'jackson.taylor@example.com', '9998887700', 1, 'Jackson Taylor', 'avatar160.png', 20250309, 20250309, 1);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(161, 'madison_james', 'madisonjames123', 'madison.james@example.com', '8887776601', 0, 'Madison James', 'avatar161.png', 20250310, 20250310, 2),
(162, 'elijah_king', 'elijahkingpass', 'elijah.king@example.com', '7776665471', 1, 'Elijah King', 'avatar162.png', 20250311, 20250311, 1),
(163, 'charlotte_morris', 'charlottemorris123', 'charlotte.morris@example.com', '6665554362', 0, 'Charlotte Morris', 'avatar163.png', 20250312, 20250312, 2),
(164, 'lucas_walker', 'lucaswalkerpass', 'lucas.walker@example.com', '5554443242', 1, 'Lucas Walker', 'avatar164.png', 20250313, 20250313, 1),
(165, 'ella_hall', 'ellahallpass', 'ella.hall@example.com', '4443332153', 0, 'Ella Hall', 'avatar165.png', 20250314, 20250314, 2),
(166, 'logan_hill', 'loganhill123', 'logan.hill@example.com', '3332221046', 1, 'Logan Hill', 'avatar166.png', 20250315, 20250315, 1),
(167, 'mia_lopez', 'mialopezpass', 'mia.lopez@example.com', '2221110024', 0, 'Mia Lopez', 'avatar167.png', 20250316, 20250316, 2),
(168, 'ethan_garcia', 'ethangarcia123', 'ethan.garcia@example.com', '1110009902', 1, 'Ethan Garcia', 'avatar168.png', 20250317, 20250317, 1),
(169, 'chloe_roberts', 'chloeroberts123', 'chloe.roberts@example.com', '9998887688', 0, 'Chloe Roberts', 'avatar169.png', 20250318, 20250318, 2),
(170, 'alex_miller', 'alexmillerpass', 'alex.miller@example.com', '8887776593', 1, 'Alex Miller', 'avatar170.png', 20250319, 20250319, 1),
(171, 'willow_davis', 'willowdavispass', 'willow.davis@example.com', '7776665462', 0, 'Willow Davis', 'avatar171.png', 20250320, 20250320, 2),
(172, 'joseph_wilson', 'josephwilson123', 'joseph.wilson@example.com', '6665554353', 1, 'Joseph Wilson', 'avatar172.png', 20250321, 20250321, 1),
(173, 'sophie_lee', 'sophielee123', 'sophie.lee@example.com', '5554443233', 0, 'Sophie Lee', 'avatar173.png', 20250322, 20250322, 2),
(174, 'henry_johnson', 'henryjohnsonpass', 'henry.johnson@example.com', '4443332144', 1, 'Henry Johnson', 'avatar174.png', 20250323, 20250323, 1),
(175, 'grace_martin', 'gracemartin123', 'grace.martin@example.com', '3332221037', 0, 'Grace Martin', 'avatar175.png', 20250324, 20250324, 2),
(176, 'benjamin_wilson', 'benjaminwilson123', 'benjamin.wilson@example.com', '2221110015', 1, 'Benjamin Wilson', 'avatar176.png', 20250325, 20250325, 1),
(177, 'isabella_brown', 'isabellabrownpass', 'isabella.brown@example.com', '1110009893', 0, 'Isabella Brown', 'avatar177.png', 20250326, 20250326, 2),
(178, 'lucas_white', 'lucaswhitepass', 'lucas.white@example.com', '9998887679', 1, 'Lucas White', 'avatar178.png', 20250327, 20250327, 1),
(179, 'chloe_taylor', 'chloetaylor123', 'chloe.taylor@example.com', '8887776584', 0, 'Chloe Taylor', 'avatar179.png', 20250328, 20250328, 2),
(180, 'oliver_brown', 'oliverbrownpass', 'oliver.brown@example.com', '7776665453', 1, 'Oliver Brown', 'avatar180.png', 20250329, 20250329, 1);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(181, 'ella_wilson', 'ellawilson123', 'ella.wilson@example.com', '6665554344', 0, 'Ella Wilson', 'avatar181.png', 20250330, 20250330, 2),
(182, 'jack_brown', 'jackbrown123', 'jack.brown@example.com', '5554443224', 1, 'Jack Brown', 'avatar182.png', 20250331, 20250331, 1),
(183, 'aiden_clark', 'aidenclark123', 'aiden.clark@example.com', '4443332135', 1, 'Aiden Clark', 'avatar183.png', 20250401, 20250401, 1),
(184, 'mia_johnson', 'miajohnsonpass', 'mia.johnson@example.com', '3332221028', 0, 'Mia Johnson', 'avatar184.png', 20250402, 20250402, 2),
(185, 'ethan_martin', 'ethanmartin123', 'ethan.martin@example.com', '2221110006', 1, 'Ethan Martin', 'avatar185.png', 20250403, 20250403, 1),
(186, 'chloe_smith', 'chloesmith123', 'chloe.smith@example.com', '1110009882', 0, 'Chloe Smith', 'avatar186.png', 20250404, 20250404, 2),
(187, 'lucas_davis', 'lucasdavispass', 'lucas.davis@example.com', '9998887661', 1, 'Lucas Davis', 'avatar187.png', 20250405, 20250405, 1),
(188, 'grace_brown', 'gracebrownpass', 'grace.brown@example.com', '8887776575', 0, 'Grace Brown', 'avatar188.png', 20250406, 20250406, 2),
(189, 'benjamin_roberts', 'benjaminroberts123', 'benjamin.roberts@example.com', '7776665444', 1, 'Benjamin Roberts', 'avatar189.png', 20250407, 20250407, 1),
(190, 'isabella_wilson', 'isabellawilsonpass', 'isabella.wilson@example.com', '6665554335', 0, 'Isabella Wilson', 'avatar190.png', 20250408, 20250408, 2),
(191, 'oliver_martin', 'olivermartin123', 'oliver.martin@example.com', '5554443213', 1, 'Oliver Martin', 'avatar191.png', 20250409, 20250409, 1),
(192, 'ella_jones', 'ellajonespass', 'ella.jones@example.com', '4443332126', 0, 'Ella Jones', 'avatar192.png', 20250410, 20250410, 2),
(193, 'jack_smith', 'jacksmith123', 'jack.smith@example.com', '3332221017', 1, 'Jack Smith', 'avatar193.png', 20250411, 20250411, 1);

INSERT INTO Users (user_id, user_name, password, email, phone_number, gender, full_name, avatar, created_at, updated_at, role)
VALUES
(194, 'lucas_williams', 'lucaswilliams123', 'lucas.williams@example.com', '2221110998', 1, 'Lucas Williams', 'avatar194.png', 20250412, 20250412, 1),
(195, 'grace_johnson', 'gracejohnsonpass', 'grace.johnson@example.com', '1110009875', 0, 'Grace Johnson', 'avatar195.png', 20250413, 20250413, 2),
(196, 'aiden_taylor', 'aidentaylor123', 'aiden.taylor@example.com', '9998887654', 1, 'Aiden Taylor', 'avatar196.png', 20250414, 20250414, 1),
(197, 'ella_martin', 'ellamartinpass', 'ella.martin@example.com', '8887776543', 0, 'Ella Martin', 'avatar197.png', 20250415, 20250415, 2),
(198, 'lucas_thompson', 'lucasthompson123', 'lucas.thompson@example.com', '7776665432', 1, 'Lucas Thompson', 'avatar198.png', 20250416, 20250416, 1),
(199, 'mia_roberts', 'miaroberts123', 'mia.roberts@example.com', '6665554321', 0, 'Mia Roberts', 'avatar199.png', 20250417, 20250417, 2),
(200, 'benjamin_wilson', 'benjaminwilson123', 'benjamin.wilson@example.com', '5554443210', 1, 'Benjamin Wilson', 'avatar200.png', 20250418, 20250418, 1),
(201, 'isabella_davis', 'isabelladavis123', 'isabella.davis@example.com', '4443332109', 0, 'Isabella Davis', 'avatar201.png', 20250419, 20250419, 2);

INSERT INTO Reviews (review_id, rate, comment, created_at, updated_at, homestay_id, user_id)
VALUES 
-- Reviews for Homestay Hanoi CITY
(16, 5, 'The best homestay in Hanoi!', 20241201, 20241201, 1, 16),
(17, 4, 'Comfortable and clean.', 20241202, 20241202, 1, 17),
(18, 3, 'Good but a bit noisy.', 20241203, 20241203, 1, 18),
(19, 5, 'Perfect for a weekend trip.', 20241204, 20241204, 1, 19),
(20, 4, 'Very friendly hosts.', 20241205, 20241205, 1, 20),
(21, 2, 'Needs better maintenance.', 20241206, 20241206, 1, 21),

-- Reviews for Saigon Riverside Homestay
(22, 5, 'Stunning view of the river!', 20241201, 20241201, 2, 22),
(23, 4, 'Excellent location, decent service.', 20241202, 20241202, 2, 23),
(24, 3, 'Good value for money.', 20241203, 20241203, 2, 24),
(25, 4, 'Relaxing and peaceful.', 20241204, 20241204, 2, 25),
(26, 5, 'Highly recommend this place.', 20241205, 20241205, 2, 26),
(27, 1, 'Had some issues with cleanliness.', 20241206, 20241206, 2, 27),

-- Reviews for Homestay Da Nang Beach
(28, 5, 'Amazing beach access!', 20241201, 20241201, 3, 28),
(29, 4, 'Good service, great location.', 20241202, 20241202, 3, 29),
(30, 3, 'Average experience.', 20241203, 20241203, 3, 30),
(31, 5, 'Loved the relaxing vibe.', 20241204, 20241204, 3, 31),
(32, 4, 'Would stay here again.', 20241205, 20241205, 3, 32),
(33, 2, 'Expected more for the price.', 20241206, 20241206, 3, 33),

-- Reviews for Ninh Binh Nature Homestay
(34, 5, 'Breathtaking views!', 20241201, 20241201, 4, 34),
(35, 4, 'Very close to nature.', 20241202, 20241202, 4, 35),
(36, 3, 'Good but lacks amenities.', 20241203, 20241203, 4, 36),
(37, 5, 'Best stay in Ninh Binh.', 20241204, 20241204, 4, 37),
(38, 4, 'Friendly staff and clean.', 20241205, 20241205, 4, 38),
(39, 2, 'Could improve the rooms.', 20241206, 20241206, 4, 39),

-- Reviews for Sapa Mountain Homestay
(40, 5, 'Stunning mountain view!', 20241201, 20241201, 5, 40),
(41, 4, 'Cozy and peaceful.', 20241202, 20241202, 5, 41),
(42, 3, 'A bit hard to reach.', 20241203, 20241203, 5, 42),
(43, 5, 'Perfect for nature lovers.', 20241204, 20241204, 5, 43),
(44, 4, 'Highly recommend for hiking.', 20241205, 20241205, 5, 44),
(45, 1, 'Not worth the price.', 20241206, 20241206, 5, 45);

-- testtttttt
INSERT INTO Reviews (review_id, rate, comment, created_at, updated_at, homestay_id, user_id)
VALUES 
-- Reviews for Hue Imperial Homestay
(46, 5, 'Amazing experience near the imperial city.', 20241201, 20241201, 6, 46),
(47, 4, 'Beautifully decorated rooms.', 20241202, 20241202, 6, 47),
(48, 3, 'Decent stay, but could be cleaner.', 20241203, 20241203, 6, 48),
(49, 5, 'Great location and service.', 20241204, 20241204, 6, 49),
(50, 4, 'Lovely ambiance and friendly staff.', 20241205, 20241205, 6, 50),
(51, 2, 'Expected better maintenance.', 20241206, 20241206, 6, 51),

-- Reviews for Hoi An Riverside Homestay
(52, 5, 'Wonderful riverside stay!', 20241201, 20241201, 7, 52),
(53, 4, 'Charming and peaceful.', 20241202, 20241202, 7, 53),
(54, 3, 'Good location, average facilities.', 20241203, 20241203, 7, 54),
(55, 5, 'Perfect getaway in Hoi An.', 20241204, 20241204, 7, 55),
(56, 4, 'Very relaxing and enjoyable.', 20241205, 20241205, 7, 56),
(57, 1, 'Too many bugs in the room.', 20241206, 20241206, 7, 57),

-- Reviews for Phu Quoc Paradise Homestay
(58, 5, 'Amazing tropical retreat.', 20241201, 20241201, 8, 58),
(59, 4, 'Lovely place to unwind.', 20241202, 20241202, 8, 59),
(60, 3, 'Average stay, but good location.', 20241203, 20241203, 8, 60),
(61, 5, 'Best experience in Phu Quoc!', 20241204, 20241204, 8, 61),
(62, 4, 'Highly recommend this homestay.', 20241205, 20241205, 8, 62),
(63, 2, 'Too expensive for what it offers.', 20241206, 20241206, 8, 63),

-- Reviews for Can Tho Eco Homestay
(64, 5, 'Eco-friendly and relaxing.', 20241201, 20241201, 9, 64),
(65, 4, 'Great place for nature lovers.', 20241202, 20241202, 9, 65),
(66, 3, 'Good but could be better maintained.', 20241203, 20241203, 9, 66),
(67, 5, 'Perfect stay in the Mekong Delta.', 20241204, 20241204, 9, 67),
(68, 4, 'Lovely hosts and clean rooms.', 20241205, 20241205, 9, 68),
(69, 1, 'Disappointed with the facilities.', 20241206, 20241206, 9, 69),

-- Reviews for Da Lat Flower Homestay
(70, 5, 'Beautiful surroundings with flowers everywhere.', 20241201, 20241201, 10, 70),
(71, 4, 'Great service and cozy rooms.', 20241202, 20241202, 10, 71),
(72, 3, 'Good stay but a bit overpriced.', 20241203, 20241203, 10, 72),
(73, 5, 'Perfect for a romantic getaway.', 20241204, 20241204, 10, 73),
(74, 4, 'Friendly staff and peaceful environment.', 20241205, 20241205, 10, 74),
(75, 2, 'Expected better facilities.', 20241206, 20241206, 10, 75),
-- Reviews for Ha Giang Loop Homestay
(76, 5, 'Scenic and peaceful.', 20241201, 20241201, 11, 76),
(77, 4, 'Great place to explore Ha Giang.', 20241202, 20241202, 11, 77),
(78, 3, 'Decent stay, average service.', 20241203, 20241203, 11, 78),
(79, 5, 'Loved the mountain views.', 20241204, 20241204, 11, 79),
(80, 4, 'Friendly hosts and clean rooms.', 20241205, 20241205, 11, 80),
(81, 2, 'Too noisy, needs improvement.', 20241206, 20241206, 11, 81),

-- Reviews for Vung Tau Coastal Homestay
(82, 5, 'Fantastic sea view!', 20241201, 20241201, 12, 82),
(83, 4, 'Relaxing and comfortable.', 20241202, 20241202, 12, 83),
(84, 3, 'Good location, average amenities.', 20241203, 20241203, 12, 84),
(85, 5, 'Perfect for a beach holiday.', 20241204, 20241204, 12, 85),
(86, 4, 'Highly recommend this place.', 20241205, 20241205, 12, 86),
(87, 1, 'Overpriced for what it offers.', 20241206, 20241206, 12, 87),

-- Reviews for Con Dao Hideaway Homestay
(88, 5, 'Hidden gem on the island.', 20241201, 20241201, 13, 88),
(89, 4, 'Beautiful and peaceful retreat.', 20241202, 20241202, 13, 89),
(90, 3, 'Decent stay, but limited amenities.', 20241203, 20241203, 13, 90),
(91, 5, 'Amazing experience on Con Dao!', 20241204, 20241204, 13, 91),
(92, 4, 'Very cozy and comfortable.', 20241205, 20241205, 13, 92),
(93, 2, 'Expected better for the price.', 20241206, 20241206, 13, 93),

-- Reviews for Bac Ninh Heritage Homestay
(94, 5, 'Traditional and cozy.', 20241201, 20241201, 14, 94),
(95, 4, 'Good value for money.', 20241202, 20241202, 14, 95),
(96, 3, 'Decent stay but a bit old-fashioned.', 20241203, 20241203, 14, 96),
(97, 5, 'Amazing cultural experience.', 20241204, 20241204, 14, 97),
(98, 4, 'Lovely hosts and nice location.', 20241205, 20241205, 14, 98),
(99, 1, 'Facilities need improvement.', 20241206, 20241206, 14, 99),

-- Reviews for Sapa Mountain Homestay (Duplicate entry for another homestay with the same name)
(100, 5, 'Fantastic retreat with great views.', 20241201, 20241201, 20, 100),
(101, 4, 'Comfortable and clean.', 20241202, 20241202, 20, 101),
(102, 3, 'Good but could be better.', 20241203, 20241203, 20, 102),
(103, 5, 'Loved the mountain vibes.', 20241204, 20241204, 20, 103),
(104, 4, 'Highly recommend for nature lovers.', 20241205, 20241205, 20, 104),
(105, 2, 'A bit overpriced.', 20241206, 20241206, 20, 105),

-- Reviews for Hanoi Old Quarter Homestay
(106, 5, 'Perfect location in the Old Quarter.', 20241201, 20241201, 21, 106),
(107, 4, 'Cozy and convenient.', 20241202, 20241202, 21, 107),
(108, 3, 'Good stay, but noisy at night.', 20241203, 20241203, 21, 108),
(109, 5, 'Loved the traditional vibe.', 20241204, 20241204, 21, 109),
(110, 4, 'Very friendly staff.', 20241205, 20241205, 21, 110),
(111, 2, 'Could improve cleanliness.', 20241206, 20241206, 21, 111),

-- Reviews for Danang Beach Homestay
(112, 5, 'Great place near the beach!', 20241201, 20241201, 22, 112),
(113, 4, 'Very comfortable and clean.', 20241202, 20241202, 22, 113),
(114, 3, 'Average stay, good location.', 20241203, 20241203, 22, 114),
(115, 5, 'Perfect for a beach holiday.', 20241204, 20241204, 22, 115),
(116, 4, 'Lovely hosts and good amenities.', 20241205, 20241205, 22, 116),
(117, 1, 'Not worth the price.', 20241206, 20241206, 22, 117),

-- Reviews for Saigon Central Homestay
(118, 5, 'Luxury stay in the heart of the city.', 20241201, 20241201, 23, 118),
(119, 4, 'Modern and comfortable.', 20241202, 20241202, 23, 119),
(120, 3, 'Decent stay but noisy.', 20241203, 20241203, 23, 120),
(121, 5, 'Excellent location and service.', 20241204, 20241204, 23, 121),
(122, 4, 'Very clean and spacious.', 20241205, 20241205, 23, 122),
(123, 2, 'Overpriced for the amenities.', 20241206, 20241206, 23, 123),

-- Reviews for Quy Nhon Blue Sea Homestay
(124, 5, 'Peaceful with great sea views.', 20241201, 20241201, 24, 124),
(125, 4, 'Lovely ambiance, near the sea.', 20241202, 20241202, 24, 125),
(126, 3, 'Average stay, nice staff.', 20241203, 20241203, 24, 126),
(127, 5, 'Perfect getaway spot.', 20241204, 20241204, 24, 127),
(128, 4, 'Highly recommend for families.', 20241205, 20241205, 24, 128),
(129, 2, 'Needs better maintenance.', 20241206, 20241206, 24, 129),

-- Reviews for Phong Nha Scenic Homestay
(130, 5, 'Amazing views of the natural heritage.', 20241201, 20241201, 25, 130),
(131, 4, 'Great location for nature lovers.', 20241202, 20241202, 25, 131),
(132, 3, 'Decent stay but basic facilities.', 20241203, 20241203, 25, 132),
(133, 5, 'Perfect for exploring caves.', 20241204, 20241204, 25, 133),
(134, 4, 'Very friendly and helpful hosts.', 20241205, 20241205, 25, 134),
(135, 1, 'Not as expected, needs improvement.', 20241206, 20241206, 25, 135),

-- Reviews for Can Tho Mekong Homestay
(136, 5, 'Peaceful stay by the Mekong River.', 20241201, 20241201, 26, 136),
(137, 4, 'Lovely and relaxing atmosphere.', 20241202, 20241202, 26, 137),
(138, 3, 'Good stay but could improve cleanliness.', 20241203, 20241203, 26, 138),
(139, 5, 'Perfect for a relaxing holiday.', 20241204, 20241204, 26, 139),
(140, 4, 'Great hosts and nice location.', 20241205, 20241205, 26, 140),
(141, 2, 'Too expensive for the facilities.', 20241206, 20241206, 26,141),

-- Reviews for Da Lat Flower Hill Homestay
(142, 5, 'Surrounded by beautiful flower hills.', 20241201, 20241201, 27, 142),
(143, 4, 'Cozy and charming place.', 20241202, 20241202, 27, 143),
(144, 3, 'Good for short stays.', 20241203, 20241203, 27, 144),
(145, 5, 'Perfect for a nature retreat.', 20241204, 20241204, 27, 145),
(146, 4, 'Very welcoming and peaceful.', 20241205, 20241205, 27, 146),
(147, 2, 'Could improve cleanliness.', 20241206, 20241206, 27,147),

-- Reviews for Hoi An Countryside Homestay
(148, 5, 'Peaceful stay in the countryside.', 20241201, 20241201, 28, 148),
(149, 4, 'Charming and quiet.', 20241202, 20241202, 28, 149),
(150, 3, 'Good stay but a bit far from the city.', 20241203, 20241203, 28, 150),
(151, 5, 'Perfect getaway in Hoi An.', 20241204, 20241204, 28, 151),
(152, 4, 'Very relaxing and enjoyable.', 20241205, 20241205, 28, 152),
(153, 1, 'Too many bugs in the room.', 20241206, 20241206, 28,153),

-- Reviews for Hue Imperial Homestay
(154, 5, 'Beautiful homestay near the Imperial City.', 20241201, 20241201, 29, 154),
(155, 4, 'Cozy and elegant atmosphere.', 20241202, 20241202, 29, 155),
(156, 3, 'Good but not exceptional.', 20241203, 20241203, 29, 156),
(157, 5, 'Perfect for history lovers.', 20241204, 20241204, 29, 157),
(158, 4, 'Friendly staff and great location.', 20241205, 20241205, 29, 158),
(159, 2, 'Needs better facilities.', 20241206, 20241206, 29,159),

-- Reviews for Ha Long Bay Homestay
(160, 5, 'Stunning views of Ha Long Bay.', 20241201, 20241201, 30, 160),
(161, 4, 'Comfortable stay with amazing scenery.', 20241202, 20241202, 30, 161),
(162, 3, 'Good stay but slightly overpriced.', 20241203, 20241203, 30, 162),
(163, 5, 'Perfect for exploring Ha Long.', 20241204, 20241204, 30, 163),
(164, 4, 'Lovely and peaceful atmosphere.', 20241205, 20241205, 30, 164),
(165, 1, 'Not as described, disappointing.', 20241206, 20241206, 30,165),

-- Reviews for Tay Ninh Mountain Homestay
(166, 5, 'Beautiful views of Ba Den Mountain.', 20241201, 20241201, 31, 166),
(167, 4, 'Cozy stay near the tourist area.', 20241202, 20241202, 31, 167),
(168, 3, 'Good but could be cleaner.', 20241203, 20241203, 31, 168),
(169, 5, 'Perfect for mountain lovers.', 20241204, 20241204, 31, 169),
(170, 4, 'Relaxing and enjoyable stay.', 20241205, 20241205, 31, 170),
(171, 2, 'Needs better maintenance.', 20241206, 20241206, 31,171),

-- Reviews for Vung Tau Coastal Homestay
(172, 5, 'Amazing sea views and great service.', 20241201, 20241201, 32, 172),
(173, 4, 'Comfortable and relaxing.', 20241202, 20241202, 32, 173),
(174, 3, 'Good location but average facilities.', 20241203, 20241203, 32, 174),
(175, 5, 'Perfect for a beach getaway.', 20241204, 20241204, 32, 175),
(176, 4, 'Highly recommend for couples.', 20241205, 20241205, 32, 176),
(177, 1, 'Too noisy and crowded.', 20241206, 20241206, 32,177),

-- Reviews for Ha Giang Highland Homestay
(178, 5, 'Scenic views of the highlands.', 20241201, 20241201, 33, 178),
(179, 4, 'Very peaceful and quiet.', 20241202, 20241202, 33, 179),
(180, 3, 'Good stay but far from amenities.', 20241203, 20241203, 33, 180),
(181, 5, 'Perfect for nature enthusiasts.', 20241204, 20241204, 33, 181),
(182, 4, 'Friendly hosts and great location.', 20241205, 20241205, 33, 182),
(183, 2, 'Basic facilities, needs improvement.', 20241206, 20241206, 33, 183),

-- Reviews for Moc Chau Tea Hill Homestay
(184, 5, 'Lovely stay amidst the tea hills.', 20241201, 20241201, 34, 184),
(185, 4, 'Relaxing and cozy atmosphere.', 20241202, 20241202, 34, 185),
(186, 3, 'Decent stay, beautiful location.', 20241203, 20241203, 34, 186),
(187, 5, 'Perfect for tea lovers.', 20241204, 20241204, 34, 187),
(188, 4, 'Great service and amenities.', 20241205, 20241205, 34, 188),
(189, 2, 'Needs better road access.', 20241206, 20241206, 34, 189),

-- Reviews for Nha Trang Beach Homestay
(190, 5, 'Perfect stay near Nha Trang beach.', 20241201, 20241201, 35, 190),
(191, 4, 'Lovely ambiance and great hosts.', 20241202, 20241202, 35, 191),
(192, 3, 'Good location but noisy.', 20241203, 20241203, 35, 192),
(193, 5, 'Highly recommend for beach lovers.', 20241204, 20241204, 35, 193),
(194, 4, 'Very relaxing and peaceful.', 20241205, 20241205, 35, 194),
(195, 1, 'Disappointing experience.', 20241206, 20241206, 35, 195),

-- Reviews for Phu Quoc Paradise Homestay
(196, 5, 'Amazing stay on the island.', 20241201, 20241201, 36, 196),
(197, 4, 'Great location near the beach.', 20241202, 20241202, 36, 197),
(198, 3, 'Good stay but expensive.', 20241203, 20241203, 36, 198),
(199, 5, 'Perfect for a tropical retreat.', 20241204, 20241204, 36, 199),
(200, 4, 'Lovely place with great hosts.', 20241205, 20241205, 36, 200),
(201, 2, 'Could improve cleanliness.', 20241206, 20241206, 36, 201);





-- Reviews for remaining homestays
... -- Repeat pattern for homestays 29 through 36


-- Hiển thị dữ liệu từ bảng Users
SELECT * FROM Users;

-- Hiển thị dữ liệu từ bảng Bookings
SELECT * FROM Bookings;

-- Hiển thị dữ liệu từ bảng Homestays
SELECT * FROM Homestays;

-- Hiển thị dữ liệu từ bảng Rooms
SELECT * FROM Rooms;

-- Hiển thị dữ liệu từ bảng Reviews
SELECT * FROM Reviews;

-- Hiển thị dữ liệu từ bảng Photos
SELECT * FROM Photos;

-- Hiển thị dữ liệu từ bảng Services
SELECT * FROM Services;

-- Hiển thị dữ liệu từ bảng Services_advantage
SELECT * FROM Services_advantage;

UPDATE Rooms
SET status = 0
WHERE room_id IN (
    SELECT TOP 50 room_id
    FROM Rooms
    WHERE status = 1
    ORDER BY NEWID()  -- Sử dụng NEWID() để chọn ngẫu nhiên
);

