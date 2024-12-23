<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!-- sidebar start -->
<div class="admin-sidebar am-offcanvas" id="admin-offcanvas">
    <div class="am-offcanvas-bar admin-offcanvas-bar">
        <!-- 顶部用户信息 -->
        <div class="admin-sidebar-header" style="background-color: #2c3e50; color: white; padding: 15px; text-align: center;">
            <div class="admin-sidebar-user">
                <p class="admin-username" style="font-size: 18px; font-weight: bold;">${userid}</p>
                <p class="admin-status"><span class="am-badge am-badge-success">在线</span></p>
            </div>
        </div>

        <!-- 搜索框 -->
        <div class="admin-sidebar-search" style="padding: 10px;">
            <input type="text" class="am-input-sm" placeholder="搜索用户" id="searchUser" onkeyup="filterUser()" style="width: 100%; padding: 5px;">
        </div>

        <!-- 原来的菜单项 -->
        <ul class="am-list admin-sidebar-list" style="background-color: #34495e; color: white;">
            <li><a href="${ctx}/chat" style="color: white; padding: 10px; background-color: #2980b9;"><span class="am-icon-commenting"></span> 聊天</a></li>
            <li><a href="${ctx}/${userid}" class="am-cf" style="color: white; padding: 10px; background-color: #2980b9;"><span class="am-icon-book"></span> 个人信息</a></li>
            <li><a href="${ctx}/${userid}/config" style="color: white; padding: 10px; background-color: #2980b9;"><span class="am-icon-group"></span> 个人设置</a></li>
        </ul>

        <!-- 在线列表 -->
        <div class="am-panel am-panel-default" style="margin-top: 20px;">
            <div class="am-panel-hd" style="background-color: #2980b9; color: white;">
                <h3 class="am-panel-title">在线列表</h3>
            </div>
            <ul class="am-list am-list-static am-list-striped" id="list" style="background-color: #ecf0f1; color: #2c3e50;">
                <!-- 在线人员将动态加载在此 -->
            </ul>
        </div>
    </div>
</div>

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

    // 搜索功能
    function filterUser() {
        var input = document.getElementById("searchUser");
        var filter = input.value.toUpperCase();
        var list = document.getElementById("list");
        var items = list.getElementsByTagName("li");

        for (var i = 0; i < items.length; i++) {
            var item = items[i];
            if (item.innerHTML.toUpperCase().indexOf(filter) > -1) {
                item.style.display = "";
            } else {
                item.style.display = "none";
            }
        }
    }
</script>

<style>
    .admin-sidebar {
        background-color: #34495e;
        color: white;
    }

    .admin-sidebar a {
        color: white;
        padding: 10px;
        display: block;
        text-decoration: none;
    }

    .admin-sidebar a:hover {
        background-color: #2980b9;
        color: white;
    }

    .admin-sidebar-header {
        background-color: #2c3e50;
        color: white;
    }

    .admin-sidebar-header .admin-sidebar-user p {
        margin: 0;
    }

    .admin-sidebar-header .admin-username {
        font-size: 18px;
        font-weight: bold;
    }

    .admin-sidebar-list li {
        padding: 12px;
        border-bottom: 1px solid #7f8c8d;
    }

    .admin-sidebar-list li a {
        color: white;
        background-color: #2980b9; /* 固定蓝色背景 */
        text-decoration: none;
    }

    .admin-sidebar-list li button {
        background-color: #3498db;
        border: none;
        color: white;
    }

    .admin-sidebar-list li button:hover {
        background-color: #2980b9;
    }

    .am-panel-hd {
        background-color: #2980b9;
        color: white;
    }

    .am-panel-title {
        font-size: 16px;
    }

    .am-panel {
        background-color: #ecf0f1;
        color: #2c3e50;
    }

    .am-input-sm {
        background-color: #ecf0f1;
        color: #2c3e50;
    }
</style>
<!-- sidebar end -->
