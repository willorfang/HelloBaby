// send response data
// status : true / false
// data   : { ... }
exports.response = function(res, err, data)
{
	var result = {};

	if (err) {
		result.status = false;
	} else {
		result.status = true;
	}
	if (data) {
		result.data = data;
	}

	res.set('Content-Type', "application/json");
	res.send(JSON.stringify(result, null, 4));
}