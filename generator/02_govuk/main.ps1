$csvi = Import-Csv .\domains.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host $i 'of' $csvi.length
    $domain = $csvi[$i].'Domain: Domain Name'.ToLower()
    $manager = $csvi[$i].'Organization'

    $domainsplit = $domain.Split('.');
    [array]::Reverse($domainsplit);

    $basedir = ".\db\$($domainsplit -join '\')"
    New-Item $basedir -ItemType Directory -ErrorAction SilentlyContinue

    $data = @{
        FQDN        = $domain;
        Owner       = $manager;
        OwnerUrl    = $null;
        Reporter    = "mkaraki";
        ReportDate  = "2020-03-21";
        Description = "Data from <a href=`"https://www.gov.uk/government/publications/list-of-gov-uk-domain-names`">GOV.UK</a>.";
        Trustable   = $true;
    }

    $data | ConvertTo-Json -Compress | Out-File -FilePath "$($basedir)\info.json" -Encoding UTF8
}
