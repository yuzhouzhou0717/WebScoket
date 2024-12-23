<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html>
<head>
    <title>刚刚好聊天室</title>
    <jsp:include page="include/commonfile.jsp"/>
</head>
<body style="background-color: #ecf0f1; font-family: Arial, sans-serif;">

<jsp:include page="include/header.jsp"/>

<div class="am-cf admin-main">
    <jsp:include page="include/sidebar.jsp"/>

    <!-- content start -->
    <div class="admin-content" style="background-color: #ffffff; padding: 20px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
        <div class="am-cf am-padding">
            <div class="am-fl am-cf"><strong class="am-text-primary am-text-lg">个人信息</strong> / <small>info</small></div>
        </div>

        <div class="am-tabs am-margin" data-am-tabs>
            <ul class="am-tabs-nav am-nav am-nav-tabs">
                <li class="am-active"><a href="#tab1">个人信息</a></li>
            </ul>
            <div class="am-tabs-bd">
                <div class="am-tab-panel am-fade am-in am-active" id="tab1">
                    <div class="am-g">
                        <c:set value="${user}" var="user"/>

                        <div class="am-u-md-3"><b>昵称:</b></div>
                        <div class="am-u-md-3" style="color: #2980b9;">
                            ${user.nickname}
                        </div>

                        <div class="am-u-md-6" style="float: right">
                            <img class="am-circle" src="${ctx}/${user.profilehead}" width="140" height="140" alt="${user.nickname}"/>
                        </div>

                        <div class="am-u-md-3"><b>性别:</b></div>
                        <div class="am-u-md-3" style="color: #2980b9;">
                            <c:if test="${user.sex == null || user.sex == ''}">未知</c:if>
                            <c:if test="${user.sex != null && user.sex != ''}">
                                <c:if test="${user.sex == 1}">男</c:if>
                                <c:if test="${user.sex == 2}">女</c:if>
                                <c:if test="${user.sex == -1}">保密</c:if>
                            </c:if>
                        </div>

                        <div class="am-u-md-3"><b>年龄:</b></div>
                        <div class="am-u-md-3" style="color: #2980b9;">
                            <c:if test="${user.age == null || user.age == ''}">未知</c:if>
                            <c:if test="${user.age != null && user.age != ''}">${user.age}</c:if>
                        </div>

                        <div class="am-u-md-3"><b>简介:</b></div>
                        <div class="am-u-md-3" style="color: #2980b9;">
                            <c:if test="${user.profile == null || user.profile == ''}">
                                这个人很懒,什么都没有留下!
                            </c:if>
                            <c:if test="${user.profile != null && user.profile != ''}">
                                ${user.profile}
                            </c:if>
                        </div>

                        <div class="am-u-md-3"><b>注册时间:</b></div>
                        <div class="am-u-md-3" style="color: #2980b9;">${user.firsttime}</div>

                        <div class="am-u-md-3"><b>最后登录:</b></div>
                        <div class="am-u-md-3" style="color: #2980b9;">${user.lasttime}</div>

                        <!-- 其他信息 -->
                        <!-- <div class="am-u-md-3"><b>IP:</b></div>
                        <div class="am-u-md-3">${user.ip}</div> -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- content end -->
</div>

<a href="#" class="am-show-sm-only admin-menu" data-am-offcanvas="{target: '#admin-offcanvas'}">
    <span class="am-icon-btn am-icon-th-list"></span>
</a>

<jsp:include page="include/footer.jsp"/>
</body>
</html>

<script>
    function showOnline(list){
        $("#list").html(""); // 清空在线列表
        $.each(list, function(index, item){
            var li = "<li>"+item+"</li>";
            if('${userid}' != item){ // 排除自己
                li = "<li>"+item+" <button type=\"button\" class=\"am-btn am-btn-xs am-btn-primary am-round\" onclick=\"addChat('"+item+"');\"><span class=\"am-icon-phone\"><span> 私聊</button>";
            }
            $("#list").append(li);
        });
        $("#onlinenum").text($("#list li").length); // 获取在线人数
    }
</script>
