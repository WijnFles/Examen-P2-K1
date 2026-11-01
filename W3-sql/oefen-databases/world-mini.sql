-- =====================================================================
-- OEFENDATABASE world_mini
-- Een klein stukje van de echte 'world'-database, met dezelfde tabellen
-- en kolomnamen (country, city, countrylanguage). Gebruik dit om thuis
-- te oefenen. Op het examen gebruik je de echte world.sql.
-- De getallen zijn afgerond / vereenvoudigd.
-- =====================================================================
DROP DATABASE IF EXISTS world_mini;
CREATE DATABASE world_mini;
USE world_mini;

CREATE TABLE country (
  Code           CHAR(3) PRIMARY KEY,
  Name           VARCHAR(52),
  Continent      VARCHAR(20),
  Region         VARCHAR(26),
  SurfaceArea    DECIMAL(10,2),
  IndepYear      SMALLINT,
  Population     INT,
  LifeExpectancy DECIMAL(3,1),
  GNP            DECIMAL(10,2),
  LocalName      VARCHAR(45),
  GovernmentForm VARCHAR(45),
  Capital        INT,
  Code2          CHAR(2)
);

CREATE TABLE city (
  ID          INT AUTO_INCREMENT PRIMARY KEY,
  Name        VARCHAR(35),
  CountryCode CHAR(3),          -- verwijst naar country.Code
  District    VARCHAR(20),
  Population  INT
);

CREATE TABLE countrylanguage (
  CountryCode CHAR(3),          -- verwijst naar country.Code
  Language    VARCHAR(30),
  IsOfficial  ENUM('T','F'),
  Percentage  DECIMAL(4,1),
  PRIMARY KEY (CountryCode, Language)
);

INSERT INTO country VALUES
('NLD','Netherlands','Europe','Western Europe',41526,1581,15864000,78.3,371362,'Nederland','Constitutional Monarchy',5,'NL'),
('BEL','Belgium','Europe','Western Europe',30518,1830,10239000,77.8,249704,'België/Belgique','Constitutional Monarchy, Federation',179,'BE'),
('DEU','Germany','Europe','Western Europe',357022,1955,82164700,77.4,2133367,'Deutschland','Federal Republic',3068,'DE'),
('FRA','France','Europe','Western Europe',551500,843,59225700,78.8,1424285,'France','Republic',2974,'FR'),
('USA','United States','North America','North America',9363520,1776,278357000,77.1,8510700,'United States','Federal Republic',3813,'US'),
('JPN','Japan','Asia','Eastern Asia',377829,-660,126714000,80.7,3787042,'Nihon/Nippon','Constitutional Monarchy',1532,'JP'),
('BRA','Brazil','South America','South America',8547403,1822,170115000,62.9,776739,'Brasil','Federal Republic',211,'BR'),
('EGY','Egypt','Africa','Northern Africa',1001449,1922,68470000,63.3,82710,'Misr','Republic',608,'EG'),
('ATA','Antarctica','Antarctica','Antarctica',13120000,NULL,0,NULL,0,'–','Co-administrated',NULL,'AQ'),
('ATF','French Southern territories','Antarctica','Antarctica',7780,NULL,0,NULL,0,'Terres australes françaises','Nonmetropolitan Territory of France',NULL,'TF'),
('BVT','Bouvet Island','Antarctica','Antarctica',59,NULL,0,NULL,0,'Bouvetøya','Dependent Territory of Norway',NULL,'BV'),
('HMD','Heard Island and McDonald Islands','Antarctica','Antarctica',359,NULL,0,NULL,0,'Heard and McDonald Islands','Territory of Australia',NULL,'HM'),
('IOT','British Indian Ocean Territory','Africa','Eastern Africa',78,NULL,0,NULL,0,'British Indian Ocean Territory','Dependent Territory of the UK',NULL,'IO'),
('SGS','South Georgia and the South Sandwich Islands','Antarctica','Antarctica',3903,NULL,0,NULL,0,'South Georgia and the South Sandwich Islands','Dependent Territory of the UK',NULL,'GS'),
('UMI','United States Minor Outlying Islands','Oceania','Micronesia/Caribbean',16,NULL,0,NULL,0,'United States Minor Outlying Islands','Dependent Territory of the US',NULL,'UM');

INSERT INTO city (ID, Name, CountryCode, District, Population) VALUES
(5,'Amsterdam','NLD','Noord-Holland',731200),
(6,'Rotterdam','NLD','Zuid-Holland',593321),
(7,'Haag','NLD','Zuid-Holland',440900),
(8,'Utrecht','NLD','Utrecht',234323),
(9,'Eindhoven','NLD','Noord-Brabant',201843),
(10,'Tilburg','NLD','Noord-Brabant',193238),
(179,'Bruxelles [Brussel]','BEL','Bryssel',133859),
(180,'Antwerpen','BEL','Antwerpen',446525),
(181,'Gent','BEL','East Flanderi',224180),
(3068,'Berlin','DEU','Berliini',3386667),
(3069,'Hamburg','DEU','Hamburg',1704735),
(3070,'München [Munich]','DEU','Baijeri',1194560),
(2974,'Paris','FRA','Île-de-France',2125246),
(2975,'Marseille','FRA','Provence-Alpes-Côte',798430),
(2976,'Lyon','FRA','Rhône-Alpes',445452),
(3793,'New York','USA','New York',8008278),
(3794,'Los Angeles','USA','California',3694820),
(3795,'Chicago','USA','Illinois',2896016),
(3813,'Washington','USA','District of Columbia',572059),
(1532,'Tokyo','JPN','Tokyo-to',7980230),
(1533,'Jokohama [Yokohama]','JPN','Kanagawa',3339594),
(1534,'Osaka','JPN','Osaka',2595674),
(206,'São Paulo','BRA','São Paulo',9968485),
(207,'Rio de Janeiro','BRA','Rio de Janeiro',5598953),
(211,'Brasília','BRA','Distrito Federal',1969868),
(608,'Cairo','EGY','Kairo',6789479),
(609,'Alexandria','EGY','Aleksandria',3328196);

INSERT INTO countrylanguage VALUES
('NLD','Dutch','T',95.6),('NLD','Arabic','F',0.9),('NLD','Turkish','F',0.8),
('BEL','Dutch','T',59.2),('BEL','French','T',32.6),('BEL','German','T',1.0),
('DEU','German','T',91.3),('DEU','Turkish','F',2.6),
('FRA','French','T',93.6),('FRA','Arabic','F',2.5),
('USA','English','F',86.2),('USA','Spanish','F',7.5),
('JPN','Japanese','F',99.1),
('BRA','Portuguese','T',97.5),
('EGY','Arabic','T',98.8);
