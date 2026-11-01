-- =====================================================================
-- OEFENDATABASE ritmania
-- Zelfde tabel als op het examen (MemoryUsage) + een extra tabel Hosts
-- om JOINs te oefenen.
-- Uitvoeren in MySQL Workbench: File > Open SQL Script > dit bestand > bliksem (Ctrl+Shift+Enter)
-- =====================================================================
DROP DATABASE IF EXISTS ritmania;
CREATE DATABASE ritmania;
USE ritmania;

-- De tabel zoals hij op het examen klaarstaat
CREATE TABLE MemoryUsage (
  ID         INT AUTO_INCREMENT PRIMARY KEY,   -- wordt automatisch gevuld
  Hostname   VARCHAR(50),
  FreeMemory INT,                              -- vrij geheugen in KB
  Date       DATETIME
);

-- Extra tabel om JOINs te oefenen (staat NIET op het examen)
CREATE TABLE Hosts (
  Hostname   VARCHAR(50) PRIMARY KEY,
  Location   VARCHAR(50),
  OS         VARCHAR(50),
  TotalRamKB INT
);

INSERT INTO Hosts (Hostname, Location, OS, TotalRamKB) VALUES
('SRV01',  'Serverruimte A', 'Windows Server 2022', 8388608),
('SRV02',  'Serverruimte A', 'Windows Server 2019', 16777216),
('WS-KYAN','Lokaal 2.14',    'Windows 11',          16777216),
('SRV03',  'Serverruimte B', 'Windows Server 2022', 4194304);   -- SRV03 heeft (nog) geen metingen

-- Dit is precies het formaat dat het PowerShell-script maakt
DELETE FROM MemoryUsage WHERE ID > 0;
INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES
('SRV01',4543524,20261013135102),
('SRV01',4535680,20261013135105),
('SRV01',4527064,20261013135108),
('SRV01',4531312,20261013135112),
('SRV01',4555548,20261013135115),
('SRV01',4675368,20261013141900),
('SRV01',4675796,20261013141903),
('SRV01',4696372,20261013141906),
('SRV01',4699836,20261013141909),
('SRV01',4695516,20261013141912),
('SRV02',5120044,20261014090001),
('SRV02',5098112,20261014090004),
('SRV02',5230876,20261014090007),
('SRV02',5011240,20261014090010),
('SRV02',4987320,20261014090013),
('SRV02',5302448,20261014090016),
('WS-KYAN',8234120,20261101191500),
('WS-KYAN',8102336,20261101191503),
('WS-KYAN',7998720,20261101191506),
('WS-KYAN',8456012,20261101191509),
('WS-KYAN',8321540,20261101191512);

SELECT * FROM MemoryUsage;
