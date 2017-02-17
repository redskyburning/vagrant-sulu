'use strict';

let path = require('path');
let gulp = require('gulp');
let conf = require('./conf');

let browserSync = require('browser-sync');

function browserSyncInit() {
    browserSync.instance = browserSync.init({
		host      : 'sulu.dev',
		open 	  : 'external',
        proxy	  : "sulu.local" // makes a proxy for localhost:8080
    });
}

gulp.task('serve', ['watch'], function () {
    browserSyncInit();
});
