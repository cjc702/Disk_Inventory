/********************************************************************************************************
*		Name				Date				Description
*
*		Caleb Crownover		02/28/2019			Initial implementation of disk_invcc.
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