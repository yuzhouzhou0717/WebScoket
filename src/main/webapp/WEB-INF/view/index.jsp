<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>刚刚好聊天室</title>
    <jsp:include page="include/commonfile.jsp"/>
    <script src="${ctx}/static/plugins/sockjs/sockjs.js"></script>

    <link rel="stylesheet" href="${ctx}/static/css/style.css"> <!-- 自定义样式 -->
    <style>
        /* 增强布局和样式 */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f7fa;
            margin: 0;
            padding: 0;
        }
        .admin-main {
            display: flex;
            height: 100vh;
        }
        .admin-content {
            flex: 1;
            padding: 20px;
            overflow: hidden;
        }
        .admin-content-main {
            display: flex;
            flex-direction: column;
            gap: 20px;
            flex: 3;
        }
        .admin-content-main .am-scrollable-vertical {
            flex-grow: 1;
            overflow-y: auto;
        }
        .am-comments-list {
            list-style-type: none;
            padding: 0;
        }
        .am-comment {
            border-radius: 8px;
            padding: 10px;
            margin: 10px 0;
            background-color: #fff;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
        }
        .am-comment:hover {
            transform: scale(1.05);
        }
        .am-form textarea {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin-bottom: 10px;
            box-sizing: border-box;
            resize: none;
        }
        .am-btn-group button {
            margin: 5px;
        }
        .am-panel {
            width: 100%;
            margin-top: 20px;
            border-radius: 8px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        #chat-view {
            flex-grow: 1;
        }
        .am-panel-title {
            font-size: 18px;
            font-weight: bold;
        }
        .am-btn-danger {
            background-color: #d9534f;
            border-color: #d43f00;
        }
        .am-btn-success {
            background-color: #5bc0de;
            border-color: #46b8da;
        }
    </style>
</head>
<body>
<jsp:include page="include/header.jsp"/>
<div class="am-cf admin-main">
    <jsp:include page="include/sidebar.jsp"/>

    <!-- content start -->
    <div class="admin-content">
        <div class="admin-content-main">
            <!-- 聊天区 -->
            <div class="am-scrollable-vertical" id="chat-view">
                <ul class="am-comments-list am-comments-list-flip" id="chat"></ul>
            </div>
            <!-- 输入区 -->
            <div class="am-form-group am-form">
                <textarea class="" id="message" name="message" rows="5" placeholder="发送信息..."></textarea>
            </div>
            <!-- 接收者 -->
            <div class="" style="float: left">
                <p class="am-kai">对 <span id="sendto">全体成员</span><button class="am-btn am-btn-xs am-btn-danger" onclick="$('#sendto').text('全体成员')">回到群聊</button></p>
            </div>
            <!-- 按钮区 -->
            <div class="am-btn-group am-btn-group-xs" style="float:right;">
<%--                <button class="am-btn am-btn-default" type="button" onclick="getConnection()"><span class="am-icon-plug"></span> 连接</button>--%>
<%--                <button class="am-btn am-btn-default" type="button" onclick="closeConnection()"><span class="am-icon-remove"></span> 断开</button>--%>
<%--                <button class="am-btn am-btn-default" type="button" onclick="checkConnection()"><span class="am-icon-bug"></span> 检查</button>--%>
                <button class="am-btn am-btn-default" type="button" onclick="clearConsole()"><span class="am-icon-trash-o"></span> 清屏</button>
                <button class="am-btn am-btn-default" type="button" onclick="sendMessage()"><span class="am-icon-commenting"></span> 发送</button>
            </div>
        </div>

        <%--        <!-- 在线列表 -->--%>
        <%--        <div class="am-panel am-panel-default">--%>
        <%--            <div class="am-panel-hd">--%>
        <%--                <h3 class="am-panel-title">在线列表 [<span id="onlinenum"></span>]</h3>--%>
        <%--            </div>--%>
        <%--            <ul class="am-list am-list-static am-list-striped" id="list"></ul>--%>
        <%--        </div>--%>
    </div>
    <!-- content end -->
</div>

<a href="#" class="am-show-sm-only admin-menu" data-am-offcanvas="{target: '#admin-offcanvas'}">
    <span class="am-icon-btn am-icon-th-list"></span>
</a>

<jsp:include page="include/footer.jsp"/>


<script>
    $(function () {
        context.init({preventDoubleContext: false});
        context.settings({compress: true});
        context.attach('#chat-view', [
            {header: '操作菜单',},
            {text: '清理', action: clearConsole},
            {divider: true},
            {
                text: '选项', subMenu: [
                    {header: '连接选项'},
                    {text: '检查', action: checkConnection},
                    {text: '连接', action: getConnection},
                    {text: '退出', action: closeConnection}
                ]
            },
            {
                text: '销毁菜单', action: function (e) {
                    e.preventDefault();
                    context.destroy('#chat-view');
                }
            }
        ]);
    });
    if("${message}"){
        layer.msg('${message}', {
            offset: 0
        });
    }
    if("${error}"){
        layer.msg('${error}', {
            offset: 0,
            shift: 6
        });
    }
    // $("#tuling").click(function(){
    //     var onlinenum = $("#onlinenum").text();
    //     if($(this).text() == "未上线"){
    //         $(this).text("已上线").removeClass("am-btn-danger").addClass("am-btn-success");
    //         showNotice("图灵机器人加入聊天室");
    //         $("#onlinenum").text(parseInt(onlinenum) + 1);
    //     }
    //     else{
    //         $(this).text("未上线").removeClass("am-btn-success").addClass("am-btn-danger");
    //         showNotice("图灵机器人离开聊天室");
    //         $("#onlinenum").text(parseInt(onlinenum) - 1)
    //     }
    // });
    var wsServer = null;
    var ws = null;
    wsServer = "ws://" + location.host+"${pageContext.request.contextPath}" + "/chatServer";
    ws = new WebSocket(wsServer); //创建WebSocket对象
    ws.onopen = function (evt) {
        layer.msg("已经建立连接", { offset: 0});
    };
    ws.onmessage = function (evt) {
        analysisMessage(evt.data);  //解析后台传回的消息,并予以展示
    };
    ws.onerror = function (evt) {
        layer.msg("产生异常", { offset: 0});
    };
    ws.onclose = function (evt) {
        layer.msg("已经关闭连接", { offset: 0});
    };
    /**
     * 连接
     */
    function getConnection() {
        if (ws == null || ws.readyState === WebSocket.CLOSED || ws.readyState === WebSocket.CLOSING) {
            ws = new WebSocket(wsServer);  // 重新创建 WebSocket 对象
            ws.onopen = function (evt) {
                layer.msg("成功建立连接!", { offset: 0 });
            };
            ws.onmessage = function (evt) {
                analysisMessage(evt.data);  // 解析后台传回的消息
            };
            ws.onerror = function (evt) {
                layer.msg("产生异常", { offset: 0 });
            };
            ws.onclose = function (evt) {
                layer.msg("已经关闭连接", { offset: 0 });
            };
        } else {
            layer.msg("连接已存在!", { offset: 0, shift: 6 });
        }
    }
    /**
     * 关闭连接
     */
    function closeConnection(){
        if(ws != null){
            ws.close();
            ws = null;
            $("#list").html("");    //清空在线列表
            layer.msg("已经关闭连接", { offset: 0});
        }else{
            layer.msg("未开启连接", { offset: 0, shift: 6 });
        }
    }
    /**
     * 检查连接
     */
    function checkConnection(){
        if(ws != null){
            layer.msg(ws.readyState == 0? "连接异常":"连接正常", { offset: 0});
        }else{
            layer.msg("连接未开启!", { offset: 0, shift: 6 });
        }
    }
    /**
     * 发送信息给后台
     */
    function sendMessage(){
        if(ws == null){
            layer.msg("连接未开启!", { offset: 0, shift: 6 });
            return;
        }
        var message = $("#message").val();
        var to = $("#sendto").text() == "全体成员"? "": $("#sendto").text();
        if(message == null || message == ""){
            layer.msg("请不要惜字如金!", { offset: 0, shift: 6 });
            return;
        }
        // $("#tuling").text() == "已上线"? tuling(message):console.log("图灵机器人未开启");  //检测是否加入图灵机器人
        ws.send(JSON.stringify({
            message : {
                content : message,
                from : '${userid}',
                to : to,      //接收人,如果没有则置空,如果有多个接收人则用,分隔
                time : getDateFull()
            },
            type : "message"
        }));
    }
    /**
     * 解析后台传来的消息
     * "massage" : {
     *              "from" : "xxx",
     *              "to" : "xxx",
     *              "content" : "xxx",
     *              "time" : "xxxx.xx.xx"
     *          },
     * "type" : {notice|message},
     * "list" : {[xx],[xx],[xx]}
     */
    function analysisMessage(message){
        message = JSON.parse(message);
        if(message.type == "message"){      //会话消息
            showChat(message.message);
        }
        if(message.type == "notice"){       //提示消息
            showNotice(message.message);
        }
        if(message.list != null && message.list != undefined){      //在线列表
            showOnline(message.list);
        }
    }
    /**
     * 展示提示信息
     */
    function showNotice(notice){
        $("#chat").append("<div><p class=\"am-text-success\" style=\"text-align:center\"><span class=\"am-icon-bell\"></span> "+notice+"</p></div>");
        var chat = $("#chat-view");
        chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
    }
    /**
     * 展示会话信息
     */
    function showChat(message){
        var to = message.to == null || message.to == ""? "全体成员" : message.to;   //获取接收人
        var isSef = '${userid}' == message.from ? "am-comment-flip" : "";   //如果是自己则显示在右边,他人信息显示在左边
        var html = "<li class=\"am-comment "+isSef+" am-comment-primary\"><a href=\"#link-to-user-home\"><img width=\"48\" height=\"48\" class=\"am-comment-avatar\" alt=\"\" src=\"${ctx}/"+message.from+"/head\"></a><div class=\"am-comment-main\">\n" +
            "<header class=\"am-comment-hd\"><div class=\"am-comment-meta\">   <a class=\"am-comment-author\" href=\"#link-to-user\">"+message.from+"</a> 于<time> "+message.time+"</time> 对 "+to+" 说:</div></header><div class=\"am-comment-bd\"> <p>"+message.content+"</p></div></div></li>";
        $("#chat").append(html);
        $("#message").val("");  //清空输入区
        var chat = $("#chat-view");
        chat.scrollTop(chat[0].scrollHeight);   //让聊天区始终滚动到最下面
    }
    /**
     * 展示在线列表
     */
    function showOnline(list){
        $("#list").html("");    //清空在线列表
        $.each(list, function(index, item){     //添加私聊和视频按钮
            var li = "<li>"+item+"</li>";
            if('${userid}' != item){    //排除自己
                li = "<li>"+item+" <button type=\"button\" class=\"am-btn am-btn-xs am-btn-primary am-round\" onclick=\"addChat('"+item+"');\"><span class=\"am-icon-phone\"><span> 私聊</button>";
            }
            $("#list").append(li);
        });
        $("#onlinenum").text($("#list li").length);     //获取在线人数
    }
    /**
     * 添加接收人
     */
    function addChat(user){
        var sendto = $("#sendto");
        var receive = sendto.text() == "全体成员" ? "" : sendto.text() + ",";
        if(receive.indexOf(user) == -1){    //排除重复
            sendto.text(receive + user);
        }
    }
    /**
     * 清空聊天区
     */
    function clearConsole(){
        $("#chat").html("");
    }
    function appendZero(s){return ("00"+ s).substr((s+"").length);}  //补0函数
    function getDateFull(){
        var date = new Date();
        var currentdate = date.getFullYear() + "-" + appendZero(date.getMonth() + 1) + "-" + appendZero(date.getDate()) + " " + appendZero(date.getHours()) + ":" + appendZero(date.getMinutes()) + ":" + appendZero(date.getSeconds());
        return currentdate;
    }
    /**
     *
     */
    function startVideo(user){
        document.theForm.target="_blank";
        document.theForm.action = "maincideo.jsp";
        document.theForm.submit();
    }
</script>
</body>
</html>