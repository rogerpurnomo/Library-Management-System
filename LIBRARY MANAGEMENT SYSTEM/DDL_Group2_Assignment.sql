CREATE TABLE Members
(
	MemberID           VARCHAR(50) PRIMARY KEY NOT NULL,
    FirstName          NVARCHAR(50),
    LastName           NVARCHAR(50),
    Gender             NVARCHAR(10),
    DateOfBirth        DATE,
    Address            VARCHAR(200),
    Neighbourhood      VARCHAR(50),
    PhoneNumber        VARCHAR(50),
    SignUpDate         DATE,
    LastRoomBookedDate DATE,
    AnnualBookBorrowed INT,
    BorrowedItems      INT
); 

INSERT INTO Members
            (MemberID,FirstName,LastName,Gender,DateOfBirth,Address,
			Neighbourhood,PhoneNumber,SignUpDate,LastRoomBookedDate,AnnualBookBorrowed,BorrowedItems)
VALUES      ('00001','Jack','Black','Male','2001-03-31','1, Jalan Bahagia',
			'Bukit Jalil','012-3345-664','2020-01-01',NULL,12,3),
            ('00002','Jack','White','Male','1991-04-27','41, Jalan Durian',
			'Bukit Senang','012-3345-665','2020-02-02','2024-12-12',13,2),
            ('00003','Jay','Chao','Male','1977-09-05','22, Jalan Apple',
			'Buah Batu','012-3345-666','2020-02-03',NULL,9,1),
            ('00004','Jay','Gao','Male','2004-07-18','9, Jalan SS12',
			'Puchong Jaya','012-3345-667','2020-03-04',NULL,3,0),
            ('00005','Donald','Dump','Male','1978-05-01','34, Jalan Malaysia',
			'Sanbara','012-3345-668','2020-03-05','2024-12-15',0,0 ),
            ('00006','Harold','Carol','Male','2009-10-23','70, Jalan Rotengo',
			'Sanbara','012-3345-660','2020-08-05','2024-05-01',13,1),
            ('00007','Ashley','Shin','Female','2006-08-05','41, Jalan Malaysia',
			'Sanbara','012-3345-421','2020-12-05','2024-12-18',24,2),
            ('00008','Daisy','Duck','Female','1991-10-25','65, Jalan Donut',
			'Bukit Senang','012-3225-668','2021-01-06','2024-06-30',100,2),
            ('00009','Jennifer','Jess','Female','1996-10-17','22, Jalan Watermelon',
			'Buah Batu','012-3185-725','2021-01-12','2024-01-17',72,4),
            ('00010','Jessica','Yuo','Female','2005-07-10','22, Jalan Bintang',
			'Bukit Senang','012-3333-811','2021-02-05',NULL,3,1),
            ('00011','Donald','Yao','Male','1986-07-20','32, Jalan Durian','Bukit Senang','012-3390-932','2021-05-15',NULL,21,2),
            ('00012','Kevin','Hert','Male','1993-01-05','5, Jalan Teknologi',
			'Bukit Jalil','012-2345-442','2021-06-25','2024-12-18',12,1),
            ('00013','Alvin','Tarumanagara','Male','1988-12-15','34, Jalan Watermelon',
			'Buah Batu','012-7000-124','2021-09-05',NULL,1,0),
            ('00014','Sho','Li Kai','Male','1978-12-01','77, Jalan Malaysia',
			'Sanbara','012-8265-463','2021-10-31',NULL,8,1),
            ('00015','John','Trough','Male','2002-04-25','34, Jalan Rotengo',
			'Sanbara','012-9162-001','2022-01-13','2024-12-02',19,2),
            ('00016','Helena','Wang','Female','1991-01-01','37, Jalan Puchong Jaya',
			'Puchong Jaya','012-8843-001','2022-06-03','2024-12-20',31,5),
            ('00017','Timothy','Ronald','Male','1984-04-18','99, Jalan Rotengo',
			'Sanbara','012-6353-055','2022-10-07','2024-12-20',10,2),
            ('00018','Rose','Green','Female','1979-01-30','1, Jalan Halim',
			'Puchong Jaya','012-5282-300','2023-03-03',NULL,90,5),
            ('00019','Patricia','Kwoon','Female','1987-06-22','3, Jalan Kerajaan',
			'Royal Kuala Lumpur','012-3264-311','2023-04-25',NULL,2,0),
            ('00020','Samantha','Rose','Female','1990-02-02','34, Jalan Kerajaan',
			'Royal Kuala Lumpur','012-7394-474','2023-05-27','2024-11-12',45,3);

CREATE TABLE Category
(
    CategoryID        VARCHAR(50) PRIMARY KEY,
    CategoryName      NVARCHAR(50),
    LoanDuration      NVARCHAR(50),
    CanBeBorrowed     NVARCHAR(50),
    OverdueFinePerDay DECIMAL (10, 2)
); 

INSERT INTO Category
        (CategoryID,CategoryName,LoanDuration,CanBeBorrowed,OverdueFinePerDay)
VALUES	('CT001','Books','5','True',0.50),
		('CT002','Magazine',NULL,'False',NULL),
		('CT003','DVDs','3','True',0.30),
		('CT004','Games','2','True',0.20);

CREATE TABLE Items
(
    ItemID           VARCHAR(50) PRIMARY KEY NOT NULL,
    CategoryID       VARCHAR(50),
    Title            NVARCHAR(50),
    Author           NVARCHAR(50),
    Genre            NVARCHAR(50),
    Description      NVARCHAR(200),
    Producer         NVARCHAR(50),
    TotalQuantity    INT,
    BorrowedQuantity INT,
    Cost             DECIMAL (10, 2),
	FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
); 

INSERT INTO Items
        (ItemID,CategoryID,Title,Author,
		Genre,Description,Producer,TotalQuantity,BorrowedQuantity,Cost)
VALUES	('T0001','CT001','Introduction to IDB','Jack Slack',
		'Education','A book for beginners studying IDB','Mark Lee',5,1,100.00),
		('T0002','CT001','Introduction to Discrete Maths','Brian White',
		'Education','A book for beginners studying maths','Mark Lee',5,1,90.90),
		('T0003','CT001','In-Depth Explanation of IDB','Jack Slack',
		'Education','A book for masters studying IDB','Steven Spielberg',4,2,80.80),
		('T0004','CT001','Introduction to IP Protocol','Daniel Jon',
		'Education','A book for beginners studying Networking','Mark Lee',2,2,70.70),
		('T0005','CT001','Introduction to Literature','John Green',
		'Education','A book for beginners studying English','Mark Lee',1,1,60.60),
		('T0006','CT002','Louis Vuitton: New Style New Me','Stanley Tucci',
		'Fashion','The latest fashion from Louis Vuitton','John Gosh',3,1,50.50),
		('T0007','CT002','Guess: Collection 2024','Gigi Trane',
		'Fashion','The 2024 collection of Gucci','John Gosh',2,2,40.40),
		('T0008','CT002','New Style for Dogs','Arnold Hatre',
		'Fashion','Magazines for dog owners','Jackie Tussen',3,2,30.30),
		('T0009','CT003','The Legend of the Sun','Harry Oswald',
		'Fiction','A fiction-action movie','Joshua Lai',1,1,'25.25'),
		('T0010','CT003','Donald Trump: Revolution','Sean McGiffin',
		'Documentary','A documentary about US President, Donald J Trump','Werte Oroko',4,1,35.35),
		('T0011','CT003','Star Wars: The Phantom Menace','Luke Skywalker',
		'Fiction','A fiction-action movie in space','Joshua Lai',2,1,40.40),
		('T0012','CT003','Magnus The Genius Carlsen','Alexander Fadel',
		'Documentary','A documentary about the greatest chess player, Magnus Carlsen','Sonny Sanputra',2,2,55.55),
		('T0013','CT004','Marvel Rivals','John Cena',
		'Video Game','A game for marvel fans','Kay Nouvell',2,2,65.65),
		('T0014','CT004','Chess','Levy Rotman',
		'Board Game','A relaxing game of the mind and heart','Sonny Sanputra',3,2,75.75),
		('T0015','CT004','Cyberpunk','John Cena',
		'Video Game','A game full of adrenaline and excitement with an awesome storyline','Juan Andrew',1,1,85.58),
		('T0016','CT001','The War is Over','Patricia Faye',
		'Documentary','A documentary about events following the world war 2','Werte Oroko',2,1,95.95),
		('T0017','CT001','Programming with Java','Brian White',
		'Education','A book about Java programming','Aminah Ray',2,2,87.70),
		('T0018','CT001','Helena: The Warrior','Harry Oswald',
		'Fiction','A fiction-action book about a warrior','Joshua Lai',1,1,50.45),
		('T0019','CT001','Literature: A Work of Art','John Green',
		'Education','A book for experts studying English','Steven Spielberg',3,1,70.17),
		('T0020','CT001','IDB: Your Guide in SSMS','Jack Slack',
		'Education','A book for a guide in SSMS','Steven Spielberg',2,1,35.80);

CREATE TABLE Barcodes
(
    Barcode NVARCHAR(50) PRIMARY KEY NOT NULL,
    ItemID  VARCHAR(50),
    FOREIGN KEY (ItemID) REFERENCES items(ItemID)
);

INSERT INTO Barcodes 
		(Barcode, ItemID)
VALUES	('B105','T0001'),('B161','T0001'),('B199','T0001'),('B206','T0001'),('B213','T0001'),
		('B234','T0002'),('B255','T0002'),('B259','T0002'),('B267','T0002'),('B272','T0002'),
		('B275','T0003'),('B291','T0003'),('B297','T0003'),('B323','T0003'),('B344','T0004'),
		('B381','T0004'),('B404','T0005'),('B420','T0006'),('B436','T0006'),('B455','T0006'),
		('B458','T0007'),('B474','T0007'),('B490','T0008'),('B491','T0008'),('B499','T0008'),
		('B610','T0009'),('B617','T0010'),('B641','T0010'),('B674','T0010'),('B699','T0010'),
		('B704','T0011'),('B714','T0011'),('B718','T0012'),('B722','T0012'),('B738','T0013'),
		('B809','T0013'),('B813','T0014'),('B817','T0014'),('B834','T0014'),('B849','T0015'),
		('B867','T0016'),('B874','T0016'),('B893','T0017'),('B913','T0017'),('B936','T0018'),
		('B941','T0019'),('B942','T0019'),('B964','T0019'),('B970','T0020'),('B979','T0020');

CREATE TABLE Loans
(
    LoanID     NVARCHAR(50) PRIMARY KEY,
	MemberID   VARCHAR(50),
    Barcode    NVARCHAR(50),
    LoanDate   DATE,
    DueDate    DATE,
    ReturnDate DATE,
	Paid NVARCHAR(10),
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (Barcode) REFERENCES barcodes(Barcode)
);

INSERT INTO Loans
		(LoanID, MemberID, Barcode, LoanDate, DueDate, ReturnDate, Paid)
VALUES	('L00001','00001','B105','2022-12-05','2022-12-10','2022-12-09',Null),
		('L00002','00001','B161','2022-12-05','2022-12-08','2022-12-10','Paid'),
		('L00003','00001','B970','2022-12-17','2022-12-24',NULL,NULL),
		('L00004','00002','B105','2023-12-16','2023-12-21','2023-12-22','Paid'),
		('L00005','00002','B234','2023-12-09','2023-12-14','2023-12-17','Paid'),
		('L00006','00003','B809','2023-12-08','2023-12-10','2023-12-10',NULL),
		('L00007','00006','B105','2023-12-22','2023-12-27',NULL,NULL),
		('L00008','00007','B809','2024-12-18','2024-12-23','2024-12-20',NULL),
		('L00009','00007','B610','2024-12-04','2024-12-07','2024-12-06',NULL),
		('L00010','00008','B610','2024-12-19','2024-12-22',NULL,NULL),
		('L00011','00008','B161','2024-12-03','2024-12-08','2024-12-05',NULL),
		('L00012','00009','B722','2024-12-01','2024-12-04','2024-12-03',NULL),
		('L00013','00009','B970','2024-12-10','2024-12-15','2024-12-17','Paid'),
		('L00014','00009','B979','2024-12-12','2024-12-14','2024-12-14',NULL),
		('L00015','00001','B849','2024-12-07','2024-12-09','2024-12-07',NULL),
		('L00016','00001','B641','2024-12-19','2024-12-22','2024-12-21',NULL),
		('L00017','00001','B714','2024-12-09','2024-12-12','2024-12-13','Not Paid'),
		('L00018','00001','B813','2024-12-04','2024-12-06','2024-12-05',NULL),
		('L00019','00001','B105','2024-12-02','2024-12-04','2024-12-04',NULL),
		('L00020','00001','B105','2024-12-12','2024-12-14','2024-12-13',NULL),
		('L00021','00001','B874','2024-12-12','2024-12-17',NULL,NULL),
		('L00022','00001','B699','2024-12-09','2024-12-12','2024-12-17','Paid'),
		('L00023','00002','B234','2024-12-09','2024-12-14','2024-12-17','Paid');

CREATE TABLE Rooms
(
    RoomID   NVARCHAR(50) PRIMARY KEY,
    RoomName NVARCHAR(50),
    Capacity INT
); 

INSERT INTO Rooms
		(RoomID, RoomName, Capacity)
VALUES	('R001','Magnolia','20'),
		('R002','Rose','10'),
		('R003','Rafflesia','5'),
		('R004','Tulip','20'),
		('R005','Orchid','20'),
		('R006','Jasmine','20'),
		('R007','Velvet','10'),
		('R008','Chrysanthemum','5'),
		('R009','Dandelion','20'),
		('R010','Cactus','20'),
		('R011','Iris','20'),
		('R012','Azalea','10'),
		('R013','Lily','5'),
		('R014','Dahlia','20'),
		('R015','Daisy','20'),
		('R016','Carnation','20'),
		('R017','Poppy','10'),
		('R018','Violet','5'),
		('R019','Daffodil','20'),
		('R020','Blossom','20');

CREATE TABLE Reservations
(
    ReservationID   NVARCHAR(50) PRIMARY KEY,
    MemberID        VARCHAR(50),
    RoomID          NVARCHAR(50),
    ReservationDate DATE,
    ReservedForDate DATE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);

INSERT INTO Reservations 
		(ReservationID, MemberID, RoomID, ReservationDate, ReservedForDate)
VALUES	('RSV001','00001','R001','2024-07-09','2024-07-13'),
		('RSV002','00002','R002','2024-07-10','2024-07-12'),
		('RSV003','00003','R003','2024-07-10','2024-07-14'),
		('RSV004','00011','R004','2024-07-10','2024-07-15'),
		('RSV005','00012','R005','2024-12-10','2024-12-18'),
		('RSV006','00017','R001','2024-12-10','2024-12-20'),
		('RSV007','00019','R001','2024-12-10','2024-12-15'),
		('RSV008','00020','R001','2024-12-10','2024-12-12'),
		('RSV009','00002','R002','2024-12-11','2024-12-13'),
		('RSV010','00002','R002','2024-12-11','2024-12-17'),
		('RSV011','00002','R005','2024-12-13','2024-12-20'),
		('RSV012','00001','R003','2024-12-13','2024-12-20'),
		('RSV013','00014','R004','2024-12-13','2024-12-16'),
		('RSV014','00013','R002','2024-12-14','2024-12-16'),
		('RSV015','00002','R002','2024-12-20','2024-12-27'),
		('RSV016','00019','R005','2024-12-21','2024-12-31'),
		('RSV017','00020','R005','2024-12-21','2024-12-30'),
		('RSV018','00003','R005','2024-12-21','2024-12-28'),
		('RSV019','00004','R003','2024-12-23','2024-12-31'),
		('RSV020','00002','R001','2024-12-24','2024-12-31'),
		('RSV021','00002','R002','2024-12-25','2025-01-02'),
		('RSV022','00011','R003','2024-12-25','2025-01-01'),
		('RSV023','00002','R002','2024-12-25','2025-01-01');

