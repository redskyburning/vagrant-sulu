'use strict';

let path = require('path');
let gulp = require('gulp');
let conf = require('./conf');
let $    = require('gulp-load-plugins')();

gulp.task('styles', function () {
    let sassOptions = {
        outputStyle: 'expanded',
        precision: 10
    };

    return gulp.src([path.join(conf.paths.styleSrc,'**/root.scss')])
        .pipe($.debug())
        .pipe($.sass(sassOptions)).on('error', conf.errorHandler('Sass'))
        .pipe(gulp.dest(conf.paths.styleOutput))
});
