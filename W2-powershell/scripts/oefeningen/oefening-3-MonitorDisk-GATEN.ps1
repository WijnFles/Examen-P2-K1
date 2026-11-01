<#
  OEFENING 3 - MOEILIJKER dan de oefentoets (3 argumenten, functie, statistiek, SQL afsluiten).
  Typ onder elke regel "# >>> JOUW CODE" de juiste code.
  Hulp: 02-commentaar-naar-code.md (onderaan: "Moeilijker dan de oefentoets")
  Antwoord: scripts/antwoorden/oefening-3-MonitorDisk-ANTWOORD.ps1

  Scriptnaam:  MonitorDisk.ps1
  Functie   :  Monitort de vrije schijfruimte van een schijf gedurende een aantal seconden.
  Verwachte argumenten: aantal seconden (numeriek), naam van de output file (tekst), schijfletter (tekst)
  Voorbeeld : .\MonitorDisk.ps1 20 Disk.txt D:
#>
Clear-Host

# Maak een functie Write-Result met een parameter $Line die de regel onderaan het resultatenbestand toevoegt
# >>> JOUW CODE


# Vul vier variabelen met een default waarde: aantal seconden (10), naam tekstbestand (DiskResults.txt), hostname, schijf (C:)
# >>> JOUW CODE


# Controleer de argumenten. Het aantal seconden wordt alleen vervangen als het een getal tussen 1 en 3600 is.
# >>> JOUW CODE


If (Test-Path -LiteralPath $ResultFile) {
  Write-Host "$ResultFile already exists. What do you want to do?" -ForegroundColor Yellow
  Write-Host "[1] Add the results to this file"
  Write-Host "[2] Delete it and start with an empty one"
  Write-Host "[9] Quit"

  # Vraag net zolang tot een correct antwoord is ingevoerd (gebruik do ... until)
  # >>> JOUW CODE


  # Gebruik een switch:
  #   1 = schrijf (met de functie) een nieuwe INSERT-regel weg:  INSERT INTO DiskUsage (Hostname,Drive,FreeGB,Date) VALUES
  #   2 = nieuw bestand met DELETE FROM DiskUsage WHERE ID > 0;  en daarna de INSERT-regel
  #   9 = melding geven en stoppen
  # >>> JOUW CODE

}
Else {
  Set-Content -Path $ResultFile -Value "DELETE FROM DiskUsage WHERE ID > 0;"
  Write-Result "INSERT INTO DiskUsage (Hostname,Drive,FreeGB,Date) VALUES"
}

# Bepaal de starttijd en de stoptijd
# >>> JOUW CODE


# Zet de variabelen voor de statistiek klaar: aantal metingen, totaal, laagste en hoogste waarde
# >>> JOUW CODE


Clear-Host
$LineOut = "Checking free disk space on $Drive ($MachineName) for $seconds seconds"
Write-Host $LineOut -ForegroundColor Cyan
Write-Host ("-" * $LineOut.Length)

while ((Get-Date) -lt $stopAt) {
  # Haal de vrije ruimte van $Drive op en reken om naar GB met 2 decimalen
  # >>> JOUW CODE


  $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

  # Schrijf weg met de functie: ('hostname','schijf',vrijGB,'datum'),
  # >>> JOUW CODE


  # Werk de statistiek bij (aantal, totaal, laagste, hoogste)
  # >>> JOUW CODE


  # Toon de meting. Is er minder dan 10 GB vrij? Toon dan in het rood een waarschuwing.
  # >>> JOUW CODE


  # Iets bewegends: drie puntjes, 1 seconde per puntje
  # >>> JOUW CODE

}

# Vervang de komma aan het eind van de laatste regel door een puntkomma
# >>> JOUW CODE


# Bereken het gemiddelde (pas op: niet delen door 0)
# >>> JOUW CODE


Clear-Host
Write-Host "Done. $count measurements saved in: $((Resolve-Path $ResultFile).Path)" -ForegroundColor Green
# Toon laagste, hoogste en gemiddelde
# >>> JOUW CODE


# Vraag net zolang tot y of n is ingevoerd. y = openen, n = passende melding
# >>> JOUW CODE


# Meld dat het script klaar is, met de stoptijd en hoe lang het script heeft gedraaid (in seconden)
# >>> JOUW CODE

