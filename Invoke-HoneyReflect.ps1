<#
.SYNOPSIS
    HoneyBadger Vanguard 2.0 - PSReflect-based Native API Invocation
.DESCRIPTION
    Uses Add-Type and reflection to load Win32 APIs into memory without touching disk.
.NOTES
    Module: NULLviper, PostEx
    Author: SpecterOps (adapted for HBV2 by @MoSLoF)
#>

param (
    [switch]$Silent
)

if (-not $Silent) {
    Write-Host "[*] [HBV2.0] Loading native Win32 APIs via PSReflect..." -ForegroundColor Cyan
}

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
}
"@

# Example stealth: Hide PowerShell console window
$hwnd = [Win32]::GetConsoleWindow()
[Win32]::ShowWindow($hwnd, 0)  # 0 = SW_HIDE

if (-not $Silent) {
    Write-Host "[+] Console window hidden. APIs loaded in-memory." -ForegroundColor Green
}