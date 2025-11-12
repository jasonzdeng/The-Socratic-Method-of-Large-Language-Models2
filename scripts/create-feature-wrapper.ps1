#!/usr/bin/env pwsh
# Wrapper for create-new-feature.ps1 that handles Unicode path issues
[CmdletBinding()]
param(
    [switch]$Json,
    [string]$ShortName,
    [int]$Number = 0,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FeatureDescription
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Get current directory (already in repo root)
$repoRoot = Get-Location | Select-Object -ExpandProperty Path

# Build arguments for the actual script
$args = @()
if ($Json) { $args += '-Json' }
if ($ShortName) { $args += '-ShortName', $ShortName }
if ($Number -gt 0) { $args += '-Number', $Number }
if ($FeatureDescription) { $args += $FeatureDescription }

# Temporarily modify the script to use current directory
$scriptPath = Join-Path $repoRoot '.specify\scripts\powershell\create-new-feature.ps1'
$scriptContent = Get-Content $scriptPath -Raw -Encoding UTF8

# Replace the Set-Location line with a no-op since we're already in the right place
$modifiedContent = $scriptContent -replace 'Set-Location \$repoRoot', '# Set-Location bypassed by wrapper'

# Execute modified script in current scope
$scriptBlock = [ScriptBlock]::Create($modifiedContent)
$PSDefaultParameterValues = @{'*:Encoding' = 'utf8'}

# Invoke with parameters
& $scriptBlock @PSBoundParameters
