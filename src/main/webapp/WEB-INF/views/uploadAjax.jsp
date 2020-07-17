<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h1>Upload with Ajax</h1>

<div class="uploadDiv">
	<input type="file" name="uploadFile" multiple>
</div>

<button id="uploadBtn">Upload</button>

<!-- jQuery cdn 검색 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>

<script>
$(document).ready(function() {
	
	$("#uploadBtn").on("click", function(e) {
		
		var formData = new FormData();   // 가상의 form 태그 객체, 브라우저 사용 제약 있음
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		console.log(files);   // 여러 개의 파일을 선택했을 때 jQuery에서 파일 데이터 처리가 가능한지 브러우저에서 먼저 확인
		
		//add filedate to formdata
		for(var i = 0; i < files.length; i++) {
			formData.append("uploadFile", files[i]);   /* 컨트롤러 파라미터와 이름 맞춤 */
		}
		
		$.ajax({
			url: 'uploadAjaxAction',
			processData: false,   // false 필수
			contentType: false,   // false 필수
			data: formData,   // formData 전송
			type: 'POST',
			success: function(result) {
				alert("Uploaded");
			}
		});
	});
});
</script>
</body>
</html>