$csvi = Import-Csv roots.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host $i 'of' $csvi.length
    $domain = $csvi[$i].Domain.TrimStart('.')
    $manager = $csvi[$i].'TLD Manager'

    $basedir = ".\db\$($domain)";
    New-Item $basedir -ItemType Directory

    $data = @{
        FQDN        = $domain;
        Owner       = $manager;
        OwnerUrl    = $null;
        Reporter    = "mkaraki";
        ReportDate  = "2020-03-21";
        Description = "Data from <a href=`"https://www.iana.org/domains/root/db`">IANA Root Zone Database</a>";
        Trustable   = $true;
    }

    $data | ConvertTo-Json -Compress | Out-File -FilePath "$($basedir)\info.json" -Encoding UTF8
}