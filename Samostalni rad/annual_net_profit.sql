use AdventureWorks2014
go

select * from Production.ProductSubcategory
go

create view VW_ZaradaPoGodinama_Frames as
select distinct
	YEAR(SOH.OrderDate) 'Godina',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=12)))			AND YEAR(OrderDate)=2011))),0) 'Mountain Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=14)))			AND YEAR(OrderDate)=2011))),0) 'Road Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=16)))			AND YEAR(OrderDate)=2011))),0) 'Touring Frames'
from
	AdventureWorks2014.Sales.SalesOrderHeader AS SOH 
WHERE YEAR(SOH.OrderDate)=2011
union
select distinct
	YEAR(SOH.OrderDate) 'Godina',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=12)))			AND YEAR(OrderDate)=2012))),0) 'Mountain Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=14)))			AND YEAR(OrderDate)=2012))),0) 'Road Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=16)))			AND YEAR(OrderDate)=2012))),0) 'Touring Frames'
from
	AdventureWorks2014.Sales.SalesOrderHeader AS SOH 
WHERE YEAR(SOH.OrderDate)=2012
union
select distinct
	YEAR(SOH.OrderDate) 'Godina',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=12)))			AND YEAR(OrderDate)=2013))),0) 'Mountain Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=14)))			AND YEAR(OrderDate)=2013))),0) 'Road Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=16)))			AND YEAR(OrderDate)=2013))),0) 'Touring Frames'
from
	AdventureWorks2014.Sales.SalesOrderHeader AS SOH 
WHERE YEAR(SOH.OrderDate)=2013
union
select distinct
	YEAR(SOH.OrderDate) 'Godina',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=12)))			AND YEAR(OrderDate)=2014))),0) 'Mountain Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=14)))			AND YEAR(OrderDate)=2014))),0) 'Road Frames',
	isnull((SELECT SUM(UnitPrice*OrderQty) FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE SalesOrderID
		IN(
			(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderHeader WHERE SalesOrderID
				IN(
					(SELECT SalesOrderID FROM AdventureWorks2014.Sales.SalesOrderDetail WHERE ProductID
						IN (SELECT ProductID FROM AdventureWorks2014.Production.Product WHERE ProductSubcategoryID=16)))			AND YEAR(OrderDate)=2014))),0) 'Touring Frames'
from
	AdventureWorks2014.Sales.SalesOrderHeader AS SOH 
WHERE YEAR(SOH.OrderDate)=2014
go

set statistics time on
select * from VW_ZaradaPoGodinama_Frames
set statistics time off



















