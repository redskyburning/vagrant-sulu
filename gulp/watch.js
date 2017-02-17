'use strict';

let path = require('path');
let gulp = require('gulp');
let conf = require('./conf');
let $    = require('gulp-load-plugins')();

let browserSync = require('browser-sync');

function isOnlyChange(event) {
	return event.type === 'changed';
}

gulp.task('reload', [], function () {
	browserSync.reload();
});

gulp.task('watch', [], function () {
	console.log(path.join(conf.paths.themes, '**/*.html.twig'));
	gulp.watch([path.join(conf.paths.themes, '**/*.html')], ['reload']);
	gulp.watch([path.join(conf.paths.styleSrc, '**/*.scss')], ['styles:reload']);
});
