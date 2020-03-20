$csvi = Import-Csv .\domains.csv

for ($i = 0; $i -lt $csvi.length; $i++) {
    Write-Host $i 'of' $csvi.length
    $domain = $csvi[$i].'Domain Name'.ToLower()
    $manager = $csvi[$i].'Organization'

    $domainsplit = $domain.Split('.');
    [array]::Reverse($domainsplit);

    $basedir = ".\db\$($domainsplit -join '\')"
    New-Item $basedir -ItemType Directory

    $jsi = "// Data from DotGov (https://home.dotgov.gov/data/) (2020/03/20)
setFQDN('{0}');
setOwner(`"{1}`");
setReporter('mkaraki');
setReportDate('2020/03/20')
setDescriptionHTML('Data from <a href=`"https://home.dotgov.gov/data/`">DotGov</a> published <a href=`"https://raw.githubusercontent.com/GSA/data/master/dotgov-domains/current-full.csv`">csv file</a>');" -f $domain, $manager.replace('"', '\"')
    
    Out-File -InputObject $jsi -FilePath "$($basedir)\js.js" -Encoding UTF8
    # $jsi
}