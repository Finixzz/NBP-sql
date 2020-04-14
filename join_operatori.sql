﻿/*
INNER JOIN
Rezultat upita su samo oni zapisi u kojima se podudaraju
vrijednosti spojnog polja iz obje tabele.

LEFT OUTER JOIN
Lijevi spoj je inner join kojim su pridodati i oni zapisi koji postoje u "lijevoj" tabeli, ali ne i u "desnoj".
Kod lijevog spoja, na mjestu "povezne" kolone iz desne tabele bit će vraćena vrijednost NULL

RIGHT OUTER JOIN
Desni spoj je inner join kojim su pridodati i oni zapisi koji postoje u "desnoj" tabeli, ali ne i u "lijevoj".
Kod desnog spoja, na mjestu "povezne" kolone iz lijeve tabele bit će vraćena vrijednost NULL

FULL OUTER JOIN
Kod punog spoja obje tabele imaju ulogu „glavne“. 
U rezultatu će se naći svi zapisi iz obje tabele koji
zadovoljavaju uslov, pri čemu će se u zapisima koji nisu
upareni, na mjestu "poveznih" kolona iz obje tabele vratiti
NULL vrijednost.
*/


/*
Iz tabela discount i stores baze pubs prikazati naziv popusta, 
ID i naziv prodavnice
*/
use pubs
go

SELECT
	S.stor_id,
	S.stor_name,
	D.discount
FROM
	stores as S inner join discounts as D
		on S.stor_id=D.stor_id




/*
Iz tabela employee i jobs baze pubs prikazati ID i ime uposlenika
, ID posla i naziv posla koji obavlja
*/

SELECT
	E.emp_id,
	E.fname,
	J.job_id,
	J.job_desc
FROM
	employee as E inner join jobs as J 
		on E.job_id=J.job_id
ORDER BY 1



use prihodi
go
/*
U bazi Prihodi upotrebom:
a) left outer joina prikazati i redovne i vanredne prihode osobe, 
pri čemu će se isključiti zapisi u kojima je ID osobe iz tabele
redovni prihodi NULL vrijednost, a rezultat sortirati u rastućem 
redoslijedu prema ID osobe iz tabele redovni prihodi

*/
select 
	RP.OsobaID,
	RP.RedovniPrihodiID,
	RP.Neto,
	VP.OsobaID,
	VP.VanredniPrihodiID,
	VP.IznosVanrednogPrihoda
from
	Osoba AS O LEFT JOIN VanredniPrihodi as VP
		ON O.OsobaID=VP.OsobaID
	LEFT JOIN RedovniPrihodi AS RP
		ON O.OsobaID=RP.OsobaID
WHERE RP.OsobaID IS NOT NULL
ORDER BY RP.OsobaID


/*
b) right outer joina prikazati i redovne i vanredne prihode osobe,
pri čemu će se isključiti zapisi u kojima je ID osobe iz tabele
redovni prihodi NULL vrijednost, a rezultat sortirati u rastućem
redoslijedu prema ID osobe iz tabele vanredni prihodi*/
select 
	RP.OsobaID,
	RP.RedovniPrihodiID,
	RP.Neto,
	VP.OsobaID,
	VP.VanredniPrihodiID,
	VP.IznosVanrednogPrihoda
from
	Osoba AS O RIGHT JOIN VanredniPrihodi as VP
		ON O.OsobaID=VP.OsobaID
	RIGHT JOIN RedovniPrihodi AS RP
		ON O.OsobaID=RP.OsobaID
WHERE RP.OsobaID IS NOT NULL
ORDER BY VP.OsobaID


/*
c) full outer joina prikazati i redovne i vanredne prihode osobe, a rezultat sortirati u rastućem redoslijedu prema ID osobe iz tabela redovni i vanredni prihodi
U svim slučajevima upit treba da vrati sljedeće kolone:
OsobaID iz obje tabele, RedovniPrihodiID,
Neto, VanredniPrihodiID, IznosVanrednogPrihoda
*/
select 
	RP.OsobaID,
	RP.RedovniPrihodiID,
	RP.Neto,
	VP.OsobaID,
	VP.VanredniPrihodiID,
	VP.IznosVanrednogPrihoda
from
	Osoba AS O FULL JOIN VanredniPrihodi as VP
		ON O.OsobaID=VP.OsobaID
	FULL JOIN RedovniPrihodi AS RP
		ON O.OsobaID=RP.OsobaID
ORDER BY RP.OsobaID,VP.OsobaID



/*
Iz tabela Employees, EmployeeTerritories, Territories i Region
baze Northwind prikazati prezime i ime uposlenika kao 
polje ime i prezime, teritoriju i regiju koju pokrivaju
i stariji su od 30 godina.*/
USE NORTHWND
GO

SELECT
	E.FirstName+ ' ' + E.LastName 'Ime prezime',
	T.TerritoryDescription,
	R.RegionDescription
FROM
	Employees as E inner join EmployeeTerritories as ET
		ON E.EmployeeID=ET.EmployeeID
	inner join Territories as T 
		on ET.TerritoryID=T.TerritoryID
	inner join Region as R 
		on T.RegionID=R.RegionID
WHERE DATEDIFF(YEAR,E.BirthDate,GETDATE())>30

/*
Iz tabela Employee, Order Details i Orders baze Northwind
prikazati ime i prezime uposlenika kao polje ime i prezime,
jediničnu cijenu, količinu i 
ukupnu vrijednost pojedinačne narudžbe kao polje ukupno za
sve narudžbe u 1997. godini, pri čemu će se rezultati 
sortirati prema 
novokreiranom polju ukupno.*/

SELECT
	E.FirstName+ ' ' + E.LastName 'Ime prezime',
	OD.UnitPrice,
	OD.Quantity,
	(SELECT SUM(Quantity*UnitPrice) FROM [Order Details] WHERE OrderID=O.OrderID) 'Ukupno'
FROM
	Employees as E inner join Orders as O 
		on E.EmployeeID=O.EmployeeID
	inner join [Order Details] as OD
		ON O.OrderID=OD.OrderID
WHERE YEAR(O.OrderDate)=1997
ORDER BY Ukupno 
	



/*
Iz tabela Employee, Order Details i Orders baze Northwind 
prikazati ime uposlenika i ukupnu vrijednost svih narudžbi
koje je taj uposlenik 
napravio u 1996. godini ako je ukupna vrijednost veća od 50000,
pri čemu će se rezultati sortirati uzlaznim redoslijedom
prema polju ime. Vrijednost sume zaokružiti na dvije decimale.*/
SELECT
	E.FirstName,
	SUM(Quantity*UnitPrice) 'Ukupna vrijednost svih narudžbi'
FROM
	Employees as E inner join Orders as O 
		on E.EmployeeID=O.EmployeeID
	inner join [Order Details] as OD
		ON O.OrderID=OD.OrderID
WHERE YEAR(O.OrderDate)=1996
GROUP BY E.FirstName
HAVING 	SUM(Quantity*UnitPrice) > 50000

/*
Iz tabela Categories, Products i Suppliers baze Northwind 
prikazati naziv isporučitelja (dobavljača),
mjesto i državu isporučitelja
(dobavljača) i naziv(e) proizvoda iz kategorije napitaka 
(pića) kojih na stanju ima više od 30 jedinica. 
Rezultat upita sortirati po državi.*/
SELECT
	S.ContactName,
	S.City,
	S.Country,
	P.ProductName
FROM
	Products as P inner join Suppliers AS S
		ON P.SupplierID=S.SupplierID
	inner join Categories as C
		on P.CategoryID=C.CategoryID
WHERE P.CategoryID=1 AND P.UnitsInStock>30
ORDER BY Country


/*
U tabeli Customers baze Northwind ID kupca je primarni ključ.
U tabeli Orders baze Northwind ID kupca je vanjski ključ.
Dati izvještaj:
a) koliko je ukupno kupaca evidentirano u obje tabele
(lista bez ponavljanja iz obje tabele)
a.1) koliko je ukupno kupaca evidentirano u obje tabele
b) da li su svi kupci obavili narudžbu
c) koji kupci nisu napravili narudžbu*/

select CustomerID
from Customers
union 
select CustomerID
from Orders

select CustomerID
from Customers
intersect
select CustomerID
from Orders

select CustomerID
from Customers
except
select CustomerID
from Orders


/*
a) Provjeriti u koliko zapisa (slogova) tabele Orders nije unijeta
vrijednost u polje regija kupovine.*/

select distinct
	count(CustomerID)
from
	Orders
WHERE ShipRegion is null



/*
b) Upotrebom tabela Customers i Orders baze Northwind prikazati
ID kupca pri čemu u polje regija kupovine nije unijeta vrijednost,
uz uslov da je kupac obavio narudžbu (kupac iz tabele Customers
postoji u tabeli Orders). Rezultat sortirati u rastućem
redoslijedu.*/

SELECT	
	CustomerID
FROM
	Customers
intersect
SELECT	
	CustomerID
FROM
	Orders
WHERE ShipRegion is null


/*
c) Upotrebom tabela Customers i Orders baze Northwind prikazati
ID kupca pri čemu u polje regija kupovine nije unijeta vrijednost 
i kupac nije obavio ni jednu narudžbu (kupac iz tabele Customers
ne postoji u tabeli Orders).
Rezultat sortirati u rastućem redoslijedu.*/
SELECT
	CustomerID
FROM Customers
except
SELECT
	CustomerID
FROM Orders
WHERE ShipRegion is null



/*
Iz tabele HumanResources.Employee baze AdventureWorks2014
prikazati po 5 najstarijih zaposlenika muškog, 
odnosno, ženskog pola uz navođenje sljedećih podataka: 
radno mjesto na kojem se nalazi, datum rođenja, 
korisnicko ime i godine starosti. Korisničko ime je dio
podatka u LoginID. Rezultate sortirati prema polu 
uzlaznim, a zatim prema godinama starosti silaznim redoslijedom.*/
USE AdventureWorks2014 
GO


SELECT * FROM(
	SELECT TOP 5
		JobTitle,
		BirthDate,
		SUBSTRING(LoginID,CHARINDEX('\',LoginID)+1,LEN(LoginID)) 'Username',
		Gender,
		DATEDIFF(YEAR,BirthDate,GETDATE()) 'Starost'
	FROM
		HumanResources.Employee 
	WHERE Gender='M'
	ORDER BY Starost DESC
	UNION 
	SELECT TOP 5
		JobTitle,
		BirthDate,
		SUBSTRING(LoginID,CHARINDEX('\',LoginID)+1,LEN(LoginID)) 'Username',
		Gender,
		DATEDIFF(YEAR,BirthDate,GETDATE()) 'Starost'
	FROM
		HumanResources.Employee
	WHERE Gender='F'
	ORDER BY Starost DESC) AS Uposlenici
ORDER BY Uposlenici.Gender,Uposlenici.Starost DESC



/*
Iz tabele HumanResources.Employee baze AdventureWorks2014 
prikazati po 3 zaposlenika sa najdužim stažom 
bez obzira da li su u braku i obavljaju poslove inžinjera uz
navođenje sljedećih podataka: 
radno mjesto na kojem se nalazi, datum zaposlenja
i bračni status. Ako osoba nije u braku plaća dodatni porez,
inače ne plaća. Rezultate sortirati prema bračnom statusu 
uzlaznim, a zatim prema stažu silaznim redoslijedom.*/


SELECT
	*,
	iif(Uposlenici.MaritalStatus='M','Ne plaća dodatni porez','Plaća dodatni porez') 'Status'
	FROM(
		SELECT TOP 3
			SUBSTRING(E.LoginID,CHARINDEX('\',E.LoginID)+1,LEN(E.LoginID)) 'Username',
			E.JobTitle,
			E.HireDate,
			E.MaritalStatus
		FROM
			HumanResources.Employee AS E
		WHERE E.JobTitle LIKE '%Engin%' AND E.MaritalStatus='M'
		ORDER BY E.HireDate ASC
		UNION
		SELECT TOP 3
			SUBSTRING(E.LoginID,CHARINDEX('\',E.LoginID)+1,LEN(E.LoginID)) 'Username',
			E.JobTitle,
			E.HireDate,
			E.MaritalStatus
		FROM
			HumanResources.Employee AS E
		WHERE E.JobTitle LIKE '%Engin%' AND E.MaritalStatus='S'
		ORDER BY E.HireDate ASC) Uposlenici
ORDER BY Uposlenici.MaritalStatus,Uposlenici.HireDate desc



/*
Iz tabela HumanResources.Employee i Person.Person prikazati po 5 osoba koje se nalaze na 1, odnosno, 
4.  organizacionom nivou, uposlenici su i žele primati email ponude od AdventureWorksa uz navođenje 
sljedećih polja: ime i prezime osobe kao jedinstveno polje, organizacijski nivo na kojem se nalazi i da li prima email promocije.
Pored ovih uvesti i polje koje će sadržavati poruke: Ne prima, Prima selektirane i Prima.
Sadržaj novog polja ovisi o vrijednosti polja EmailPromotion.
Rezultat sortirati prema organizacijskom nivou i dodatno uvedenom polju.*/

SELECT
	*,
	CASE
		WHEN Uposlenici.EmailPromotion = 0 THEN 'Ne prima'
		WHEN Uposlenici.EmailPromotion = 1 THEN 'Prima'
		WHEN Uposlenici.EmailPromotion = 2 THEN 'Prima selektirane'
	END 'Status'
FROM(
		SELECT TOP 5
			P.FirstName+' '+P.LastName 'Ime prezime ',
			E.OrganizationLevel,
			P.EmailPromotion
		FROM
			HumanResources.Employee AS E INNER JOIN Person.Person as P
				ON E.BusinessEntityID=P.BusinessEntityID
		WHERE E.OrganizationLevel =1
		ORDER BY E.OrganizationLevel
		UNION
		SELECT TOP 5
			P.FirstName+' '+P.LastName 'Ime prezime ',
			E.OrganizationLevel,
			P.EmailPromotion
		FROM
			HumanResources.Employee AS E INNER JOIN Person.Person as P
				ON E.BusinessEntityID=P.BusinessEntityID
		WHERE E.OrganizationLevel =4
		ORDER BY E.OrganizationLevel) Uposlenici
ORDER BY Uposlenici.OrganizationLevel,Status


/*
Iz tabela Sales.SalesOrderDetail i Production.Product prikazati 10 najskupljih stavki prodaje uz
navođenje polja: naziv proizvoda, količina, cijena i iznos. Cijenu i iznos zaokružiti na dvije decimale.
Iz naziva proizvoda odstraniti posljednji dio koji sadržava cifre i zarez.
U rezultatu u polju količina na broj dodati 'kom.', a u polju cijena i iznos na broj dodati 'KM'.*/
USE AdventureWorks2014
GO

SELECT TOP 10
	SUBSTRING(P.Name,1,LEN(P.Name)-4) 'Ime proizvoda',
	CONVERT(NVARCHAR(5),SOD.OrderQty)+' kom.' 'Kolicina',
	CONVERT(NVARCHAR(15),SOD.UnitPrice)+' KM' 'UnitPrice',
	CONVERT(NVARCHAR(15),SOD.OrderQty*SOD.UnitPrice)+' KM' 'Iznos'
FROM
	Sales.SalesOrderDetail as SOD INNER JOIN Production.Product as P
		ON P.ProductID=SOD.ProductID
ORDER BY SOD.OrderQty*SOD.UnitPrice desc

