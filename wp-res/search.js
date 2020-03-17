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
    setInnerTextById("content-fqdn", fqdn);
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

function addBread(domain, isActive) {
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
        a.setAttribute('href', 'search.html?q=' + domain);
        li.appendChild(a);
    }
    e.appendChild(li);
}

var queryDomain;

function setDBNotFound() {
    setFQDN(queryDomain);
    hideMiniData();
    setDescriptionHTML("This domain is not found in database. " +
        'Please report us by ' +
        '<a href="https://github.com/mkaraki/domaindb/issues/new/choose">GitHub Issue</a>');
}

window.onload = function () {
    setFQDN('Loading');
    setOwner('unknown');
    setReporter('unknown');
    setReportDate('')

    var input = getParam('q');
    var search_domain = input.trim().toLowerCase();
    var domains = search_domain.split('.').reverse();
    for (var i = 0; i < domains.length - 1; i++) {
        addBread(domains[i], false);
    }
    addBread(domains[domains.length - 1], true);

    queryDomain = search_domain;
    document.title = queryDomain + ' - domain-db';

    var jslink = 'db/' + domains.join('/') + '/js.js'
    var scriptnode = document.createElement('script');
    scriptnode.setAttribute('src', jslink);
    scriptnode.setAttribute('onerror', 'setDBNotFound();');
    document.getElementById('body').appendChild(scriptnode);
};