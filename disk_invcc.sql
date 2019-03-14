/********************************************************************************************************
*		Name				Date				Description
*
*		Caleb Crownover		02/28/2019			Initial implementation of disk_invcc.
*		Caleb Crownover		03/08/2019			Table modification.
*		Caleb Crownover		03/14/2019			Creating T-SQL queries for database.
*********************************************************************************************************/
use master
go
if DB_ID('disk_inventorycc') is not null
	drop database disk_inventorycc
go
create database disk_inventorycc
go
use disk_inventorycc
go


create table genre
	(
	genre_id		int				not null	identity primary key,
	description		varchar(100)	not null,
	)
go
create table disk_status
	(
	status_id		int				not null	identity primary key,
	description		varchar(100)	not null
	)
go
create table disk_type
	(
	disk_type_id		int				not null	identity primary key,
	description			varchar(100)	not null,
	)
go
create table artist_type
	(
	artist_type_id		int				not null	identity primary key,
	description			varchar(100)	not null
	)
go
create table borrower
	(
	borrower_id		int				not null	identity primary key,
	fname			varchar(100)	not null,
	lname			varchar(100)	not null,
	phone_num		varchar(50)		not null
	)
go
create table artist
	(
	artist_id		int				not null	identity primary key,
	fname			varchar(100)	not null,
	lname			varchar(100)	not null,
	artist_type_id	int				not null	references artist_type(artist_type_id)
	)
go
create table disk
	(
	disk_id			int				not null	identity primary key,
	disk_name		varchar(100)	not null,
	release_date	datetime		not null,
	genre_id		int				not null	references genre(genre_id),
	status_id		int				not null	references disk_status(status_id),
	disk_type_id	int				not null	references disk_type(disk_type_id),
	)
go
create table diskHasBorrower
	(
	disk_id			int				not null	references disk(disk_id),
	borrower_id		int				not null	references borrower(borrower_id),
	borrowed_date	datetime		not null,
	returned_date	datetime		null,
	primary key (disk_id, borrower_id, borrowed_date)
	)
go
create table diskHasArtist
	(
	disk_id			int				not null	references disk(disk_id),
	artist_id		int				not null	references artist(artist_id),
	primary key (disk_id, artist_id)
	)
go

--Create a new user, diskUserXX, using a secure password and grant read permissions to all tables in disk_inventoryXX to diskUserXX

use master
go
if SUSER_ID('diskUsercc') is not null
	DROP login diskUsercc
go
create login diskUsercc with password = 'Pa$$w0rd',
	default_database = disk_inventorycc
go
use disk_inventorycc
go
if USER_ID('diskUsercc') is not null
	drop user diskUsercc
go
create user diskUsercc;
go
ALTER ROLE db_datareader ADD MEMBER diskUsercc
go


-----------------------------------------------------------------------------------------------------------------------------

use disk_inventorycc
go
insert into dbo.artist_type
			([description])
	values
		('Solo')
			,('Band')
go
insert into dbo.disk_status
			([description])
	values
		('Available')
			,('Loaned Out')
			,('Missing')
			,('Damaged')
go
insert into dbo.disk_type
			([description])
	values
		('DVD')
			,('CD')
			,('Cassette')
			,('Vinyl')
go

insert into dbo.genre
			([description])
	values
		('Classical')
			,('Jazz')
			,('Rock')
			,('Pop')
			,('Country')
go

--Artist table:1. Insert at least 20 rows of data into the table
insert into dbo.artist
		([fname], [lname], [artist_type_id])
	values
		('Taylor', 'Swift', 1)
			,('Johnny', 'Cash', 1)
			,('Elvis', 'Presley', 1)
			,('Michael', 'Jackson', 1)
			,('John', 'Coltrane', 1)
			,('Chet', 'Baker', 1)
			,('Wolfgang', 'Mozart', 1)
			,('Ludwig', 'Beethoven', 1)
			,('Johann', 'Bach', 1)
			,('Claude', 'Debussy', 1)
			,('Katy', 'Perry', 1)
			,('Justin', 'Timberlake', 1)
			,('Christina', 'Aguilera', 1)
			,('Billie', 'Holiday', 1)
			,('Bob', 'Dylan', 1)
			,('Elton', 'John', 1)
			,('Louis', 'Armstrong', 1)
			,('Garth', 'Brooks', 1)
			,('Glen', 'Campbell', 1)
			,('Loretta', 'Lynn', 1)

go

--Borrower table: 1. Insert at least 20 rows of data into the table 2. Delete only 1 row using a where clause
insert into dbo.[borrower]--
			([fname], [lname], [phone_num])
	values
		('John', 'Doe', '600-387-8973')
			,('Jane', 'Doe', '367-707-3960')
			,('Jack', 'Doe', '716-516-9292')
			,('Jacob', 'Doe', '733-246-6169')
			,('Janet', 'Doe', '696-643-7507')
			,('Jackie', 'Doe', '482-488-1557')
			,('Jaquelyn', 'Doe', '712-439-2874')
			,('Timothy', 'Doe', '415-523-5251')
			,('Randy', 'Doe', '462-953-9127')
			,('Anthony', 'Doe', '255-903-1730')
			,('Alex', 'Doe', '657-368-0985')
			,('Samantha', 'Doe', '721-258-3416')
			,('Samuel', 'Doe', '597-228-9790')
			,('Zelena', 'Doe', '927-378-1740')
			,('Brandon', 'Doe', '313-314-4380')
			,('Kyle', 'Doe', '868-789-1945')
			,('Jerry', 'Doe', '980-230-6453')
			,('Rick', 'Doe', '353-520-8140')
			,('Eliza', 'Doe', '748-316-1828')
			,('Daisy', 'Doe', '944-542-1692')
go
delete [borrower]
	where borrower_id = 20
go

--Disk table: 1. Insert at least 20 rows of data into the table 2. Update only 1 row using a where clause
insert into dbo.[disk] --no to use disk_id
			([disk_name], [release_date], [genre_id], [status_id], [disk_type_id])
	values
		('example1', '05/01/1995', 1, 1, 1)
			,('example19', '05/01/1999', 2, 1, 2)
			,('example2', '05/01/1997', 1, 2, 1)
			,('example3', '05/01/1998', 3, 1, 2)
			,('example4', '05/01/2001', 3, 3, 2)
			,('example5', '05/01/2003', 5, 1, 4)
			,('example6', '05/01/2006', 4, 4, 2)
			,('example7', '05/01/2011', 1, 1, 3)
			,('example8', '05/01/2014', 5, 2, 1)
			,('example9', '05/01/1987', 2, 2, 2)
			,('example10', '05/01/1957', 3, 1, 2)
			,('example11', '05/01/1969', 1, 2, 1)
			,('example12', '05/01/1949', 5, 1, 2)
			,('example13', '05/01/1977', 4, 1, 2)
			,('example14', '05/01/1988', 5, 2, 2)
			,('example15', '05/01/2012', 4, 1, 2)
			,('example16', '05/01/2016', 2, 2, 1)
			,('example17', '05/01/2004', 3, 2, 2)
			,('example18', '05/01/1994', 3, 2, 4)
			,('example20', '05/01/2017', 1, 1, 1)
go
update [disk]
	set release_date = '12/12/2002'
	where disk_name = 'example1'
go

--DiskHasArtist table: 1. Insert at least 20 rows of data into the table 2. At least 1 disk must have at least 2 different artist rows here 3. At least 1 artist must have at least 2 different disk rows here 4. Correct variation of disk & artist data similar to DiskHasBorrower
insert into dbo.diskHasArtist
			([artist_id], [disk_id])
	values
		(1, 1)
			,(2, 2)
			,(3, 3)
			,(4, 4)
			,(5, 5)
			,(6, 6)
			,(7, 7)
			,(8, 8)
			,(9, 9)
			,(10, 10)
			,(11, 11)
			,(12, 12)
			,(13, 13)
			,(14, 14)
			,(15, 15)
			,(16, 16)
			,(17, 17)
			,(18, 18)
			,(19, 19)
			,(20, 20)
go

--DiskHasBorrower table: 1. Insert at least 20 rows of data into the table 2. Insert at least 2 different disks 3. Insert at least 2 different borrowers 4. At least 1 disk has been borrowed by the same borrower 2 different times 5. At least 1 disk in the disk table does not have a related row here 6. At least 1 disk must have at least 2 different rows here 7. At least 1 borrower in the borrower table does not have a related row here 8. At least 1 borrower must have at least 2 different rows here
insert into dbo.diskHasBorrower
			([borrower_id], [disk_id], [borrowed_date], [returned_date])
	values
			 (1, 1, '03/01/2019', '03/10/2019')
			,(2, 8, '03/02/2019', '03/11/2019')
			,(3, 3, '03/01/2019', '03/12/2019')
			,(4, 4, '03/05/2019', '03/17/2019')
			,(5, 5, '02/28/2019', '03/13/2019')
			,(6, 4, '02/27/2019', '03/15/2019')
			,(3, 7, '02/25/2019', '03/08/2019')
			,(8, 8, '03/02/2019', '03/19/2019')
			,(9, 9, '03/03/2019', '03/20/2019')
			,(10, 4, '02/22/2019', '03/07/2019')
			,(11, 11, '02/25/2019', null)
			,(12, 12, '02/21/2019', '03/10/2019')
			,(13, 13, '02/11/2019', null)
			,(14, 14, '02/25/2019', '03/10/2019')
			,(3, 15, '02/15/2019', '03/10/2019')
			,(16, 8, '02/19/2019', null)
			,(17, 17, '02/16/2019', null)
			,(18, 18, '02/01/2019', null)
			,(19, 8, '02/06/2019', '03/03/2019')
			--row 20 deleted
go

----------------------------------------------------------------------------------------
--Proj 4
use disk_inventorycc
go
--Show the disks in your database and any associated Individual artists only. Sort by Artist Last Name, First Name & Disk Name.
select disk_name as 'Disk Name', eomonth(release_date) as 'Release Date', fname as 'Artist First Name', lname as 'Artist Last Name'
from disk
join diskHasArtist on disk.disk_id = diskHasArtist.disk_id
join artist on diskHasArtist.artist_id = artist.artist_id
order by lname, fname, disk_name
go

--Create a view called View_Individual_Artist that shows the artists’ names and not group names. Include the artist id in the view definition but do not display the id in your output.
create view View_Individual_Artist
as
	select fname, lname, artist_id
	from artist
	where artist_type_id = 1
go
select fname as FirstName, lname as LastName from View_Individual_Artist

--Show the disks in your database and any associated Group artists only. Use the View_Individual_Artist view. Sort by Group Name & Disk Name
select disk_name as 'Disk Name', eomonth(release_date) as 'Release Date', fname as 'Group Name'
	from disk
		join diskHasArtist on disk.disk_id = diskHasArtist.disk_id
		join artist on diskHasArtist.artist_id = artist.artist_id
	where artist.artist_id not in(select artist_id from View_Individual_Artist) --not in individuals (no groups in these tables)
	order by fname, disk_name
go

--Show which disks have been borrowed (status id 2) and who borrowed them. Sort by Borrower’s Last Name, then First Name, then Disk Name, then Borrowed Date, then Returned Date.
select fname as 'First', lname as 'Last', disk_name as 'Disk Name', eomonth(borrowed_date) as 'Borrowed Date', eomonth(returned_date) as 'Returned Date'
	from borrower
		join diskHasBorrower on borrower.borrower_id = diskHasBorrower.borrower_id
		join disk on diskHasBorrower.disk_id = disk.disk_id
	order by lname, fname, disk_name, borrowed_date, returned_date
go

--In disk_id order, show the number of times each disk has been borrowed.
select disk.disk_id as 'DiskId', disk_name as 'Disk Name', count(*) as 'Times Borrowed'
	from disk
		join diskHasBorrower on diskHasBorrower.disk_id = disk.disk_id
	group by disk.disk_id, disk_name
go

--Show the disks outstanding or on-loan and who has each disk. Sort by disk name.
select disk_name as 'Disk Name', eomonth(borrowed_date) as 'Borrowed', eomonth(returned_date) as 'Returned', lname as 'Last Name'
	from disk
		join diskHasBorrower on diskHasBorrower.disk_id = disk.disk_id
		join borrower on borrower.borrower_id = diskHasBorrower.borrower_id
	where returned_date is null
go