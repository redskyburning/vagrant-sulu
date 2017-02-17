'use strict';

let path        = require('path');
let gulp        = require('gulp');
let conf        = require('./conf');
let $           = require('gulp-load-plugins')();
let browserSync = require('browser-sync');

function isOnlyChange(event) {
	return event.type === 'changed';
}

gulp.task('reload', [], function () {
	browserSync.reload();
});

gulp.task('reload:delayed', [], function () {
	// Yup, that's a cheap hack, but i don't see a better way to allow symfony time to process the change.
	setTimeout(() => {
		browserSync.reload();
	},100);
});

gulp.task('watch', ['styles:watch'], function () {
	gulp.watch([path.join(conf.paths.themes, '**/*.html.twig')], ['reload:delayed']);
});
