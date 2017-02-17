'use strict';

let path        = require('path');
let gulp        = require('gulp');
let conf        = require('./conf');
let $           = require('gulp-load-plugins')();
let browserSync = require('browser-sync');

gulp.task('scripts',['scripts:vendor'], function () {

	return gulp.src([path.join(conf.paths.scriptSrc, '**/*.js')])
		.pipe($.concat('app.js'))
		.pipe(gulp.dest(conf.paths.scriptOutput))
});

gulp.task('scripts:reload', ['scripts'], function () {
	browserSync.reload();
});

gulp.task('scripts:vendor', [], function () {
	let jsFilter = $.filter('**/*.js');

	return gulp.src('./bower.json')
		.pipe($.mainBowerFiles())
		.pipe(jsFilter)
		.pipe($.concat('vendor.js'))
		.pipe(gulp.dest(conf.paths.scriptOutput));
});

gulp.task('scripts:watch', ['scripts'], function () {
	gulp.watch([path.join(conf.paths.scriptSrc, '**/*.scss')], ['scripts:reload']);
});
