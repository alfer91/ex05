<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img {
		width: 20px;
	}
</style>
</head>
<body>
<h1>Upload with Ajax</h1>

<div class="uploadDiv">
	<input type="file" name="uploadFile" multiple>
</div>

<div class="uploadResult">
	<ul>
	
	</ul>
</div>

<button id="uploadBtn">Upload</button>

<!-- jQuery cdn 검색 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>

<script>
$(document).ready(function() {
	
	// 파일의 확장자나 크기의 사전 처리
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 10485760; // 10MB
	
	function checkExtension(fileName, fileSize) {
		
		if(fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		
		if(regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		
		return true;
	}

	var cloneObj = $(".uploadDiv").clone();  // <input type='file'>의 초기화
	
	$("#uploadBtn").on("click", function(e) {
		
		var formData = new FormData();   // 가상의 form 태그 객체, 브라우저 사용 제약 있음
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		console.log(files);   // 여러 개의 파일을 선택했을 때 jQuery에서 파일 데이터 처리가 가능한지 브러우저에서 먼저 확인
		
		//add filedate to formdata
		for(var i = 0; i < files.length; i++) {
			
			if(!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			
			formData.append("uploadFile", files[i]);   /* 컨트롤러 파라미터와 이름 맞춤 */
		}
		
		$.ajax({
			url: 'uploadAjaxAction',
			processData: false,   // false 필수
			contentType: false,   // false 필수
			data: formData,   // formData 전송
			type: 'POST',
			success: function(result) {
				
				console.log(result); // 브라우저에서 Ajax 처리
				
				showUploadedFile(result);  // 업로드된 파일 이름 출력
				
				$(".uploadDiv").html(cloneObj.html());  // <input type='file'>의 초기화
			}
		});
	});
	
	var uploadResult = $(".uploadResult ul");
	
	function showUploadedFile(uploadResultArr) {  // 업로드된 파일 이름 출력
		
		var str = "";
		
		$(uploadResultArr).each(function(i, obj) {
			
			if(!obj.image) {
				str += "<li><img src='/resources/img/attach-icon-png-18.jpg'>" + obj.fileName + "</li>";  // 일반파일의 이미지 표시
			} else {
				//str += "<li>" + obj.fileName + "</li>";
				
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);  // URI호출에 적합한 문자열로 인코딩(한글, 띄어쓰기), 이피지파일의 이미지 표시
				
				str += "<li><img src='/display?fileName=" + fileCallPath + "'></li>";
			}
		})
		
		uploadResult.append(str);
	}
});
</script>
</body>
</html>