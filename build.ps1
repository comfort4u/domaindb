$dbdir = ".\"
$dirs = Get-ChildItem .\generator | Where-Object { $_.PSIsContainer }

foreach ($dir in $dirs) {
    $customdb = Join-Path $dir "db"
    $cdbpath = Join-Path ".\generator" $customdb
 
    Write-Host $dir
    Copy-Item -Path $cdbpath -Recurse -Destination $dbdir  -ErrorAction SilentlyContinue
}
