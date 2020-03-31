# encoding: utf8bom

$csvi = Import-Csv .\gojp.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host '(1/2) ' $i 'of' $csvi.length
    $domain = $csvi[$i].'保有ドメイン'.ToLower()
    $manager = $csvi[$i].'府省等'

    $domainsplit = $domain.Split('.');
    [array]::Reverse($domainsplit);

    $basedir = ".\db\$($domainsplit -join '\')"
    New-Item $basedir -ItemType Directory -ErrorAction SilentlyContinue

    $data = @{
        FQDN        = $domain;
        Owner       = $manager;
        OwnerUrl    = $null;
        Reporter    = "mkaraki";
        ReportDate  = "2020-03-31";
        Description = "Data from <a href=`"https://cio.go.jp/domains`">Government Chief Information Officers' Portal, Japan</a>";
        Trustable   = $true;
    }

    $data | ConvertTo-Json -Compress | Out-File -FilePath "$($basedir)\info.json" -Encoding UTF8
}

$csvi = Import-Csv .\other.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host '(2/2) ' $i 'of' $csvi.length
    $domain = $csvi[$i].'保有ドメイン'.ToLower()
    $manager = $csvi[$i].'府省等'

    $domainsplit = $domain.Split('.');
    [array]::Reverse($domainsplit);

    $basedir = ".\db\$($domainsplit -join '\')"
    New-Item $basedir -ItemType Directory -ErrorAction SilentlyContinue

    $data = @{
        FQDN        = $domain;
        Owner       = $manager;
        OwnerUrl    = $null;
        Reporter    = "mkaraki";
        ReportDate  = "2020-03-31";
        Description = "Data from <a href=`"https://cio.go.jp/domains`">Government Chief Information Officers' Portal, Japan</a>";
        Trustable   = $true;
    }

    $data | ConvertTo-Json -Compress | Out-File -FilePath "$($basedir)\info.json" -Encoding UTF8
}