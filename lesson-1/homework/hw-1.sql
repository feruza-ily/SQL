-- data - information
-- database - somewhere where data (information) is stored electronically
-- relational database - a database that stores data in tables and columns
-- table - organized rows and columns of data stored related to the topic of the row and/or column
-- 1. organizes and stores data
-- 2. can store a lot of data
-- 3. can connect to  other tools like Excel or Power BI
-- 4. data can be kept safe using passwords
-- 5. data can be found and changed using commands
-- windows authentication and SQL server authentication
create database SchoolDB
use SchoolDB
create table Students (StudentID int IDENTITY(213,1), Name varchar (50), Age int)
-- SQL Server - a program that stores and manages data
-- SSMS - app that is used to communicate and send data into the SQL Server
-- SQL - the computer language used to program
-- DQL - used to look at data (SELECT * FROM Students)
-- DML - used to add, change, or delete data (DELETE)
-- DDL - used to make or change tables (create table)
-- DCL - used to give or or take access from users (grant,  revoke)
-- TCL - used to save or undo changes (COMMIT, ROLLBACK)
insert into Students values ('Sardor', 16) , ('Muslima', 17),('Aziz', 15)
select * from Students
-- first,  enter into SSMS and right click into databases. from there, you go into "restore databases". there should be options that ask whether you want to restore from "database" or "device" and you should select "device". then click on the three dots to the right of the screen, click add in order to add file, and then find and select the backup file you want to restore. after that, exist out the screens by clicking on "ok" as many times as it asks, and finally follow it up by refreshing the page or just databases. your file should appear and be restored in the databases.
