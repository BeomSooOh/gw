$.urlParam = function(name) {
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(window.location.href);

    if (!results) {
        return "";
    }
    return results[1] || "";
};