function getParam(name) {
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(location.href);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

function setInnerTextById(id, innerText) {
    document.getElementById(id).innerText = innerText;
}

function setFQDN(fqdn) {
    setInnerTextById("content-fqdn", fqdn + ' ');
}

function setReporter(reporter) {
    setInnerTextById("content-reporter", reporter);
}

function setReportDate(reportDate) {
    setInnerTextById("content-report-date", reportDate);
}

function setOwner(owner) {
    setInnerTextById('content-owner', owner);
}

function setOwnerUrl(url) {
    document.getElementById('content-owner').setAttribute('href', url);
}

function setDescription(desc) {
    setInnerTextById('content-desc', desc);
}

function setDescriptionHTML(desc) {
    document.getElementById('content-desc').innerHTML = desc;
}

function hideMiniData() {
    document.getElementById('md-owner').remove();
    document.getElementById('md-report').remove();
}

function addBread(domain, fqdn, isActive) {
    var e = document.getElementById('domain-level');
    var li = document.createElement('li');
    if (isActive) {
        li.setAttribute('class', 'breadcrumb-item active');
        li.setAttribute('aria-current', 'page');

        li.innerText = domain;
    }
    else {
        li.setAttribute('class', 'breadcrumb-item');

        var a = document.createElement('a');
        a.innerText = domain;
        a.setAttribute('href', 'search.html?q=' + fqdn);
        li.appendChild(a);
    }
    e.prepend(li);
}

var queryDomain;

function setDBNotFound() {
    setFQDN(queryDomain);
    hideMiniData();

    var issueurl =
        "https://github.com/mkaraki/domaindb/issues/new?" +
        "assignees=&labels=&template=new-domain-request.md&title=%5BREQUEST%5D%20" + queryDomain;

    setDescriptionHTML("This domain is not found in database. " +
        'Please report us by ' +
        '<a href="' + issueurl + '">GitHub Issue</a>' +
        '<br />Some domain contains parent domain. Click Breadcrumb to access it.');
}

function setNotValidated() {
    var badge = document.createElement('span');
    badge.setAttribute('class', 'badge badge-secondary notvalidation-badge');
    badge.setAttribute('title', 'This data may contain not validated or not trustable information.');
    badge.innerText = '?';
    document.getElementById('content-fqdn').appendChild(badge);
}

function unHTMLEscape(str) {
    var d = document.createElement('a');
    d.innerHTML = str;
    return d.innerText;
}

function applyData(data) {
    setFQDN(data['FQDN']);
    setOwner(data['Owner'])
    if (data['OwnerUrl'] != null) setOwnerUrl(data['OwnerUrl']);
    setReporter(data['Reporter']);
    setReportDate(data['ReportDate'].split('T')[0]);
    setDescriptionHTML(data['Description']);
    if (!data['Trustable']) setNotValidated();
}

window.onload = function () {
    setFQDN('Loading');
    setOwner('unknown');
    setReporter('unknown');
    setReportDate('')

    var input = unHTMLEscape(getParam('q'));
    var search_domain = input.trim().toLowerCase();
    var domains = search_domain.split('.').reverse();
    for (var i = 0; i < domains.length - 1; i++) {
        addBread(domains[i], domains.slice(0, i + 1).reverse().join('.'), false);
    }
    addBread(domains[domains.length - 1], undefined, true);

    document.getElementById('searchbox').setAttribute('value', search_domain);

    queryDomain = search_domain;
    document.title = queryDomain + ' - domain-db';

    var jsonlink = 'db/' + domains.join('/') + '/info.json'

    $.ajax({
        type: "get",
        url: jsonlink,
        data: {},
        dataType: "json",
        timeout: 1000
    }).done(applyData).fail(setDBNotFound);
};