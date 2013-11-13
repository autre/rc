#!/usr/bin/env rhino

let (env = {}) {
    Object
        .getOwnPropertyNames(this)
        .filter(function(name) typeof this[name] == 'function')
        .forEach(function(name) {
            env[name] = true;

            Object.getOwnPropertyNames(this[name]).forEach(function(name) {
                env[name] = true;
            });
        });

    print(Object.keys(env).sort().forEach(function(key) print(key)));
}

