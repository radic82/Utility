var fs = require('graceful-fs');
var path = require('path');

var walk = function (dir, done) {
	var results = [];
	fs.readdir(dir, function (err, list) {
		if (err) {
			return done(err);
		}
		var pending = list.length;
		if (!pending) {
			return done(null, results);
		}
		list.forEach(function (file) {
			file = path.resolve(dir, file);
			fs.stat(file, function (err, stat) {
				if (stat && stat.isDirectory()) {
					walk(file, function (err, res) {
						results = results.concat(res);
						if (!--pending) done(null, results);
					});
				} else {
					
						//if (path.extname(file) == '.java' || 
						//	path.extname(file) == '.jsp' ||
						//	path.extname(file) == '.tag' ||
						//	path.extname(file) == '.js'						   
						 //  ) {
							results.push(file);
						//}					
					
					
					if (!--pending) {
						done(null, results);
					}
				}
			});
		});
	});
};

var readFile = function (file, searchWord) {
	var data = fs.readFileSync(file, 'utf8');
	
	if (data.includes(searchWord)) {		
		console.log(file);		
	}
}

var scanDir = "C:\\_ideaProjects\\app-esop\\";

walk(scanDir, function (err, results) {
	if (err) {
		throw err;
	}
	var searchW;
	process.argv.forEach(function (val, index, array) {
		if(index == 2) {
			searchW = val;	
		}
		if(index == 3) {
			scanDir = val;
		}
	});
	console.log("****** searchW["+searchW+"] and scanDir["+scanDir+"]")
	for (let i = 0; i < results.length; i++) {
		readFile(results[i], searchW);
	}
});
