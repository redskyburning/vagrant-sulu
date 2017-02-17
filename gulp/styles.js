'use strict';

let path        = require('path');
let gulp        = require('gulp');
let conf        = require('./conf');
let $           = require('gulp-load-plugins')();
let browserSync = require('browser-sync');

gulp.task('styles', function () {
	let sassOptions = {
		outputStyle: 'expanded',
		precision  : 10
	};

	return gulp.src([path.join(conf.paths.styleSrc, '**/root.scss')])
			   //.pipe($.debug())
			   .pipe($.sass(sassOptions)).on('error', conf.errorHandler('Sass'))
			   .pipe(gulp.dest(conf.paths.styleOutput))
});

gulp.task('styles:reload', ['styles'], function () {
	browserSync.reload();
});

gulp.task('styles:watch', ['styles'], function () {
	gulp.watch([path.join(conf.paths.styleSrc, '**/*.scss')], ['styles:reload']);
});
