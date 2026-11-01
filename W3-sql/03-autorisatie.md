# 03 · Autorisatie: gebruikers en rechten (3 punten!)

> ⚠️ Dit zit **niet** in de oefentoets, maar wel op het **beoordelingsformulier**: *"T1 Autorisatie configureren: de autorisatie is op de juiste manier geconfigureerd."* Reken erop dat het gevraagd kan worden, bijvoorbeeld: *"Maak een gebruiker aan die alleen gegevens mag lezen uit de database ritmania."*

## Het idee in 3 zinnen
1. Je maakt een **gebruiker** aan: `CREATE USER`.
2. Je geeft die gebruiker **rechten** op een database of tabel: `GRANT`.
3. Je **controleert** het: `SHOW GRANTS`, en inloggen als die gebruiker.

---

## Stap 1 · Gebruiker aanmaken
```text
CREATE USER '<naam>'@'<vanaf waar>' IDENTIFIED BY '<wachtwoord>';
```
| `<vanaf waar>` | Betekent |
|---|---|
| `'localhost'` | alleen inloggen op de server zelf |
| `'%'` | vanaf **elke** computer |
| `'192.168.1.%'` | alleen vanaf het netwerk 192.168.1.x |

```sql
CREATE USER 'monitor'@'localhost' IDENTIFIED BY 'Welkom01!';
CREATE USER 'lezer'@'%' IDENTIFIED BY 'Welkom01!';
CREATE USER 'beheerder'@'localhost' IDENTIFIED BY 'Welkom01!';
```

## Stap 2 · Rechten geven (GRANT)
```text
GRANT <rechten> ON <database>.<tabel> TO '<naam>'@'<vanaf waar>';
```
| `<rechten>` | Mag… |
|---|---|
| `SELECT` | lezen |
| `INSERT` | toevoegen |
| `UPDATE` | wijzigen |
| `DELETE` | verwijderen |
| `CREATE`, `DROP`, `ALTER` | tabellen maken / weggooien / aanpassen |
| `ALL PRIVILEGES` | alles |

| `ON …` | Geldt voor |
|---|---|
| `ritmania.*` | alle tabellen in database ritmania |
| `ritmania.MemoryUsage` | alleen tabel MemoryUsage |
| `*.*` | alles op de hele server (alleen voor een admin!) |

```sql
-- alleen lezen in de hele database ritmania
GRANT SELECT ON ritmania.* TO 'lezer'@'%';

-- het script/monitor-account: lezen en toevoegen in MemoryUsage, plus DELETE
-- (het resultatenbestand begint met DELETE FROM MemoryUsage WHERE ID > 0;)
GRANT SELECT, INSERT, DELETE ON ritmania.MemoryUsage TO 'monitor'@'localhost';

-- beheerder: alles op ritmania, en mag zelf ook rechten uitdelen
GRANT ALL PRIVILEGES ON ritmania.* TO 'beheerder'@'localhost' WITH GRANT OPTION;

-- alleen bepaalde kolommen mogen lezen
GRANT SELECT (Hostname, FreeMemory) ON ritmania.MemoryUsage TO 'lezer'@'%';

FLUSH PRIVILEGES;   -- rechten direct laten ingaan (schaadt nooit)
```

## Stap 3 · Controleren
```sql
SHOW GRANTS FOR 'monitor'@'localhost';       -- welke rechten heeft deze gebruiker?
SELECT user, host FROM mysql.user;           -- welke gebruikers bestaan er?
```
**Écht testen** (voor de screenshots):
1. Workbench → startscherm → ➕ nieuwe connectie → **Username: monitor** → Test Connection → OK.
2. Open die connectie en voer uit:
   - `SELECT * FROM ritmania.MemoryUsage;` → ✅ werkt
   - `UPDATE ritmania.MemoryUsage SET FreeMemory = 1 WHERE ID = 1;` → ❌ **Error 1142: UPDATE command denied to user 'monitor'**
3. Screenshot van allebei: **dat bewijst dat de autorisatie klopt.**

## Rechten afpakken, wachtwoord wijzigen, verwijderen
```sql
REVOKE DELETE ON ritmania.MemoryUsage FROM 'monitor'@'localhost';    -- recht afpakken
ALTER USER 'monitor'@'localhost' IDENTIFIED BY 'NieuwWachtwoord1!';  -- wachtwoord wijzigen
DROP USER 'lezer'@'%';                                                -- gebruiker verwijderen
```

## Rollen (MySQL 8): rechten bundelen
Handig als meerdere gebruikers dezelfde rechten moeten krijgen.
```text
CREATE ROLE 'rol_lezen';
GRANT SELECT ON ritmania.* TO 'rol_lezen';
GRANT 'rol_lezen' TO 'monitor'@'localhost';
SET DEFAULT ROLE 'rol_lezen' TO 'monitor'@'localhost';     -- rol staat aan bij inloggen
```

---

## Via de muis: Workbench *Users and Privileges*
Ook goed, als je het maar met screenshots laat zien.
1. Menu **Server → Users and Privileges** (of *Administration*-tab links → *Users and Privileges*).
2. **Add Account** → tabblad **Login**: *Login Name*, *Limit to Hosts Matching* (`localhost` of `%`), *Password* + *Confirm*.
3. Tabblad **Schema Privileges** → **Add Entry…** → *Selected schema*: `ritmania` → OK.
4. Vink de rechten aan (SELECT, INSERT, …) → **Apply**.
5. Tabblad **Administrative Roles** alleen gebruiken voor beheerders (bijv. *DBA*). Voor een gewone gebruiker: **niets** aanvinken.

---

## Voorbeeldopdrachten (met antwoord)
| Opdracht | Antwoord |
|---|---|
| Maak gebruiker `stagiair` die alleen gegevens mag **bekijken** in `ritmania` | `CREATE USER 'stagiair'@'%' IDENTIFIED BY 'Welkom01!';`<br>`GRANT SELECT ON ritmania.* TO 'stagiair'@'%';` |
| Gebruiker `script` mag records **toevoegen en lezen** in `MemoryUsage`, alleen vanaf de server zelf | `CREATE USER 'script'@'localhost' IDENTIFIED BY 'Welkom01!';`<br>`GRANT SELECT, INSERT ON ritmania.MemoryUsage TO 'script'@'localhost';` |
| Gebruiker `dba` krijgt **alle rechten** op `world` | `CREATE USER 'dba'@'localhost' IDENTIFIED BY 'Welkom01!';`<br>`GRANT ALL PRIVILEGES ON world.* TO 'dba'@'localhost';` |
| Pak het recht om te **verwijderen** af van `script` | `REVOKE DELETE ON ritmania.MemoryUsage FROM 'script'@'localhost';` |
| Laat zien welke rechten `stagiair` heeft | `SHOW GRANTS FOR 'stagiair'@'%';` |

## Waarom zo? (voor je documentatie)
> *"Volgens het **least privilege-principe** krijgt elke gebruiker alleen de rechten die nodig zijn voor zijn taak. De gebruiker `monitor` hoeft alleen metingen in te lezen en de tabel te legen, dus die krijgt alleen SELECT, INSERT en DELETE op de tabel MemoryUsage, en geen rechten op andere tabellen of databases. Zo kan een fout of een gelekt wachtwoord niet de hele database beschadigen."*

Dat is precies wat het criterium "**op de juiste manier** geconfigureerd" bedoelt: **niet te veel en niet te weinig rechten, en uitgelegd waarom.**
