$csvi = Import-Csv .\domains.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host $i 'of' $csvi.length
    $domain = $csvi[$i].'Domain Name'.ToLower()
    $manager = $csvi[$i].'Organization'

    $domainsplit = $domain.Split('.');
    [array]::Reverse($domainsplit);

    $basedir = ".\db\$($domainsplit -join '\')"
    New-Item $basedir -ItemType Directory

    $data = @{
        FQDN        = $domain;
        Owner       = $manager;
        OwnerUrl    = $null;
        Reporter    = "mkaraki";
        ReportDate  = "2020-03-21";
        Description = "Data from <a href=`"https://home.dotgov.gov/data/`">DotGov</a> published <a href=`"https://raw.githubusercontent.com/GSA/data/master/dotgov-domains/current-full.csv`">csv file</a>";
        Trustable   = $true;
    }

    $data | ConvertTo-Json -Compress | Out-File -FilePath "$($basedir)\info.json" -Encoding UTF8
}