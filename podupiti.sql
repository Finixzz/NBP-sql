/*
SELECT column-names
  FROM table-name1
 WHERE value IN (SELECT column-name
                   FROM table-name2 
                  WHERE condition)

SELECT column1 = (SELECT column-name FROM table-name WHERE condition),
       column-names
  FROM table-name
 WEHRE condition


 SELECT FirstName, LastName, 
       OrderCount = (SELECT COUNT(O.Id) FROM [Order] O WHERE O.CustomerId = C.Id)
  FROM Customer C 
  */

--northwind
use NORTHWND
go
/*
Koristeći tabelu Order Details kreirati upit kojim će se odrediti razlika 
između:
a) minimalne i maksimalne vrijednosti UnitPrice.
b) maksimalne i srednje vrijednosti UnitPrice
*/

select
	MIN(UnitPrice)-MAX(UnitPrice) 'Razlika_min_max',
	MAX(UnitPrice)-AVG(UnitPrice) 'Razlika_max_avg'
from
	[Order Details]



/*
Koristeći tabelu Order Details kreirati upit kojim će se odrediti srednje vrijednosti UnitPrice po narudžbama.
*/

SELECT
	OrderID,
	ROUND(AVG(UnitPrice),2) 'Srednja vrijednost unit pricea'
FROM
	[Order Details]
GROUP BY OrderID

SELECT DISTINCT
	OD.OrderID,
	ROUND((SELECT AVG(UnitPrice) FROM [Order Details] WHERE OrderID=OD.OrderID),2) 'Srednja vrijednost unit pricea'
FROM
	[Order Details] as OD


/*
Koristeći tabelu Order Details kreirati upit kojim će se prebrojati broj 
narudžbi kojima je UnitPrice:
a) za 20 KM veća od minimalne vrijednosti UniPrice
b) za 10 KM manja od maksimalne vrijednosti UniPrice
*/
SELECT
	COUNT(*) 'Broj naruzdbi'
FROM(
	SELECT
		OrderID
	FROM
		[Order Details]
	WHERE
		UnitPrice=(SELECT MAX(UnitPrice) FROM [Order Details])-10 
		OR
		UnitPrice=(SELECT MIN(UnitPrice) FROM [Order Details])+20) AS Prebrojano


/*
Koristeći tabelu Order Details kreirati upit kojim će se dati pregled zapisa
kojima se UnitPrice nalazi u rasponu od +10 KM u odnosu na minimum i -10 u
odnosu na maksimum. Upit traba da sadrži OrderID.
*/
SELECT DISTINCT
	OrderID
FROM
	[Order Details]
WHERE UnitPrice BETWEEN (SELECT MIN(UnitPrice)+10 FROM [Order Details]) AND (SELECT MAX(UnitPrice)-10 FROM [Order Details])


/*
Koristeći tabelu Orders kreirati upit kojim će se prebrojati broj naručitelja
kojima se Freight nalazi u rasponu od 10 KM u odnosu na srednju
vrijednost Freighta. Upit traba da sadrži CustomerID i ukupan broj po CustomerID.
*/

SELECT distinct
	CustomerID,
	SUM(Freight) 'Ukupan trosak'
FROM
	Orders
GROUP BY CustomerID
HAVING  SUM(Freight) BETWEEN (SELECT AVG(Freight)-10 FROM Orders) AND (SELECT AVG(Freight)+10 FROM Orders)




/*
Koristeći tabele Orders i Order Details kreirati upit kojim će se dati pregled ukupnih količina ostvarenih po OrderID.
*/
SELECT
	O.OrderID,
	(SELECT SUM(Quantity) FROM [Order Details] WHERE OrderID=O.OrderID) 'Kolicina'
FROM
	Orders as O


/*
Koristeći tabele Orders i Employees kreirati upit kojim će se dati pregled
ukupno realiziranih narudžbi po uposleniku.
Upit treba da sadrži prezime i ime uposlenika, te ukupan broj narudžbi.
*/

SELECT
	E.FirstName,
	E.LastName,
	(SELECT COUNT(OrderID) FROM Orders WHERE EmployeeID=E.EmployeeID) 'Broj narudzbi'
FROM
	Employees as E
ORDER BY [Broj narudzbi]


/*
Koristeći tabele Orders i Order Details kreirati upit kojim će se dati pregled narudžbi kupca u kojima je naručena količina veća od 10.
Upit treba da sadrži CustomerID i Količinu, te ukupan broj narudžbi.
*/

SELECT
	O.CustomerID,
	(SELECT SUM(Quantity) FROM [Order Details] WHERE OrderID=O.OrderID) 'Kolicina narudzbe',
	(SELECT COUNT(*) FROM Orders WHERE CustomerID=O.CustomerID) 'Broj izvrsenih narudzbi'
FROM
	Orders AS O
WHERE (SELECT SUM(Quantity) FROM [Order Details] WHERE OrderID=O.OrderID) > 10
ORDER BY 1


/*
Koristeći tabelu Products kreirati upit kojim će se dati pregled proizvoda kojima je stanje na stoku veće od srednje vrijednosti stanja na stoku. Upit treba da sadrži ProductName i UnitsInStock.
*/

SELECT
	ProductName,
	UnitsInStock
FROM
	Products
WHERE UnitsInStock>(SELECT AVG(UnitsInStock) FROM Products)
ORDER BY 2 DESC



/*
Koristeći tabelu Products kreirati upit kojim će se prebrojati broj proizvoda po dobavljaču kojima je stanje na stoku veće od srednje vrijednosti stanja na stoku. Upit treba da sadrži SupplierID i ukupan broj proizvoda.
*/
SELECT
	SupplierID,
	COUNT(ProductID) 'Ukupan broj proizvoda'
FROM
	Products
WHERE UnitsInStock>(SELECT AVG(UnitsInStock) FROM Products)
GROUP BY SupplierID


/*
Iz tabele Order Details baze Northwind dati prikaz ID narudžbe, ID proizvoda i jedinične cijene, te razliku cijene proizvoda
u odnosu na srednju vrijednost cijene za sve proizvode u tabeli. Rezultat sortirati prema vrijednosti razlike
u rastućem redoslijedu.*/
SELECT
	OrderID,
	ProductID,
	UnitPrice,
	UnitPrice-(SELECT AVG(UnitPrice) FROM [Order Details]) 'Razlika'
FROM
	[Order Details]
ORDER BY Razlika


/*
Iz tabele Products baze Northwind za sve proizvoda kojih ima na stanju dati prikaz ID proizvoda, 
naziv proizvoda i stanje zaliha, te razliku stanja zaliha proizvoda u odnosu na srednju vrijednost 
stanja za sve proizvode u tabeli. Rezultat sortirati prema vrijednosti razlike u 
opadajućem redoslijedu.*/
SELECT
	ProductID,
	ProductName,
	UnitsInStock,
	UnitsInStock-(SELECT  AVG(UnitsInStock) FROM Products) 'Razlika'
FROM
	Products
ORDER BY Razlika DESC


/*
Upotrebom tabela Orders i Order Details baze Northwind prikazati ID narudžbe i kupca koji je kupio
više od 10 komada proizvoda čiji je ID 15.*/
SELECT
	O.OrderID,
	O.CustomerID
FROM
	Orders AS O
WHERE (SELECT Quantity FROM [Order Details] WHERE OrderID=O.OrderID AND ProductID=15) >10

/*
Upotrebom tabela sales i stores baze pubs prikazati ID i naziv prodavnice u kojoj je naručeno
više od 1 komada publikacije čiji je ID 6871.*/
use pubs
go

SELECT
	ST.stor_id,
	ST.stor_name
FROM
	stores AS ST
WHERE (SELECT qty FROM sales WHERE stor_id=ST.stor_id AND title_id='6871')>1





