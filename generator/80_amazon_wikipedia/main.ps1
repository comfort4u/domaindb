$csvi = Import-Csv .\domains.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host $i 'of' $csvi.length
    $domain = $csvi[$i].'Domain'.ToLower()
    $manager = $csvi[$i].'Owner'

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
        Description = "This domain seems used for Amazon.com, Inc. and the services of that affiliate in America or any other country.<br />Data from <a href=`"https://en.wikipedia.org/w/index.php?title=Amazon_(company)&oldid=947818989`">Wikipedia</a> <small>Wikipedia contributors. (2020, March 28). Amazon (company). In Wikipedia, The Free Encyclopedia. Retrieved 15:29, March 31, 2020</small>.<br />This data is available under the Creative Commons Attribution-ShareAlike License.<br />Owner data from WHOIS.";
        Trustable   = ($manager -ne "Unknown");
    }

    $data | ConvertTo-Json -Compress | Out-File -FilePath "$($basedir)\info.json" -Encoding UTF8
}
