create database radna
go
use radna
go

/*
Kreirati tabele UposlenikZDK i UposlenikHNK u koje će prosljeđivati podatke pogled view_part_UposlenikKantoni. Obje tabele će sadržavati polja UposlenikID (int), Kanton (int), NacionalniID - nvarchar (20), LoginID - nvarchar (20), RadnoMjesto - nvarchar (20). Sva polja su obavezan unos. Tabela UposlenikZDK će se označiti brojem 1, a tabela UposlenikHNK brojem 2. Primarni ključ je kompozitni i sastoji se od kolona UposlenikID i Kanton.
*/

create table UposlenikZDK 
(
	UposlenikID int not null,
	Kanton int not null constraint CK_UposlenikZDKKantonDefault  check (Kanton=1),
	NacionalniID nvarchar(20) not null,
	LoginID nvarchar(20) not null,
	RadnoMjesto nvarchar(20) not null,
	constraint PK_UposlenikZDK primary key(UposlenikID,Kanton)
)
GO

create table UposlenikHNK 
(
	UposlenikID int not null,
	Kanton int not null constraint CK_UposlenikHNKKantonDefault  check (Kanton=2),
	NacionalniID nvarchar(20) not null,
	LoginID nvarchar(20) not null,
	RadnoMjesto nvarchar(20) not null,
	constraint PK_UposlenikHNK primary key(UposlenikID,Kanton)
)
GO

/*
Kreirati dijeljeni pogled (partitioned view) view_part_UposlenikKantoni koji će podatke koji se unose u njega distribuirati u tabele UposlenikZDK i UposlenikHNK. Nakon kreiranja u pogled ubaciti 4 podatka, po dva za svaku od tabela. (Tabela UposlenikZDK ima oznaku 1, a UposlenikHNK oznaku 2).
*/
go
create view view_part_UposlenikKanton as
select
	UposlenikID,Kanton,NacionalniID,LoginID,RadnoMjesto
from
	UposlenikZDK
union all
select
	UposlenikID,Kanton,NacionalniID,LoginID,RadnoMjesto
from
	UposlenikHNK
go

create proc USP_UposlenikKanton 
(
	@id int,
	@kanton int,
	@nacionalniID nvarchar(20),
	@loginID nvarchar(20),
	@radnoMjesto nvarchar(20)
)as
IF @kanton=1
	BEGIN
		INSERT INTO UposlenikZDK values(@id,@kanton,@nacionalniID,@loginID,@radnoMjesto)
	END
ELSE IF @kanton=2
	BEGIN 
		INSERT INTO UposlenikHNK values(@id,@kanton,@nacionalniID,@loginID,@radnoMjesto)
	END
go


insert into view_part_UposlenikKanton values(10,1,'ZDK1','Ze1','domacin_zdk_1')
insert into view_part_UposlenikKanton values(11,1,'ZDK1','Ze1','domacin_zdk_1')
insert into view_part_UposlenikKanton values(100,2,'HNK1','Mo1','domacin_hnk_1')
insert into view_part_UposlenikKanton values(101,2,'HNK1','Mo2','domacin_hnk_2')


exec USP_UposlenikKanton 10,1,'ZDK1','Ze1','domacin_zdk_1'
exec USP_UposlenikKanton 11,1,'ZDK1','Ze1','domacin_zdk_1'
exec USP_UposlenikKanton 100,2,'HNK1','Mo1','domacin_hnk_1'
exec USP_UposlenikKanton 101,2,'HNK1','Mo2','domacin_hnk_2'

select * from view_part_UposlenikKanton
select * from UposlenikZDK
select * from UposlenikHNK

/*
Kreirati tabele Kvartal1 i Kvatal2 koje će formirati pogled view_part_ProdajaKvartali. Obje tabele će sadržavati polja ProdajaID (int), NazivKupca nvarchar (20), Kvartal (int). Sva polja su obavezan unos. Tabela Kvartal1 će se označiti brojem 1, a tabela Kvartal2 brojem 2. Primarni ključ je kompozitni i sastoji se od kolona ProdajaID i Kvartal.
Kreirati dijeljeni pogled (partitioned view) view_part_ProdajaKvartali koji će podatke koji se unose u njega distribuirati u tabele Kvartal1 i Kvartal. Unijeti po 2 zapisa u tabele preko kreiranog viewa*/
create table Kvartal1
(
	ProdajaID int not null,
	NazivKupca nvarchar(20) not null,
	Kvartal int not null constraint CK_K1 check (Kvartal=1),
	constraint PK_K1 primary key(ProdajaID,Kvartal)
)
go

create table Kvartal2
(
	ProdajaID int not null,
	NazivKupca nvarchar(20) not null,
	Kvartal int not null constraint CK_K2 check (Kvartal=2),
	constraint PK_K2 primary key(ProdajaID,Kvartal)
)
go

create view view_part_ProdajaKvartali as
select
	ProdajaID,NazivKupca,Kvartal
from
	Kvartal1
union  all
select
	ProdajaID,NazivKupca,Kvartal
from
	Kvartal2
go

insert into view_part_ProdajaKvartali values(1,'Kupac1',1),(2,'Kupac1',1),(100,'Kupac2',2),(101,'Kupac2',2)

select * from Kvartal1
select * from Kvartal2
select * from view_part_ProdajaKvartali


/*
Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person baze AdventureWorks2014 kojom će se dati prikaz polja BusinessEntityID, FirstName i LastName, BirthDate.
*/
use AdventureWorks2014
go

create proc USP_Emp_Per as
begin
	select
		E.BusinessEntityID,
		P.FirstName,
		P.LastName,
		E.BirthDate
	from
		Person.Person as P inner join HumanResources.Employee as E
			on P.BusinessEntityID=E.BusinessEntityID
end
go

exec USP_Emp_Per
go

drop proc USP_Emp_Per
GO

/*
Kreirati proceduru nad tabelama HumanResources.Employee i Person.Person kojom će se definirati sljedeći ulazni parametri: EmployeeID, FirstName, LastName, Gender. 
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za sljedeće vrijednosti parametara:
1. EmployeeID = 20, 
2. LastName = Miller
3. LastName = Abercrombie, Gender = M 
*/
create proc USP_GetEmployeesByIdFnameOrLname 
(
	@id int=null,
	@lname nvarchar(50)=null,
	@fname nvarchar(50)=null,
	@gender char(1)=null
) as
begin
	set nocount on;
	select
		E.BusinessEntityID,
		P.FirstName,
		P.LastName,
		E.Gender
	from
		Person.Person as P inner join HumanResources.Employee as E
			on P.BusinessEntityID=E.BusinessEntityID
	where E.BusinessEntityID=@id or P.FirstName=@fname or P.LastName=@lname	or E.Gender=@gender
end
go

exec USP_GetEmployeesByIdFnameOrLname @id=20
exec USP_GetEmployeesByIdFnameOrLname @lname='Miller'
exec USP_GetEmployeesByIdFnameOrLname @lname='Abercrombie',@gender='M'


/*
Proceduru HumanResources.proc_EmployeesParameters koja je kreirana nad tabelama HumanResources.Employee i Person.Person izmijeniti tako da je prilikom izvršavanja moguće unijeti bilo koje vrijednosti za prva tri parametra (možemo ostaviti bilo koje od tih polja bez unijete vrijednosti), a da vrijednost četvrtog parametra bude F, odnosno, izmijeniti tako da se dobija prikaz samo osoba ženskog pola.Nakon izmjene pokrenuti proceduru za sljedeće vrijednosti parametara:
1. EmployeeID = 52, 
2. LastName = Miller
*/
create proc USP_GetFemaleEmployeesByIdFnameOrLname 
(
	@id int=null,
	@lname nvarchar(50)=null,
	@fname nvarchar(50)=null,
	@gender char(1)='F'
) as
begin
	set nocount on;
	select
		E.BusinessEntityID,
		P.FirstName,
		P.LastName,
		E.Gender
	from
		Person.Person as P inner join HumanResources.Employee as E
			on P.BusinessEntityID=E.BusinessEntityID
	where 	 E.Gender=@gender and (E.BusinessEntityID=@id or P.FirstName=@fname or P.LastName=@lname)
end
go

exec USP_GetFemaleEmployeesByIdFnameOrLname @id=52
exec USP_GetFemaleEmployeesByIdFnameOrLname @lname='Miller'

/*
Koristeći tabele Sales.SalesOrderHeader i Sales.SalesOrderDetail kreirati pogled view_promet koji će se sastojati od kolona CustomerID, SalesOrderID, ProductID i proizvoda OrderQty i UnitPrice. 
*/

create view view_promet as
select
	SOH.CustomerID,
	SOH.SalesOrderID,
	SOD.ProductID,
	SOD.OrderQty * SOD.UnitPrice Proizvod
from
	Sales.SalesOrderHeader SOH inner join Sales.SalesOrderDetail SOD
		ON SOH.SalesOrderID=SOD.SalesOrderID
go

/*
Koristeći pogled view_promet kreirati pogled view_promet_cust_ord koji neće sadržavati kolonu ProductID i vršit će sumiranje kolone ukupno.
*/
create view  view_promet_cust_ord as
select
	CustomerID,
	SalesOrderID,
	SUM(Proizvod) 'Ukupno'
from
	view_promet
group by CustomerID,
	SalesOrderID

select * from view_promet_cust_ord

/*
Nad pogledom view_promet_cust_ord kreirati proceduru kojom će se definirati ulazni parametri: CustomerID, SalesOrderID i suma.
Proceduru kreirati tako da je prilikom izvršavanja moguće unijeti bilo koji broj parametara (možemo ostaviti bilo koje polje bez unijetog parametra), te da procedura daje rezultat ako je zadovoljena bilo koja od vrijednosti koje su navedene kao vrijednosti parametara.
Nakon kreiranja pokrenuti proceduru za vrijednost parametra CustomerID = 11019.
Obrisati proceduru, a zatim postaviti uslov da procedura vraća samo one zapise u kojima je suma manja od 100, pa ponovo pokrenuti za istu vrijednost parametra.
*/

alter proc USP_Sumiranje
(
	@customerID int=null,
	@SalesOrderID int=null,
	@suma money=null
)as
begin
	select
		CustomerID,
		SalesOrderID,
		Ukupno
	from
		view_promet_cust_ord
	where
		(CustomerID=@customerID or SalesOrderID=@SalesOrderID or Ukupno=@suma) and Ukupno<100
end
exec USP_Sumiranje @customerID=11019












