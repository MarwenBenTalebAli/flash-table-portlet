var Promise = window.Promise;
if (!Promise) {
	Promise = JSZip.external.Promise;
}

function urlToPromise(url) {
	return new Promise(function(resolve, reject) {
		JSZipUtils.getBinaryContent(url, function(err, data) {
			if (err) {
				reject(err);
			} else {
				resolve(data);
			}
		});
	});
}

var $form = $("#download_form").on("submit", function() {
	var checkedBoxes = $(this).find(":checked");
	if (checkedBoxes.length > 0) 
	{
		var filename;
		var $this;
		var zip = new JSZip();
		checkedBoxes.each(function() {
			$this = $(this);
			filename = $this.attr("name");
			var url = $this.data("url");
			zip.file(filename, urlToPromise(url), {
				binary : true
			});
		});

		zip.generateAsync({
			type : "blob"
		}, function updateCallback(metadata) {
			var msg = "progression : " + metadata.percent.toFixed(2) + " %";
			if (metadata.currentFile) {
				msg += ", current file = " + metadata.currentFile;
			}
		}).then(function callback(blob) {
			saveAs(blob, "my_documents.zip");
		}, function(e) {
			console.log(e);
		});
		return false;
	}
});