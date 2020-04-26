﻿--NORTHWND
/*
Koristeći tabele Orders i Order Details kreirati upit koji će dati sumu količina po Order ID, pri čemu je uslov:
a) da je vrijednost Freighta veća od bilo koje vrijednosti Freighta narudžbi realiziranih u 12. mjesecu 1997. godine
b) da je vrijednost Freighta veća od svih vrijednosti Freighta narudžbi realiziranih u 12. mjesecu 1997. godine
*/
use NORTHWND
go

select
	O.OrderID,
	(SELECT SUM(Quantity) FROM [Order Details] WHERE OrderID=O.OrderID) 'Suma kolicine',
	O.Freight,
	(SELECT MIN(Freight) FROM Orders WHERE YEAR(OrderDate)=1997 AND MONTH(OrderDate)=12) 'MIN Freight'
from
	Orders as O
WHERE Freight>(SELECT MIN(Freight) FROM Orders WHERE YEAR(OrderDate)=1997 AND MONTH(OrderDate)=12)

select
	O.OrderID,
	(SELECT SUM(Quantity) FROM [Order Details] WHERE OrderID=O.OrderID) 'Suma kolicine',
	O.Freight,
	(SELECT MAX(Freight) FROM Orders WHERE YEAR(OrderDate)=1997 AND MONTH(OrderDate)=12) 'MAX Freight'
from
	Orders as O
WHERE Freight>(SELECT MAX(Freight) FROM Orders WHERE YEAR(OrderDate)=1997 AND MONTH(OrderDate)=12)


--AdventureWorks2014
/*
Koristeći tabele Production.Product i Production.WorkOrder kreirati upit sa podupitom koji će dati sumu OrderQty po nazivu proizvoda. pri čemu se izostavljaju zapisi u kojima je suma NULL vrijednost. Upit treba da sadrži naziv proizvoda i sumu po nazivu.
*/
use AdventureWorks2014
go

SELECT
	P.Name,
	(SELECT SUM(OrderQty) FROM Production.WorkOrder WHERE ProductID=P.ProductID) 'Suma kolicine'
FROM
	Production.Product as P 
WHERE (SELECT SUM(OrderQty) FROM Production.WorkOrder WHERE ProductID=P.ProductID)  is not null
ORDER BY [Suma kolicine]

SELECT
	P.Name,
	SUM(WO.OrderQty) 'Suma kolicine'
FROM
	Production.Product as P INNER JOIN Production.WorkOrder as WO
		ON P.ProductID=WO.ProductID
GROUP BY P.Name
ORDER BY [Suma kolicine]

/*
Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail kreirati upit sa podupitom koji će prebrojati CarrierTrackingNumber po SalesOrderID, pri čemu se izostavljaju zapisi čiji AccountNumber ne spada u klasu 10-4030. Upit treba da sadrži SalesOrderID i prebrojani broj.
*/
SELECT
	SOH.SalesOrderID,
	(SELECT COUNT(CarrierTrackingNumber) FROM Sales.SalesOrderDetail WHERE SalesOrderID=SOH.SalesOrderID) 'Count of CarrierTrackingNumber',
	SOH.AccountNumber
FROM
	Sales.SalesOrderHeader as SOH
WHERE SOH.AccountNumber NOT LIKE '%10-4030%'
ORDER BY 1,2,3


/*
Koristeći tabele Sales.SpecialOfferProduct i Sales.SpecialOffer kreirati upit sa podupitom koji će prebrojati broj proizvoda po kategorijama koji su u 2014. godini bili na specijalnoj ponudi pri čemu se izostavljaju one kategorije kod kojih ne postoji ni jedan proizvod koji nije bio na specijalnoj ponudi.
*/


select distinct
	so.Category,
	(SELECT COUNT(ProductID) FROM Sales.SpecialOfferProduct WHERE SpecialOfferID=SO.SpecialOfferID)
from
	Sales.SpecialOffer as SO inner join Sales.SpecialOfferProduct as SPO
		ON SO.SpecialOfferID=SPO.SpecialOfferID
where year(SPO.ModifiedDate)=2014



--JOIN
--AdventureWorks2014
/*
Koristeći tabele Person.Address, Sales.SalesOrderDetail i Sales.SalesOrderHeader kreirati upit koji će dati sumu naručenih količina po gradu i godini isporuke koje su izvršene poslije 2012. godine.
*/
SELECT
	P.City,
	year(SOH.ShipDate) 'Godina',
	SUM(SOD.OrderQty) 'Suma kolicina'
FROM
	Person.Address as P inner join Sales.SalesOrderHeader as SOH
		ON P.AddressID=SOH.ShipToAddressID
	inner join Sales.SalesOrderDetail as SOD
		ON SOH.SalesOrderID=SOD.SalesOrderID
WHERE Year(SOH.ShipDate)>2012
group by P.City,
	year(SOH.ShipDate)
ORDER BY 2,3

	

/*
Koristeći tabele Sales.Store, Sales.SalesPerson i SalesPersonQuotaHistory kreirati upit koji će dati sumu prodajnih kvota po nazivima prodavnica i ID teritorija, ali samo onih čija je suma veća od 2000000. Sortirati po ID teritorije i sumi.
*/

SELECT
	S.Name,
	SP.TerritoryID,
	SUM(SPQ.SalesQuota) 'Sum of sales quota'
FROM
	Sales.Store as S inner join Sales.SalesPerson as SP
		ON S.SalesPersonID=SP.BusinessEntityID
	inner join Sales.SalesPersonQuotaHistory AS SPQ
		ON SP.BusinessEntityID=SPQ.BusinessEntityID
GROUP BY S.Name, SP.TerritoryID
HAVING SUM(SPQ.SalesQuota)>2000000
ORDER BY 2,3



/*
Koristeći tabele SpecialOfferProduct i SpecialOffer prebrojati broj ponuda po kategorijama popusta od 0 do 15%, pri čemu treba uvesti novu kolonu kategorija u koju će biti unijeta vrijednost popusta, npr. 0, 1, 2... Rezultat sortirati prema koloni kategorija u rastućem redoslijedu. Upit treba da vrati kolone: SpecialOfferID, prebrojani broj i kategorija.
*/


select 
	SO.SpecialOfferID,
	(SELECT COUNT(*) FROM Sales.SpecialOfferProduct WHERE SpecialOfferID=SO.SpecialOfferID) 'Broj ponuda',
	so.DiscountPct * 100 'Kategorija'
from
	Sales.SpecialOffer as SO 
WHERE so.DiscountPct between 0 and 0.15
order by 3


/*
Koristeći tabele Sales.Store i Sales.Customer kreirati upit kojim će se prebrojati koliko kupaca po teritorijama pokriva prodavac. Rezultat sortirati prema prodavcu i teritoriji. 
*/
select
	S.SalesPersonID,
	C.TerritoryID,
	COUNT(*) 'Broj kupaca'
from
	Sales.Store as S inner join Sales.Customer as C
		ON S.BusinessEntityID=C.StoreID
group BY S.SalesPersonID,
	C.TerritoryID
ORDER BY 1,2


/*
Koristeći kolonu AccountNumber tabele Sales.Customer prebrojati broj zapisa prema broju cifara brojčanog dijela podatka iz ove kolone. Rezultat sortirati u rastućem redoslijedu.
*/


SELECT
	len(convert(int,right(AccountNumber,8))) 'Brojevi',
	COUNT(*)
FROM
	Sales.Customer brojevi
group by len(convert(int,right(AccountNumber,8))) 


