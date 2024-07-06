 param (
     [string]$pluginRepoUrl,
     [string]$pluginZipName,
     [string]$pluginGuid,
     [string]$filename,
     [string]$version,
     [string]$manifestUrl,
     [string]$targetAbi = '10.9.0.0',
     [string]$manifestFileName = "manifest.json",
     [string]$changelog = 'Auto Released by Actions'
 )

 $manifestJson = Invoke-RestMethod -Uri $manifestUrl;

 $fileHash = Get-FileHash $filename -Algorithm MD5;
 $url = "$pluginRepoUrl/releases/download/v$version/$pluginZipName@v$version.zip";
 $newVersionEntry = [ordered]@{
     version    = $version
     changelog  = $changelog
     targetAbi  = $targetAbi
     sourceUrl  = $url   
     checksum   = $fileHash.Hash
     timestamp  = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")     
 };

 $val = $manifestJson[0] | where-object { $_.guid -eq $pluginGuid }
 $val.versions = @($newVersionEntry) + $val.versions;

 $manifestJson | ConvertTo-Json -Depth 10 | Set-Content -Path $manifestFileName;

