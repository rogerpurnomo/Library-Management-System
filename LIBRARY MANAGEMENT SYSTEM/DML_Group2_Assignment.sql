/*Question 1*/
SELECT DISTINCT
	Items.Title AS ItemName,
    Items.Description AS ItemDescription,
    Category.CategoryName AS CategoryName
FROM Items
	INNER JOIN Category ON Items.CategoryID = Category.CategoryID
    JOIN Barcodes ON Barcodes.ItemID = Items.ItemID
	LEFT JOIN Loans ON Barcodes.Barcode = Loans.Barcode
WHERE 
	(Loans.LoanID IS NULL OR Loans.Barcode NOT IN (SELECT Barcode FROM Loans WHERE ReturnDate is Null and GETDATE()>DueDate))
	AND 
	Category.CanBeBorrowed = 'True'
ORDER BY Category.CategoryName; 

/*Question 2*/
WITH latefees AS
(
	SELECT 
		Loans.LoanID,
        Loans.MemberID,
        CASE
			WHEN Loans.ReturnDate > Loans.DueDate THEN
				Datediff(day, Loans.DueDate, Loans.ReturnDate) * Category.OverdueFinePerDay
            WHEN (Loans.DueDate < Getdate() AND Loans.ReturnDate IS NULL ) THEN
                Datediff(day, Loans.DueDate, Getdate()) * Category.OverdueFinePerDay
            ELSE 0
            END AS OverdueFee
	FROM Loans
    JOIN Barcodes ON Loans.Barcode = Barcodes.Barcode
    JOIN Items ON Barcodes.Itemid = Items.ItemID
    JOIN Category ON Category.CategoryID = Items.CategoryID
),
NumberOfPaid AS
(
	SELECT DISTINCT
		MemberID
	FROM Loans
	WHERE Loans.Paid IS NOT NULL and Loans.Paid='Paid'
)
SELECT DISTINCT
	Members.FirstName + ' ' + Members.LastName AS MemberName,
    Members.PhoneNumber AS Contact,
    Count(Loans.LoanID) AS NumberOfOverduePaid,
    Sum(latefees.OverdueFee) AS TotalOverdueFee
FROM Members
JOIN Loans ON Loans.MemberID = Members.MemberID
JOIN latefees ON Loans.LoanID = latefees.LoanID
WHERE 
	latefees.overduefee <> 0
	AND
	Loans.Paid is not NULL
	AND
	Loans.Paid='Paid'
GROUP BY
	Members.FirstName,
	Members.LastName,
	Members.PhoneNumber
HAVING
	count(Loans.LoanID)>2;

/*Question 3*/
SELECT
	Members.FirstName + ' ' + Members.LastName AS MemberName,
	Items.Title AS BookName,
	Loans.LoanDate AS LoanDate
FROM Members
JOIN Loans ON Members.MemberID = Loans.MemberID
JOIN Barcodes ON Barcodes.Barcode = Loans.Barcode
JOIN Items ON Barcodes.ItemID = Items.ItemID
WHERE 
	Year(Loans.LoanDate) IN ( 2022, 2023 )
    AND
	Members.AnnualBookBorrowed >= 8
ORDER BY Loans.LoanDate

/*Question 4*/
SELECT
	Members.FirstName AS FirstName,
    Members.LastName AS LastName,
    Count(Loans.LoanID) AS NumberOfBorrowedItems
FROM Members
JOIN Loans ON Members.MemberID = Loans.MemberID
WHERE 
	Members.MemberID IN (
		SELECT DISTINCT
			Members.MemberID
        FROM Members
		JOIN Loans ON Members.MemberID = Loans.MemberID
        WHERE 
			Year(Loans.LoanDate) = 2024
        GROUP BY
			Members.MemberID
        HAVING
			Count(Loans.LoanID) >= 8)
GROUP BY 
	Members.MemberID,
    Members.FirstName,
    Members.LastName;

/*Question 5*/
WITH noborrowed AS
(
	SELECT 
		Loans.MemberID AS MemberID,
        Items.ItemID   AS ItemID,
        Count(Loans.LoanID)  AS NoOfBorrows
	FROM Loans
	JOIN Barcodes ON Barcodes.Barcode = Loans.Barcode
    JOIN Items ON Items.ItemID = Barcodes.ItemID
    JOIN Members ON Members.MemberID = Loans.MemberID
    GROUP BY 
		Loans.MemberID,
        Items.ItemID
),
maxitems AS 
(
	SELECT 
		MemberID,
        Max(NoOfBorrows) AS MaxBorrows
    FROM noborrowed
    GROUP BY 
		MemberID
)
SELECT 
	Members.FirstName + ' ' + Members.LastName AS MemberName,
    Members.PhoneNumber AS Contact,
    Items.Title AS Title,
    Items.Description AS ItemDescription,
    noborrowed.NoOfBorrows as NoOfBorrows,
    Category.CategoryName AS CategoryType
FROM Members
JOIN noborrowed ON noborrowed.MemberID = Members.MemberID
JOIN Items ON Items.ItemID = noborrowed.ItemID
JOIN Category ON Category.CategoryID = Items.CategoryID
JOIN maxitems ON Members.MemberID = maxitems.MemberID AND noborrowed.NoOfBorrows = maxitems.MaxBorrows
GROUP BY 
	Members.FirstName,
    Members.LastName,
    Members.PhoneNumber,
    Items.Title,
    Items.Description,
    noborrowed.NoOfBorrows,
    Category.CategoryName
ORDER  BY Category.CategoryName;

/*Question 6*/
WITH finecalculation AS 
(
	SELECT
		Members.MemberID,
        Members.FirstName,
        Members.LastName,
        Loans.LoanID,
        Items.Title,
        Category.CategoryName,
        Loans.LoanDate,
        Loans.DueDate,
        Loans.ReturnDate,
        Category.OverdueFinePerDay,
        CASE
			WHEN Loans.ReturnDate IS NOT NULL THEN
				Datediff(day, Loans.DueDate, Loans.ReturnDate)
            ELSE Datediff(day, Loans.DueDate, Cast(Getdate() AS DATE))
            END AS OverdueDays,
        CASE
            WHEN Loans.ReturnDate IS NOT NULL THEN
				CASE
					WHEN Datediff(day, Loans.DueDate, Loans.ReturnDate) > 0 THEN
						Datediff(day, Loans.DueDate, Loans.ReturnDate) * Category.OverdueFinePerDay
                    ELSE 0
                    END
            ELSE
                 CASE
                    WHEN Datediff(day, Loans.DueDate, Cast(Getdate() AS DATE))> 0 THEN
						Datediff(day, Loans.DueDate, Cast(Getdate() AS DATE)) * Category.OverdueFinePerDay
                    ELSE 0
                    END
            END AS ItemFine
	FROM Members
    JOIN Loans ON Members.MemberID = Loans.MemberID
    JOIN Barcodes ON Loans.Barcode = Barcodes.Barcode
    JOIN Items ON Barcodes.ItemID = Items.ItemID
    JOIN Category ON Items.CategoryID = Category.CategoryID
    WHERE 
		Category.CanBeBorrowed = 'True'
)
SELECT 
	MemberID as MemberID,
    FirstName + ' ' + LastName AS MemberName,
    count(LoanID) AS TotalLoans,
    Sum(CASE
			WHEN OverdueDays > 0 THEN 1
            ELSE 0
			END)                
		AS OverdueItems,
    Round(Sum(ItemFine), 2) AS TotalFine,
    String_agg(CASE
				WHEN ItemFine > 0 THEN 
					Concat(Title, ' (',Format(ItemFine, 'C2'),')')
				END, '; ')
			AS OverdueItemDetails
FROM finecalculation
WHERE 
	ItemFine > 0
GROUP BY
	MemberID,
    FirstName,
    LastName
HAVING
	Sum(ItemFine) > 0
ORDER BY TotalFine DESC;

/*Number 7*/
SELECT
	Members.MemberID AS MemberID,
    Members.FirstName + ' ' + Members.LastName AS MemberName,
    Count (Reservations.ReservationID) AS TotalReservations
FROM Members
JOIN Reservations ON Members.MemberID = Reservations.MemberID
WHERE 
	ReservationDate >= Dateadd(month, -1, Cast(Getdate() AS DATE))
GROUP BY 
	Members.MemberID,
    Members.FirstName,
    Members.LastName
HAVING 
	Count (Reservations.ReservationID) > 3; 

/*Number 8*/
WITH GenreBorrowed AS
(
	SELECT DISTINCT
		Category.CategoryID as categoryid,
		Items.Genre as genre,
		COUNT(Loans.LoanID) as numberofborrows
	FROM Items
	JOIN Category ON Items.CategoryID=Category.CategoryID
	JOIN Barcodes ON Barcodes.ItemID=Items.ItemID
	JOIN Loans ON Loans.Barcode=Barcodes.Barcode
	GROUP BY Category.CategoryID, Items.Genre
),
MaxGenreBorrowed AS
(
	SELECT DISTINCT
		categoryid AS categoryid,
		max(numberofborrows) as maxborrow
	FROM GenreBorrowed
	GROUP BY categoryid
)
SELECT
	Category.CategoryName AS CategoryName,
	GenreBorrowed.genre AS Genre,
	GenreBorrowed.numberofborrows AS NumberOfBorrows
FROM Category
JOIN GenreBorrowed ON Category.CategoryID=GenreBorrowed.categoryid
JOIN MaxGenreBorrowed ON MaxGenreBorrowed.categoryid=GenreBorrowed.categoryid
AND MaxGenreBorrowed.maxborrow=GenreBorrowed.numberofborrows
GROUP BY
	Category.CategoryName,
	GenreBorrowed.genre,
	GenreBorrowed.numberofborrows;

/*Number 9*/
SELECT
	Rooms.RoomID AS RoomID,
	Rooms.RoomName AS RoomName,
	Rooms.Capacity AS Capacity
FROM Rooms
WHERE 
	Rooms.RoomID NOT IN (SELECT RoomID FROM Reservations WHERE ReservedForDate='2024-10-12')
ORDER BY Rooms.RoomID; 

/*Number 10*/
SELECT 
	Rooms.RoomID AS RoomID,
    Rooms.RoomName AS RoomName,
    Rooms.Capacity AS Capacity,
    Reservations.ReservationDate AS ReservationDate,
    Reservations.ReservedForDate AS ReservedForDate,
    Members.FirstName + ' ' + Members.LastName AS MemberName
FROM Rooms
INNER JOIN Reservations ON Rooms.RoomID = Reservations.RoomID
INNER JOIN Members ON Reservations.MemberID = Members.MemberID
WHERE
	(Reservations.ReservationDate BETWEEN '2024-07-01' AND '2024-07-31'
    OR 
	Reservations.ReservedForDate BETWEEN '2024-07-01' AND '2024-07-31')
ORDER  BY Reservations.ReservationDate, Rooms.RoomID; 

/*Number 11*/
SELECT 
	Author as Author,
    Count(*) AS BookCount
FROM Items
GROUP BY
	Author
ORDER BY BookCount DESC; 

/*Number 12*/
SELECT 
	Members.MemberID as MemberID,
    Members.FirstName + ' ' + Members.LastName AS MemberName
FROM Members
LEFT JOIN Loans ON Members.MemberID = Loans.MemberID AND Year(Loans.LoanDate) = 2023
LEFT JOIN Reservations ON Members.MemberID = Reservations.MemberID AND Year(Reservations.ReservedForDate) = 2023
WHERE
	Loans.MemberID IS NULL
    AND
	Reservations.MemberID IS NULL;

/*Question 13*/
SELECT DISTINCT
	Barcodes.Barcode AS BookBarcode,
	Items.Title AS Title,
    Items.Description AS ItemDescription,
    Items.Author AS Author,
    Items.Cost AS Price
FROM Barcodes
JOIN Items ON Items.ItemID = Barcodes.ItemID
JOIN Loans ON Loans.Barcode = Barcodes.Barcode
WHERE
	Year(Loans.LoanDate)= 2024
	AND
	Items.Cost=(SELECT Cost	FROM Items WHERE Cost=(SELECT MAX(Cost) FROM Items));


/*Question 14*/
WITH numberofgenre AS 
(
	SELECT DISTINCT
		Producer,
        Count(DISTINCT(Genre)) AS GenreCount
    FROM Items
    GROUP BY
		Producer
)
SELECT DISTINCT 
	Producer as Producer,
    GenreCount as NumberOfGenres
FROM numberofgenre
WHERE GenreCount = (SELECT Min(GenreCount) AS LeastValue FROM numberofgenre)
GROUP BY 
	Producer,
    GenreCount;

/*Question 15*/
WITH MaleMembers AS
(SELECT DISTINCT
		Members.MemberID AS MemberID,
		Members.FirstName + ' ' + Members.LastName AS MemberName,
		Datediff(year, Members.DateOfBirth, Getdate()) AS MemberAge
	FROM Members
	JOIN Reservations ON Reservations.MemberID = Members.MemberID
	WHERE 
		Members.Gender='Male'
	GROUP BY 
		Members.MemberID,
		Members.FirstName,
		Members.LastName,
		Members.DateOfBirth)
SELECT
	MaleMembers.MemberID,
	MaleMembers.MemberName,
	MaleMembers.MemberAge
FROM MaleMembers
RIGHT JOIN Members on MaleMembers.MemberID=Members.MemberID
GROUP BY 
		MaleMembers.MemberID,
		MaleMembers.MemberName,
		MaleMembers.MemberAge,
		Members.DateOfBirth
HAVING
	MaleMembers.MemberAge>(SELECT AVG(Datediff(year, Members.DateOfBirth, Getdate())) FROM Members);
