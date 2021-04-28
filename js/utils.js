function toggleLoading(element, forceLoading) {
    if (element == null)
        return;

    forceLoading = forceLoading || false;
    if (forceLoading || element.classList.indexOf('loading-overlay') == -1)
        element.classList.add('loading-overlay');
    else
        element.classList.remove('loading-overlay');
}

function NetworkRequest(method, url, data) {
    return new Promise((resolve, reject) => {
        var request = new XMLHttpRequest();
        request.open(method, url);

        request.onload = function() {
            if (this.status >= 200 && this.status < 300) {
                resolve(request.response);
            }
            else {
                reject({
                    status: this.status,
                    statusText: request.statusText
                });
            }
        };

        request.onerror = function() {
            reject({
                status: this.status,
                statusText: request.statusText
            });
        };

        request.send(data);
    });
}

function GET(url, data) {
    return NetworkRequest('GET', url, data);
}
