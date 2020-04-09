/*
Iz tabele Order Details u bazi Northwind prikazati
narudžbe koje imaju najmanju i najveću naručenu količinu
, ukupan broj narudžbi, ukupan broj naručenih
proizvoda, te srednju vrijednost naručenih proizvoda.
*/
use NORTHWND
go

select
	MAX(Quantity),
	MIN(Quantity),
	COUNT(OrderID),
	SUM(Quantity),
	SUM(Quantity*UnitPrice)/SUM(Quantity)
from	
	[Order Details]

/*
Iz tabele Order Details u bazi Northwind prikazati narudžbe
sa najmanjom i najvećom ukupnom novčanom vrijednošću.*/

select * from (
SELECT top 1
	OrderID,
	SUM(Quantity*UnitPrice) 'Total Price',
	'Narudzba sa maximalnom ukupnom cijenom' as 'Status'
FROM
	[Order Details] 
GROUP BY OrderID
ORDER BY [Total Price] desc ) as TotalMax
union 
select * from (
SELECT top 1
	OrderID,
	SUM(Quantity*UnitPrice) 'Total Price',
	'Narudzba sa minimalnom ukupnom cijenom' as 'Status'
FROM
	[Order Details] 
GROUP BY OrderID
ORDER BY [Total Price] asc ) as TotalMin


SELECT
	OD.OrderID,
	SUM(OD.Quantity*OD.UnitPrice) 'Total'
FROM
	[Order Details] as OD
GROUP BY OD.OrderID
HAVING
SUM(OD.Quantity*OD.UnitPrice)=
	(SELECT 
		MAX(Total) 'TotalMax'
	FROM (
	SELECT
		OrderID,
		SUM(UnitPrice*Quantity) 'Total'
	FROM
		[Order Details]
	GROUP BY OrderID) AS Total) OR 
SUM(OD.Quantity*OD.UnitPrice)=
	(SELECT 
		MIN(Total) 'TotalMin'
	FROM (
	SELECT
		OrderID,
		SUM(UnitPrice*Quantity) 'Total'
	FROM
		[Order Details]
	GROUP BY OrderID) AS Total)




/*
Iz tabele Order Details u bazi Northwind prikazati broj narudžbi sa
odobrenim popustom.
*/
select count(*) as 'Broj narudžbi sa odobrenim popustom' from (
SELECT
	OrderID,
	SUM(Discount) 'Discount sum'
FROM
	[Order Details]
GROUP BY OrderID
HAVING SUM(Discount)>0 ) as narudzbe


/*
Iz tabele Orders u bazi Northwind prikazati trošak prevoza ako je veći od
20000 za robu koja se kupila u Francuskoj, Njemačkoj ili Švicarskoj.
Rezultate prikazati po državama.
*/

SELECT
	ShipCountry,
	SUM(Freight) 'Ukupni trošak'
FROM
	Orders
WHERE ShipCountry in ('Germany','France','Switzerland')
GROUP BY ShipCountry
HAVING SUM(Freight) > 20000


/*
Iz tabele Orders u bazi Northwind prikazati sve kupce po ID-u kod
kojih ukupni troškovi prevoza nisu prešli 7500 pri čemu se 
rezultat treba sortirati opadajućim redoslijedom po
visini troškova prevoza.
*/

SELECT
	CustomerID,
	SUM(Freight) as 'Ukupni trošak'
FROM
	Orders
GROUP BY CustomerID
HAVING SUM(Freight)<=7500
ORDER BY [Ukupni trošak] DESC


