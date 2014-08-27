#!/usr/local/bin/jjs -strict

'use strict';

var System = Java.type('java.lang.System');
var Thread = Java.type('java.lang.Thread');
var JString = Java.type('java.lang.String');
var ByteArray = Java.type('byte[]');

var ByteArrayOutputStream = Java.type('java.io.ByteArrayOutputStream');
var FileOutputStream = Java.type('java.io.FileOutputStream');
var BufferedOutputStream = Java.type('java.io.BufferedOutputStream');
var BufferedWriter = Java.type('java.io.BufferedWriter');
var FileWriter = Java.type('java.io.FileWriter');
var File = Java.type('java.io.File');

var URL = Java.type('java.net.URL');

var Files = Java.type('java.nio.file.Files');

var prog = 'grab-m3u8-stream';

function debug(msg) {
    var now = new Date().toISOString();

    System.err.println(now + ' ' + prog + ': ' + msg);
}

function get_url(url) {
    var c = new URL(url).openConnection();

    c.setAllowUserInteraction(false);
    c.setRequestProperty('User-Agent', 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; WOW64; Trident/4.0; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.21022; .NET CLR 3.');

    c.connect();

    var inp = c.getContent(),
        buf = new ByteArray(8192),
        len,
        out = new ByteArrayOutputStream();

    try {
        while ((len = inp.read(buf, 0, buf.length)) >= 0)
            out.write(buf, 0, len);
    } finally {
        inp.close();
    }

    return out;
}

function save_to_file(stream, fname) {
    var f = new BufferedOutputStream(new FileOutputStream(fname));

    try {
        f.write(stream.toByteArray());
    } finally {
        f.flush();
        f.close();
    }
}

function string_to_file(str, fname) {
    var f = new BufferedWriter(new FileWriter(fname));

    try {
        f.append(str);
        f.append('\n');
    } finally {
        f.flush();
        f.close();
    }
}

Array.prototype.toString = function() {
    return '[' + this.join(', ') + ']';
};

function get_current_playlist(playlist) {
    return get_url(playlist).toString()
        .split('\n')
        .filter(function(line) { return line.contains('m3u8'); })[0];
}

function save_files_for(server_url, playlist, dir) {
    get_url(server_url + '/' + playlist).toString()
        .split('\n')
        .filter(function(line) { return line.endsWith('.aac'); })
        .forEach(function(file) {
            var out = file.split('_')[2];

            // debug(file + ' => ' + out);
            save_to_file(get_url(server_url + '/' + file), "${dir}/${out}");
        });
}

function make_file_list(tmp_dir) {
    var arr = [];

    Files
        .find(new File("${tmp_dir}").toPath(), 3, function(path, attr) { return path.toString().endsWith('.aac'); })
        .sorted(function(x, y) { return new JString(x).compareTo(new JString(y)); })
        .forEach(function(x) { arr.push('file ' + x.toString()); });

    return arr.join('\n');
}


var server_url = arguments[0];
var duration = parseInt(arguments[1]);

(function main() {
    var playlist_url = "${server_url}/playlist.m3u8";
    var today = new Date().toISOString().substr(0, 10);
    var tmp_dir = "/tmp/grab-${today}";
    var tmp_list = '/tmp/grab.list';
    var tmp_file = '/tmp/grab.aac';
    var time_ctr = 1;
    var current_playlist;

    $EXEC("rm -fr ${tmp_dir}");
    $EXEC("mkdir -p ${tmp_dir}");

    while (time_ctr++ <= duration) {
        try {
            current_playlist = get_current_playlist(playlist_url);
            save_files_for(server_url, current_playlist, tmp_dir);
            Thread.sleep(10 * 1000);
        } catch (e) {
            debug(e.javaException.toString());
        }
    }

    string_to_file(make_file_list(tmp_dir), "${tmp_list}");
    $EXEC("ffmpeg -y -f concat -i ${tmp_list} -acodec copy ${tmp_file}");
    $EXEC("ffmpeg -y -i ${tmp_file} -ac 2 -ar 44100 -ab 64k /home/bill/Dropbox/Public/κοροπούλης/k-${today}.mp3");
})();
