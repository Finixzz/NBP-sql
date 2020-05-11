use NORTHWND
go


/*
Koristeći tabele Employees, EmployeeTerritories, Territories i Region baze Northwind kreirati pogled view_Employee koji će sadržavati prezime i ime uposlenika kao polje ime i prezime, teritoriju i regiju koju pokrivaju. Uslov je da su stariji od 30 godina i pokrivaju regiju Western.
*/
create view VW_Employee_Teritory as
select
	E.FirstName+' '+E.LastName 'Ime prezime',
	T.TerritoryDescription,
	R.RegionDescription
from
	Employees as E inner join EmployeeTerritories as ET
		ON E.EmployeeID=ET.EmployeeID
	inner join Territories as T
		ON T.TerritoryID=ET.TerritoryID
	inner join Region AS R	
		ON R.RegionID=T.RegionID
WHERE R.RegionDescription='Western' and DATEDIFF(year,E.BirthDate,getdate())>30
go

select * from VW_Employee_Teritory
go

/*
Koristeći tabele Employee, Order Details i Orders baze Northwind kreirati pogled view_Employee2 koji će sadržavati ime uposlenika i sumu vrijednosti svih narudžbi koje je taj uposlenik napravio u 1996. godini ako je suma vrijednost veća od 5000, pri čemu će se rezultati sortirati uzlaznim redoslijedom prema polju ime.
*/
create view VW_Employee_Total AS
select top 100 percent
	E.FirstName,
	round(SUM(OD.UnitPrice*OD.Quantity-(OD.UnitPrice*OD.Quantity*OD.Discount)),2) 'Ukupno'
from
	Employees as E inner join Orders as O
		on E.EmployeeID=O.EmployeeID
	inner join [Order Details] as OD
		on O.OrderID=OD.OrderID
where YEAR(O.OrderDate)=1996
GROUP BY E.FirstName
having
	SUM(OD.UnitPrice*OD.Quantity-(OD.UnitPrice*OD.Quantity*OD.Discount))>5000
order by E.FirstName
go

select * from VW_Employee_Total
GO

/*
Koristeći tabele Orders i Order Details kreirati pogled koji će sadržavati polja: Orders.EmployeeID, [Order Details].ProductID i suma po UnitPrice.
*/
create view VW_Employee_Products_SumOfUnitPrice as
select 
	O.EmployeeID,
	OD.ProductID,
	SUM(OD.UnitPrice) 'Total'
from
	Orders as O inner join [Order Details] as OD
		ON O.OrderID=OD.OrderID
group by O.EmployeeID,
	OD.ProductID
go

select * from VW_Employee_Products_SumOfUnitPrice order by EmployeeID
go

/*
Koristeći prethodno kreirani pogled izvršiti ukupno sumiranje po uposlenicima. Sortirati po ID uposlenika.
*/
select 
	EmployeeID,
	SUM(Total) as Total
from
	VW_Employee_Products_SumOfUnitPrice
group by EmployeeID
order by EmployeeID
go

select * from VW_Employee_SumOfUnitPriceByEmployee
go

/*
Koristeći tabele Categories, Products i Suppliers kreirati pogled koji će sadržavati polja: CategoryName, ProductName i CompanyName. 
*/

create view VW_CategoriesAndProducts_FromSupplier as
select
	C.CategoryName,
	P.ProductName,
	S.CompanyName
from
	Categories as C inner join Products as P 
		on C.CategoryID=P.CategoryID
	inner join Suppliers as S 
		on S.SupplierID=P.SupplierID
go

select * from VW_CategoriesAndProducts_FromSupplier
go


/*
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kompanijama. Sortirati po nazivu kompanije.
*/
select
	CompanyName,
	CategoryName,
	COUNT(*) 'Broj proizvoda'
from
	VW_CategoriesAndProducts_FromSupplier
group by CompanyName,CategoryName
order by 2 desc
go

/*
Koristeći prethodno kreirani pogled prebrojati broj proizvoda po kategorijama. Sortirati po nazivu kategorije.
*/
select
	CategoryName,
	COUNT(*) 'Broj proizvoda'
from
	VW_CategoriesAndProducts_FromSupplier
group by CategoryName
order by 2 desc
go


/*
Koristeći bazu Northwind kreirati pogled view_supp_ship koji će sadržavati polja: Suppliers.CompanyName, Suppliers.City i Shippers.CompanyName. 
*/

create view  VW_Suppliers_Shippers as
select 
	S.CompanyName 'Supplier Company Name',
	S.City,
	SHIP.CompanyName 'Shipper Company Name'
from
	Suppliers as S inner join Products as P 
		on S.SupplierID=P.SupplierID
	inner join [Order Details] as OD
		ON P.ProductID=OD.ProductID
	inner join Orders as O
		on O.OrderID=OD.OrderID
	inner join Shippers as SHIP
		on SHIP.ShipperID=O.ShipVia
go

select * from VW_Suppliers_Shippers
go


/*
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj kompanija po prevoznicima.
*/
select
	[Shipper Company Name],
	COUNT(*) 'Broj kompanija po prevoznicima'
from
	VW_Suppliers_Shippers
group by [Shipper Company Name]
go

/*
Koristeći pogled view_supp_ship kreirati upit kojim će se prebrojati broj prevoznika po kompanijama. Uslov je da se prikažu one kompanije koje su imale ili ukupan broj prevoza manji od 30 ili veći od 150. Upit treba da sadrži naziv kompanije, prebrojani broj prevoza i napomenu "nizak promet" za kompanije ispod 30 prevoza, odnosno, "visok promet" za kompanije preko 150 prevoza. Sortirati prema vrijednosti ukupnog broja prevoza.
*/

select 
	[Supplier Company Name],
	COUNT(*) 'Broj prevoza',
	IIF(COUNT(*)<30,'Nizak promet','Visok promet') 'Napomena'
from
	VW_Suppliers_Shippers
GROUP BY [Supplier Company Name]
HAVING COUNT(*)<30 OR COUNT(*)>150
order by 2 


/*
Koristeći tabele Products i Order Details kreirati pogled view_prod_price koji će sadržavati naziv proizvoda i sve različite cijene po kojima se prodavao. 
*/
go
create view VW_PriceOfSoldProducts as
select distinct 
	P.ProductName,
	OD.UnitPrice
from
	Products as P inner join [Order Details] as OD
		ON P.ProductID=OD.ProductID
go

select * from VW_PriceOfSoldProducts
go


/*
Koristeći pogled view_prod_price dati pregled srednjih vrijednosti cijena proizvoda.
*/
select
	ProductName,
	AVG(UnitPrice) 'Srednja cijena'
from
	VW_PriceOfSoldProducts
group by ProductName
go
/*
Koristeći tabele Orders i Order Details kreirati pogled view_ord_quan koji će sadržavati ID uposlenika i vrijednosti količina bez ponavljanja koje je isporučio pojedini uposlenik.
*/
create view view_ord_quan as
select distinct
	O.EmployeeID,
	OD.Quantity
from
	Orders as O inner join [Order Details] as OD
		ON O.OrderID=OD.OrderID
go

select * from view_ord_quan order by EmployeeID
go

/*
Koristeći pogled view_ord_quan dati pregled srednjih vrijednosti količina po uposlenicima proizvoda.
*/
select
	EmployeeID, AVG(Quantity) 'AVG'
from
	view_ord_quan
group by EmployeeID
