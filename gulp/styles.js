'use strict';

let path        = require('path');
let gulp        = require('gulp');
let conf        = require('./conf');
let $           = require('gulp-load-plugins')();
let browserSync = require('browser-sync');

gulp.task('styles', ['styles:vendor'], function () {
	let sassOptions = {
		outputStyle : 'expanded',
		precision   : 10
	};

	return gulp.src([path.join(conf.paths.styleSrc, '**/root.scss')])
		.pipe($.sass(sassOptions)).on('error', conf.errorHandler('Sass'))
		.pipe(gulp.dest(conf.paths.styleOutput))
});

gulp.task('styles:reload', ['styles'], function () {
	browserSync.reload();
});

gulp.task('styles:vendor', [], function () {
	let cssFilter = $.filter('**/*.css', {restore : true});
	let jsFilter = $.filter('**/*.js', {restore : true});

	return gulp.src('./bower.json')
		.pipe($.mainBowerFiles())
		.pipe($.debug())
		.pipe(cssFilter)
		.pipe($.concat('css/vendor.css'))
		.pipe(cssFilter.restore)
		.pipe(gulp.dest(conf.paths.styleOutput));

});

gulp.task('styles:watch', ['styles'], function () {
	gulp.watch([path.join(conf.paths.styleSrc, '**/*.scss')], ['styles:reload']);
});
