/**
 *  This file contains the variables used in other gulp files
 *  which defines tasks
 *  By design, we only put there very generic config values
 *  which are used in several places to keep good readability
 *  of the tasks
 */

let gutil = require('gulp-util');
let path  = require('path');

let bundlePath = 'sulu/src/Client/Bundle/WebsiteBundle';
let publicPath = path.join(bundlePath, 'Resources/public/default');

exports.paths = {
	public       : publicPath,
	themes       : path.join(bundlePath, 'Resources/themes'),
	styleSrc     : path.join(publicPath, 'scss'),
	styleOutput  : path.join(publicPath, 'css'),
	scriptSrc    : path.join(publicPath, 'jsSrc'),
	scriptOutput : path.join(publicPath, 'js')
};

/**
 *  Common implementation for an error handler of a Gulp plugin
 */
exports.errorHandler = function (title) {
	'use strict';

	return function (err) {
		gutil.log(gutil.colors.red('[' + title + ']'), err.toString());
		this.emit('end');
	};
};