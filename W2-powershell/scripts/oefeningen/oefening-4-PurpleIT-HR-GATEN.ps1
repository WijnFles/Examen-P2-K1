<#
  OEFENING 4 - PurpleIT HR-instroom (Import-PurpleITHR.ps1)
  Gebaseerd op het stroomdiagram van Kyan (18 stappen).
  Vul onder elke "# >>> JOUW CODE" de code in. De hints verwijzen naar plekken in deze repo
  waar je (bijna) dezelfde code al hebt staan.

  Hulp:
   - lesstof/scripts/week5-Vestiging-Bulk.ps1   (Import-Csv, gebruikersnaam, bestaat-al, New-ADUser)
   - lesstof/scripts/week8-Keten-Onboarding.ps1 (Schrijf-Log, tellers, try/catch in de loop)
   - 05-voorbeeldenbank.md stap 3c / stap 8     (net zolang vragen tot ja/nee)
   - lesstof/samenvatting-per-week.md week 2   (param, functies, try/catch)
  Volledige uitwerking: komt na het examen in scripts/antwoorden/.
#>

# ===================== INITIALISATIE =====================

# Variabelen: pad naar het CSV-bestand, pad naar het logbestand, domein (voor UPN/e-mail), basis-OU
# >>> JOUW CODE

# Functie Schrijf-Log: schrijft een regel met tijdstempel en niveau (INFO/WAARSCHUWING/FOUT/SUCCES) naar het logbestand
# Hint: week8-Keten-Onboarding.ps1, function Schrijf-Log
# >>> JOUW CODE

# Stap 1: start van de tool (titel op het scherm + logregel "Script gestart")
# >>> JOUW CODE

# Stap 2-3: controleer of PowerShell versie 7 of nieuwer is. Zo niet: rode foutmelding met de huidige versie en stoppen.
# Hint: de versie staat in $PSVersionTable.PSVersion.Major
# >>> JOUW CODE

# Stap 4-5: vraag de beheerder om toestemming (ja/nee). Vraag net zolang tot ja/j of nee/n.
#           Bij nee: gele waarschuwing "[WAARSCHUWING] Uitvoering afgebroken door de beheerder." en stoppen.
# Hint: 05-voorbeeldenbank.md stap 3c (invoerlus) + stap 8
# >>> JOUW CODE

# Stap 6-7: controleer of het CSV-bestand bestaat. Zo niet: rode foutmelding met het pad, loggen en stoppen.
# Hint: Test-Path
# >>> JOUW CODE

# Stap 8-9: controleer of de module ActiveDirectory beschikbaar is. Zo niet: rode foutmelding, loggen en stoppen.
#           Zo ja: module importeren en "[OK] Active Directory module is beschikbaar." tonen
# Hint: Get-Module -ListAvailable -Name ActiveDirectory
# >>> JOUW CODE

# ===================== UITVOERING =====================

# Stap 10: lees het CSV-bestand in en zet de tellers op 0 (aangemaakt, bestaat al, mislukt)
# Hint: week5-Vestiging-Bulk.ps1 (Import-Csv) - let op het scheidingsteken en de kolomnamen in JOUW csv
# >>> JOUW CODE

# Voor elke medewerker in het CSV-bestand:
# >>> JOUW CODE (foreach-regel)

    # Stap 11: gebruikersnaam = firstname + lastname, zonder spaties (bijv. "Piet de Vries" -> "PietdeVries")
    # Hint: -replace '\s', ''
    # >>> JOUW CODE

    # Stap 12-13: bestaat de gebruiker al in AD? Zo ja: gele melding + WAARSCHUWING in het log, teller +1, naar de volgende (continue)
    # Hint: week5-Vestiging-Bulk.ps1, Get-ADUser -Filter
    # >>> JOUW CODE

    # Stap 14-15: bestaat de afdeling (department) als OU? Zo nee: rode melding + FOUT in het log, teller +1, volgende
    # Hint: Get-ADOrganizationalUnit -Filter "Name -eq '...'"
    # >>> JOUW CODE

    # Stap 16-17: maak de gebruiker aan in die OU, met e-mailadres, (willekeurig) wachtwoord en
    #             wachtwoord wijzigen bij eerste inlog. Gelukt: groene melding + SUCCES in het log, teller +1.
    #             Gebruik try/catch, zodat 1 fout de rest niet stopt.
    # Hint: week5-Vestiging-Bulk.ps1 (New-ADUser ... -ChangePasswordAtLogon $true -ErrorAction Stop)
    #       wachtwoord als SecureString: ConvertTo-SecureString ... -AsPlainText -Force
    # >>> JOUW CODE

# >>> JOUW CODE (einde foreach)

# ===================== AFRONDING =====================

# Stap 18: eindoverzicht in cyaan (totaal, aangemaakt, bestaat al, mislukt), afronding in het log, einde
# >>> JOUW CODE
