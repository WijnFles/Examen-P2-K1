<#
  OEFENING 2 - zelfde opbouw, ANDERE NAMEN (CPU in plaats van geheugen).
  Zo kan het examen "bijna identiek maar met andere namen" zijn.
  Typ onder elke regel "# >>> JOUW CODE" de juiste code.
  Hulp: 02-commentaar-naar-code.md en 04-varianten-andere-metingen.md
  Antwoord: scripts/antwoorden/oefening-2-MonitorCpu-ANTWOORD.ps1

  Scriptnaam:  MonitorCpu.ps1
  Functie   :  Dit script monitort de CPU-belasting van de machine waarop het script uitgevoerd wordt.
               De resultaten worden weggeschreven naar een resultatenfile als uit te voeren SQL query.
  Verwachte argumenten: aantal seconden (numeriek) en naam van de output file (tekst)
#>
clear

# Vul drie variabelen met een default waarde: aantal seconden (10), naam van het tekstbestand (CpuResults.txt), hostname
# >>> JOUW CODE


# Controleer of de gebruiker een argument heeft opgegeven voor het aantal seconden. Zo ja, vervang de default.
# >>> JOUW CODE

# Controleer of de gebruiker een argument heeft opgegeven voor de naam van het tekstbestand. Zo ja, vervang de default.
# >>> JOUW CODE


# Controleer of het tekstbestand al bestaat
# >>> JOUW CODE (de if-regel met { )

  Write-Host -ForegroundColor Red "WARNING: " -NoNewline
  Write-Host "$ResultFile already exists. What do you want to do?"
  Write-Host "[1] Add the results to this file"
  Write-Host "[2] Delete it and start with an empty one"
  Write-Host "[9] Quit"

  # Vraag net zolang tot een correct antwoord is ingevoerd
  # >>> JOUW CODE


  # Overschrijven (2): start een nieuw tekstbestand en schrijf de eerste regels weg
  #   DELETE FROM CpuUsage WHERE ID > 0;
  #   INSERT INTO CpuUsage (Hostname,CpuLoad,Date) VALUES
  # >>> JOUW CODE


  # Stoppen (9): stop het script
  # >>> JOUW CODE

}
# Zo nee: start een nieuw tekstbestand en schrijf de eerste regels weg (zelfde twee regels)
# >>> JOUW CODE (else { ... })


# Bepaal de stoptijd en zet deze in een variabele
# >>> JOUW CODE


# Maak het scherm leeg en toon de gebruiker wat er gaat gebeuren (met een streep eronder)
# >>> JOUW CODE


# Zolang de stoptijd nog niet bereikt is:
#   - check de CPU-belasting (Win32_Processor, LoadPercentage)
#   - schrijf weg naar het tekstbestand als ('hostname',waarde,datum),
#   - toon op het scherm
#   - toon de gebruiker iets 'bewegends' (3 seconden)
# >>> JOUW CODE


# Maak het scherm leeg en toon de gebruiker waar het tekstbestand gevonden kan worden
# >>> JOUW CODE


# Vraag of de gebruiker het bestand wil openen. Herhaal dit net zolang tot er y of n wordt ingevoerd.
# >>> JOUW CODE


# y: open het bestand / n: geef een passende melding
# >>> JOUW CODE


# Meld de gebruiker dat het script klaar is, inclusief de tijd dat het script gestopt is
# >>> JOUW CODE

