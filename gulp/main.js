'use strict';

let path = require('path');
let gulp = require('gulp');
let conf = require('./conf');
let $    = require('gulp-load-plugins')();

gulp.task('build', ['styles']);