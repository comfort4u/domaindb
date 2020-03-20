$csvi = Import-Csv roots.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host $i 'of' $csvi.length
    $domain = $csvi[$i].Domain.TrimStart('.')
    $manager = $csvi[$i].'TLD Manager'

    New-Item ".\db\$($domain)" -ItemType Directory

    $jsi = "// Data from IANA Root Zone Database (https://www.iana.org/domains/root/db) (2020/03/20)
setFQDN('{0}');
setOwner(`"{1}`");
setReporter('mkaraki');
setReportDate('2020/03/20')
setDescriptionHTML('Data from <a href=`"https://www.iana.org/domains/root/db`">IANA Root Zone Database</a>');" -f $domain, $manager.replace('"', '\"')
    
    Out-File -InputObject $jsi -FilePath ".\db\$($domain)\js.js" -Encoding UTF8
}