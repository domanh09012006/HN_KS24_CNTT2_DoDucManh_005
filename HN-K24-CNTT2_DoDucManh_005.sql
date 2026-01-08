create database hackathon_05;
use hackathon_05;

create table Creator(
	creator_id varchar(5) primary key,
    creator_name varchar(100) not null,
    creator_email varchar(100) not null unique,
    creator_phone varchar(15) unique,
    creator_platform varchar(50)
);

create table Studio(
	studio_id varchar(5) primary key,
    studio_name varchar(100) not null,
    studio_location varchar(100),
    hourly_price decimal(10,2),
    studio_status varchar(20)  
);

create table LiveSession (
	session_id int primary key auto_increment,
    creator_id varchar(5),
    studio_id varchar(5),
    session_date date,
    duration_hours int,
    foreign key (creator_id) references Creator(creator_id),
    foreign key (studio_id) references Studio(studio_id)
);

create table Payment (
	payment_id int primary key auto_increment,
    session_id int ,
    payment_method varchar(50),
    payment_amount decimal(10,2),
    payment_date date,
    foreign key (session_id) references LiveSession(session_id)
);

insert into Creator 
values ('CR01', 'Nguyen Van A', 'a@live.com', '0901111111', 'Tiktok'),
('CR02', 'Tran Thi B', 'b@live.com', '0902222222', 'Youtube'),
('CR03', 'Le Minh C', 'c@live.com', '0903333333', 'Facebook'),
('CR04', 'Pham Thi D', 'd@live.com', '0904444444', 'Tiktok'),
('CR05', 'Vu Hoang E', 'e@live.com', '0905555555', 'Shopee live');

insert into Studio 
values ('ST01', 'Studio A', 'Ha Noi', 20, 'Avaliable'),
('ST02', 'Studio B', 'HCM', 25, 'Avaliable'),
('ST03', 'Studio C', 'Danang', 30, 'Booked'),
('ST04', 'Studio D', 'Ha Noi', 22, 'Avaliable'),
('ST05', 'Studio E', 'Can Tho', 18, 'Maintenance');

insert into LiveSession(creator_id, studio_id, session_date, duration_hours)
values ('CR01', 'ST01', '2025-05-01', 3),
('CR02', 'ST02', '2025-05-02', 4),
('CR03', 'ST03', '2025-05-03', 2),
('CR01', 'ST04', '2025-05-04', 5),
('CR05', 'ST01', '2025-05-01', 1);

insert into Payment (session_id, payment_method, payment_amount, payment_date) values
(1, 'Cash', 60.00, '2025-05-01'),
(2, 'Credit Card', 100.00, '2025-05-02'),
(3, 'Bank Transfer', 60.00, '2025-05-03'),
(4, 'Credit Card', 110.00, '2025-05-04'),
(5, 'Cash', 25.00, '2025-05-05');

SELECT * from Creator;
SELECT * from Studio;
SELECT * from Payment;

-- Cập nhật creator_platform của creator CR03 thành "YouTube"
update Creator set creator_platform = 'YouTube' where creator_id = 'CR03';

-- Do studio ST05 hoạt động trở lại, cập nhật studio_status = 'Available' và giảm hourly_price 10%
update Studio set studio_status = 'Available' where studio_id = 'ST05';
update Studio set hourly_price = 18*90/100  where studio_id = 'ST05';

-- Xóa các payment có payment_method = 'Cash' và payment_date trước ngày 2025-05-03
delete from Payment where payment_method = 'Cash' and payment_date < '2025-05-03';


-- TRUY VAN CO BAN 
-- Liệt kê studio có studio_status = 'Available' và hourly_price > 20
select * from Studio 
where studio_status = 'Avaliable' and hourly_price > 20;

-- Lấy thông tin creator (creator_name, creator_phone) có nền tảng là TikTok
select creator_name, creator_phone, creator_platform from Creator c
where creator_platform = 'Tiktok';

-- Hiển thị danh sách studio gồm studio_id, studio_name, hourly_price sắp xếp theo giá thuê giảm dần
select studio_id, studio_name, hourly_price from Studio s
order by hourly_price desc;

-- Lấy 3 payment đầu tiên có payment_method = 'Credit Card'
select * from Payment p where payment_method = 'Credit Card' limit 3; 

-- Hiển thị danh sách creator gồm creator_id, creator_name bỏ qua 2 bản ghi đầu và lấy 2 bản ghi tiếp theo
select creator_id, creator_name from Creator limit 2 offset 2;

-- TRUY VAN NANG CAO
-- Hiển thị danh sách livestream gồm: session_id, creator_name, studio_name, duration_hours, payment_amount
select l.session_id, c.creator_name, s.studio_name, l.duration_hours, p.payment_amount
from LiveSession l
join Creator c on l.creator_id = c.creator_id
join Studio s on l.studio_id = s.studio_id
join Payment p on l.session_id = p.session_id;

-- Liệt kê tất cả studio và số lần được sử dụng
select s.studio_id, s.studio_name, count(l.session_id) as so_lan_su_dung
from Studio s
left join LiveSession l on s.studio_id = l.studio_id
group by s.studio_id, s.studio_name;

-- Tính tổng doanh thu theo từng payment_method
select payment_method, sum(payment_amount) as tong_doanh_thu
from Payment
group by payment_method;

-- Lấy studio có hourly_price cao hơn mức trung bình của tất cả studio
select * from Studio
where hourly_price > (
    select avg(hourly_price)
    from Studio
);





