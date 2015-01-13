#!/usr/local/bin/jjs -scripting

'use strict';

var now = new Date().toISOString().replace(/\.[^Z]*Z/, 'Z'),
    feed_uuid = '6a7ccb4d-133d-4239-8f4c-6ab977f1df6b',
    mp3_links_dir = arguments[0],
    server_root = 'https://dl.dropboxusercontent.com/u/444834/κοροπούλης';

var months = ['Ιαν', 'Φεβ', 'Μαρ', 'Απρ', 'Μάιος', 'Ιούν', 'Ιούλ', 'Αυγ', 'Σεπ', 'Οκτ', 'Νοε', 'Δεκ'];

function to_human_date(s) {
    var fs = s.split('-');
    var d = parseInt(fs[2], 10);
    var prefix = (d === 2 || d === 22) ? 'ας' : 'ης';

    return d + prefix + ' ' + months[parseInt(fs[1], 10) - 1] + ' ' + fs[0];
}

function read_length(fname) {
    $EXEC("ls -l ${fname}");

    return $OUT.split(' ')[4];
}

print(<<HEADER);
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

  <title>Στοιχεία για την αγορά Χαλκού</title>
  <link href="${server_root}" />
  <updated>${now}</updated>
  <author>
    <name>Γιώργος Κοροπούλης</name>
  </author>
  <id>urn:uuid:${feed_uuid}</id>

HEADER

$EXEC("ls -1r ${mp3_links_dir}");
$OUT.split('\n').filter(function(n, i) { return n.lastIndexOf('.mp3') > -1; }).forEach(function(fname) {
    var dt = fname.replace('k-', '').replace('.mp3', '');
    var dur = read_length(mp3_links_dir + '/' + fname);

    print(<<ENTRY);

  <entry>
    <title>Εκπομπή της ${to_human_date(dt)}</title>
    <id>${fname}</id>
    <updated>${dt}T17:13:01Z</updated>
    <link rel="enclosure" type="audio/mp3" href="${server_root}/${fname}" length="${dur}" />
  </entry>

    ENTRY
});

print(<<FOOTER);
</feed>
FOOTER
