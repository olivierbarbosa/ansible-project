$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\RCM\GracePeriod'
$logFile = "C:\Script\RegistryModificationLog.log"
$keyFound = $false

# Récupérer toutes les propriétés de la clé de registre
$keys = Get-ItemProperty -Path $regPath

foreach ($key in $keys.PSObject.Properties) {
    if ($key.Name -match '^L\$RTMTIMEBOMB_') {
        Remove-ItemProperty -Path $regPath -Name $key.Name -ErrorAction SilentlyContinue
        $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Clé supprimée : $($key.Name)"
        Add-Content -Path $logFile -Value $logMessage
        Write-Output $logMessage
        $keyFound = $true
    }
}

if (-not $keyFound) {
    $logMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Aucune clé commençant par 'L$RTMTIMEBOMB_' n'a été trouvée."
    Add-Content -Path $logFile -Value $logMessage
    Write-Output $logMessage
}

