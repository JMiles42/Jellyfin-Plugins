 param (
     [string]$pluginRepoUrl,
     [string]$pluginZipName,
     [string]$pluginGuid,
     [string]$filename,
     [string]$version,
     [string]$manifestUrl,
     [string]$targetAbi,
     [string]$timestamp = $null,
     [string]$manifestFileName = "manifest.json",
     [string]$changelog = 'Auto Released by Actions'
 )
 if([string]::IsNullOrEmpty($timestamp)){
    $timestamp = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
 }

 $manifestJson = Invoke-RestMethod -Uri $manifestUrl;

 $fileHash = Get-FileHash $filename -Algorithm MD5;
 $url = "$pluginRepoUrl/releases/download/v$version/$pluginZipName@v$version.zip";
 $newVersionEntry = [ordered]@{
     version    = $version
     changelog  = $changelog
     targetAbi  = $targetAbi
     sourceUrl  = $url   
     checksum   = $fileHash.Hash
     timestamp  = $timestamp
 };

 $val = $manifestJson | where-object { $_.guid -eq $pluginGuid }
 $val.versions = @($newVersionEntry) + $val.versions;

 $manifestJson | ConvertTo-Json -Depth 10 | Set-Content -Path $manifestFileName;

