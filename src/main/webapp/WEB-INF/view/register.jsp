<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String path = request.getContextPath();%>
<!DOCTYPE html>
<html>
<head>
  <title>刚刚好聊天室 - 注册</title>
  <link href="<%=path%>/static/source/css/login.css" rel='stylesheet' type='text/css' />
  <script src="<%=path%>/static/plugins/jquery/jquery-2.1.4.min.js"></script>
  <script src="<%=path%>/static/plugins/layer/layer.js"></script>
</head>

<body style="background-color: #ecf0f1; font-family: Arial, sans-serif;">

<div class="login-form" style="width: 100%; max-width: 400px; margin: 0 auto; padding: 20px; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
  <div class="close" style="text-align: right; cursor: pointer;">&times;</div>
  <div class="head-info" style="text-align: center; margin-bottom: 20px;">
    <img src="<%=path%>/static/source/img/lts.png" alt="WebChat Logo" style="width: 80px; height: 80px; border-radius: 50%;" />
    <span style="font-size: 24px; font-weight: bold; color: #2980b9;">刚刚好聊天室</span> <!-- 添加聊天室标题 -->
  </div>

  <form id="register-form" action="<%=path%>/user/register" method="post" onsubmit="return checkRegisterForm()">
    <div class="key" style="margin-bottom: 20px;">
      <input type="text" id="username" name="userid" placeholder="请输入账号" style="width: 100%; padding: 12px; font-size: 16px; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box;">
    </div>

    <div class="key" style="margin-bottom: 20px;">
      <input type="password" id="password" name="password" placeholder="请输入密码" style="width: 100%; padding: 12px; font-size: 16px; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box;">
    </div>

    <div class="key" style="margin-bottom: 20px;">
      <input type="password" id="confirm-password" name="confirmPassword" placeholder="确认密码" style="width: 100%; padding: 12px; font-size: 16px; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box;">
    </div>

    <!-- 新增昵称和性别字段 -->
    <div class="key" style="margin-bottom: 20px;">
      <input type="text" id="nickname" name="nickname" placeholder="请输入昵称" style="width: 100%; padding: 12px; font-size: 16px; border-radius: 5px; border: 1px solid #ccc; box-sizing: border-box;">
    </div>

    <div class="key" style="margin-bottom: 20px;color: #2980b9;">
      <label for="gender" style="font-size: 16px; margin-right: 10px;">性别：</label>
      <input type="radio" id="male" name="gender" value="male"> 男
      <input type="radio" id="female" name="gender" value="female"> 女
    </div>

    <div class="signin" style="text-align: center;">
      <input type="submit" id="submit" value="注册" style="background-color: #2980b9; color: white; border: none; padding: 12px 20px; font-size: 16px; border-radius: 5px; cursor: pointer; transition: background-color 0.3s ease;">
    </div>
  </form>
</div>

<script>
  $(function(){
    <c:if test="${not empty param.timeout}">
    layer.msg('连接超时,请重新注册!', {
      offset: 0,
      shift: 6
    });
    </c:if>
    if("${error}"){
      $('#submit').attr('value',"${error}").css('background','red');
    }
    if("${message}"){
      layer.msg('${message}', {
        offset: 0,
      });
    }
    $('.close').on('click', function(c){
      $('.login-form').fadeOut('slow', function(c){
        $('.login-form').remove();
      });
    });
    $('#username,#password,#confirm-password').change(function(){
      $('#submit').attr('value','注册').css('background','#2980b9');
    });
  });

  function checkRegisterForm(){
    var username = $('#username').val();
    var password = $('#password').val();
    var confirmPassword = $('#confirm-password').val();

    if(isNull(username) && isNull(password) && isNull(confirmPassword)){
      $('#submit').attr('value','请输入账号和密码!!!').css('background','red');
      return false;
    }
    if(isNull(username)){
      $('#submit').attr('value','请输入账号!!!').css('background','red');
      return false;
    }
    if(isNull(password)){
      $('#submit').attr('value','请输入密码!!!').css('background','red');
      return false;
    }
    if(password !== confirmPassword){
      $('#submit').attr('value','密码和确认密码不匹配!!!').css('background','red');
      return false;
    }
    else{
      $('#submit').attr('value','注册中').css('background','#2980b9');
      return true;
    }
  }

  function isNull(input){
    if(input == null || input == '' || input == undefined){
      return true;
    }
    else{
      return false;
    }
  }
</script>

</body>
</html>
