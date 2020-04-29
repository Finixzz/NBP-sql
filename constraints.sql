use AdventureWorks2014
go
/*
a) U okviru baze AdventureWorks kopirati tabele Sales.Store, Sales.Customer, Sales.SalesTerritoryHistory i Sales.SalesPerson u tabele istih naziva a koje će biti u šemi vjezba. Nakon kopiranja u novim tabelama definirati iste PK i FK kojima su definirani odnosi među tabelama.
*/

create schema vjezba

select * into vjezba.Store
from Sales.Store

select * from vjezba.Store

select * into vjezba.Customer
from Sales.Customer

select * into vjezba.SalesTerritoryHistory
from Sales.SalesTerritoryHistory


select * into vjezba.SalesPerson
from Sales.SalesPerson

alter table vjezba.Customer add constraint PK_Customer primary key(CustomerID)

alter table vjezba.SalesPerson add constraint PK_SalesPerson primary key(BusinessEntityID)

alter table vjezba.SalesTerritoryHistory add constraint PK_SalesTerritoryHistory primary key(BusinessEntityID,TerritoryID,StartDate)

alter table vjezba.Store add constraint PK_Store primary key(BusinessEntityID)


alter table vjezba.Store add constraint FK_Store foreign key (SalesPersonID) references vjezba.SalesPerson(BusinessEntityID)

alter table vjezba.Customer add constraint FK_Customer_Store foreign key (StoreID) references vjezba.Store(BusinessEntityID)

alter table vjezba.SalesTerritoryHistory add constraint FK_SalesTerritoryHistory_SalesPerson foreign key(BusinessEntityID) references vjezba.SalesPerson (BusineSsEntityID)

/*
b) Dodati tabele u dijagram
*/

/*
b) Definirati sljedeća ograničenja (prva dva samo za tabele Customer i SalesPerson): 
	1. ModifiedDate kolone -					defaultna vrijednost je aktivni datum
	2. rowguid -								defaultna vrijednost slučajno generisani niz znakova
	3. SalesQuota u tabeli SalesPerson -		defaultna vrijednost 0.00
												zabrana unosa vrijednosti manjih od 0.00
	4. EndDate u tabeli SalesTerritoryHistory - zabrana unosa starijeg datuma od StartDate
*/

alter table vjezba.Customer 
add constraint DF_ModifiedDate default (getdate()) for ModifiedDate

alter table vjezba.Customer add constraint DF_rowguid default (newid()) for rowguid

alter table vjezba.SalesPerson
add constraint DF_ModifiedDate_s default (getdate()) for ModifiedDate

alter table vjezba.SalesPerson add constraint DF_rowguid_s default (newid()) for rowguid

alter table vjezba.SalesPerson add constraint DF_SalesQuota default(0.00) for SalesQuota

alter table vjezba.SalesPerson add constraint CK_SalesQuota check (SalesQuota>=0.00)

alter table vjezba.SalesTerritoryHistory add constraint  CK_EndDate check (EndDate>=StartDate)


/*
U tabeli Customer:
a) dodati stalno pohranjenu kolonu godina koja će preuzimati godinu iz kolone ModifiedDate
*/

alter table vjezba.Customer add godina as year(ModifiedDate)


/*
b) ograničiti dužinu kolone rowguid na 10 znakova, a zatim postaviti defaultnu vrijednost na 10 slučajno generisanih znakova
*/

alter table vjezba.Customer drop constraint DF_rowguid

alter table vjezba.Customer alter column rowguid char(40)

update vjezba.Customer
set rowguid=left(rowguid,10)

alter table vjezba.Customer add constraint DF_rowguid default left(newid(),10) for rowguid

/*
c) obrisati PK tabele Customer, a zatim definirati kolonu istog naziva koja će biti PK identity sa početnom vrijednošću 1 i inkrementom 2
*/
alter table vjezba.Customer drop constraint PK_Customer

alter table vjezba.Customer drop column CustomerID

alter table vjezba.Customer add CustomerID int not null constraint PK_Customer primary key identity(1,2)

select * from vjezba.Customer

/*
d) izvršiti insert podataka iz tabele Sales.Customer sa očuvanjem identity karaktera kolone CustomerID
*/

insert into vjezba.Customer (PersonID,StoreID,TerritoryID,AccountNumber,rowguid)
select
	PersonID,StoreID,TerritoryID,AccountNumber,left(rowguid,10)
from
	Sales.Customer

delete from vjezba.Customer

/*
e) kreirati upit za prikaz zapisa u kojima je StoreID veći od 500, a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
*/
SET STATISTICS TIME ON 
GO 
select
	*
from
	vjezba.Customer
where StoreID>500
SET STATISTICS TIME OFF  
GO 

select * from vjezba.Store


/*
f) nad kolonom StoreID kreirati nonclustered indeks, a zatim pokrenuti upit sa uključenim vremenom i planom izvršavanja
*/


create nonclustered index IX_Customer_Store on vjezba.Customer(StoreID)



