<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>VPS.VN</title>
<style>
input {
	width: 99%;
	text-align: center;
	padding: 10px 0;
	border: 0 none;
	font-size: 14px;
	outline: none;
}
</style>
</head>
<body>
<div>
	<input type="text" value="curl -sO https://vps.vn/install && bash install" onClick="this.select();">
</div>
<br>
<div>
	<input type="text" value="yum -y install wget ; wget --no-check-certificate https://vps.vn/install ; chmod +x install ; bash install" onClick="this.select();">
</div>
</body>
</html>
