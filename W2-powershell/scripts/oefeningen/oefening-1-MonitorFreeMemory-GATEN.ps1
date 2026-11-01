<#
  OEFENING 1 - zo ziet het examen er waarschijnlijk uit.
  Het script van de docent, maar op 12 plekken is de code weggehaald.
  Typ onder elke regel "# >>> JOUW CODE" de juiste code.
  Hulp: W2-powershell/02-commentaar-naar-code.md   (zoek met Ctrl+F op het commentaar)
  Antwoord: scripts/origineel/MonitorFreeMemory-docent.ps1

  Scriptnaam:  MonitorFreeMemory.ps1
  Functie   :  Dit script monitort het vrije geheugen van de machine waarop het script uitgevoerd wordt.
               De resultaten worden weggeschreven naar een resultatenfile als uit te voeren SQL query.
  Auteur    :  Olaf Ritman
  Versie    :  1.0
  Datum     :  12 oktober 2022

  Verwachte argumenten: aantal seconden (numeriek) en naam van de output file (tekst)
#>
clear

# GAT 1: Vul drie variabelen met een default waarde: aantal seconden ($seconds), naam van het tekstbestand ($ResultFile) en de hostname ($MachineName)
# >>> JOUW CODE


# GAT 2: Controleer of de gebruiker waarden als argument heeft opgegeven voor het aantal seconden en de naam van het tekstbestand. Zo ja, vervang dan de default waarden.
# >>> JOUW CODE


If (Test-Path -LiteralPath $ResultFile) {
  Write-Host -ForegroundColor Red "WARNING: " -NoNewline
  Write-Host "$ResultFile already exists. What do you want to do?"
  Write-Host "[1] Add the results to this file"
  Write-Host "[2] Delete it and start with an empty one"
  Write-Host "[9] Quit"

  # GAT 3: Vraag de gebruiker een keuze te maken. Vraag net zolang tot een correct antwoord (1, 2 of 9) is ingevoerd.
  # >>> JOUW CODE


  # GAT 4: Als de gebruiker kiest om het bestand te overschrijven: start een nieuw tekstbestand en schrijf de eerste twee regels weg
  #        Regel 1: DELETE FROM MemoryUsage WHERE ID > 0;
  #        Regel 2: INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES
  # >>> JOUW CODE


  # GAT 5: Als de gebruiker kiest om te stoppen: stop het script
  # >>> JOUW CODE

}
Else {
  Set-Content -path $ResultFile -value "DELETE FROM MemoryUsage WHERE ID > 0;"
  Add-Content -path $ResultFile -value "INSERT INTO MemoryUsage (Hostname,FreeMemory,Date) VALUES"
}

# GAT 6: Bepaal de stoptijd (nu + het aantal seconden) en zet deze in de variabele $stopAt
# >>> JOUW CODE


clear
$LineOut = "Checking free virtual memory on $MachineName for $seconds seconds"
Write-Host $LineOut
$LengthLineOut = $LineOut.Length
For($i=1;$i -le $LengthLineOut;$i++){
  Write-Host -NoNewline "="
}
Write-Host "`r"

# GAT 7: Zolang de stoptijd nog niet bereikt is: (schrijf de while-regel, de { staat al aan het eind)
# >>> JOUW CODE (bijv.  while (...) {  )

  $FreeMemory = Get-CIMInstance Win32_OperatingSystem | Select FreePhysicalMemory
  ForEach ($entry in $FreeMemory){
    $TimeStamp = Get-Date -Format "yyyyMMddHHmmss"
    $MemValue = $entry.FreePhysicalMemory
    $NewLine = "('$MachineName',$MemValue,$TimeStamp),"

    # GAT 8: Schrijf $NewLine weg naar het tekstbestand (onderaan toevoegen!)
    # >>> JOUW CODE

    $TimeStamp = Get-Date
    Write-Host "Free memory at ${TimeStamp}:" $entry.FreePhysicalMemory
  }

  # GAT 9: Toon de gebruiker iets 'bewegends' op het scherm en wacht in totaal 3 seconden
  # >>> JOUW CODE

}

clear
# GAT 10: Toon de gebruiker waar het tekstbestand gevonden kan worden (volledig pad)
# >>> JOUW CODE


# GAT 11: Vraag of de gebruiker het bestand wil openen. Herhaal dit net zolang tot er 'y' of 'n' wordt ingevoerd.
#         Als het antwoord 'y' is: open het bestand. Als het antwoord 'n' is: geef een passende melding.
# >>> JOUW CODE


# GAT 12: Meld de gebruiker dat het script klaar is, inclusief de tijd dat het script gestopt is
# >>> JOUW CODE

