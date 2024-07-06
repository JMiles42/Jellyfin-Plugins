param (
    [string]$version,
    [string]$targetAbi,
    [string]$timestamp = $null,
    [string]$metaFile = "meta.json"
)
if([string]::IsNullOrEmpty($timestamp)){
   $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
}

$manifestJson = Get-Content $metaFile | Out-String | ConvertFrom-Json;

$manifestJson.version = $version;
$manifestJson.targetAbi = $targetAbi;
$manifestJson.timestamp = $timestamp;

$manifestJson | ConvertTo-Json -Depth 10 | Set-Content -Path $metaFile;

