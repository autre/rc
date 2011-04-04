#!/usr/bin/env rhino

function getGlobal() {
    return (function() {
        return this;
    }).call(null);
}

var _g = getGlobal();

var allObjects = {};

var add = function(obj) {
    if (obj in allObjects)
        allObjects[obj] += 1;
    else
        allObjects[obj] = 1;
};

Object.getOwnPropertyNames(_g).forEach(function(o) {
    add(o);

    if (typeof _g[o] === 'object')
        Object.getOwnPropertyNames(_g[o]).forEach(function(m) {
            add(m);
        });
});

delete allObjects['_g'];
delete allObjects['getGlobal'];
delete allObjects['allObjects'];
delete allObjects['add'];

Object.keys(allObjects).sort().forEach(function(e) { print(e); });
