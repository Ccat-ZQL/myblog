<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css"  media="all">
    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <title>个人信息</title>
    <script>

        layui.use('form', function(){
            var form = layui.form;
            form.render();
        });

    </script>
</head>


<body>
    <div>
        <ul class="layui-nav layui-bg-cyan">
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/main.myblog">主页</a></li>
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/jsp/myblog/toCreate.myblog?userId=${sessionScope.user.id}">添加文章</a></li>
            <li class="layui-nav-item"><a href="">个人信息</a></li>
            <li class="layui-nav-item" style="float: right"><a href="${pageContext.request.contextPath}/logout.user">退出登录</a></li>
        </ul>
    </div>

    <form class="layui-form" action="edit.user" style="width: 60%;margin-left: 15%;margin-top: 20px" enctype="multipart/form-data" method="post">
        <label class="layui-form-label">用户名</label>
        <div class="layui-input-block">
            <input type="text" value="${sessionScope.user.username}" name="username" lay-verify="title" autocomplete="off" placeholder="用户名" class="layui-input">
        </div>
        <br><br>
        <label class="layui-form-label">密码</label>
        <div class="layui-input-block">
            <input type="text" value="${sessionScope.user.password}" name="password" lay-verify="title" autocomplete="off" placeholder="密码" class="layui-input">
        </div>
        <br><br>
        <label class="layui-form-label">介绍</label>
        <div class="layui-input-block">
            <textarea placeholder="请输入内容"  class="layui-textarea" name="info">${sessionScope.user.info}</textarea>
        </div>
        <br><br>
        <label class="layui-form-label"></label>
        <div class="layui-input-block">
            <img src="${pageContext.request.contextPath}/static/image/${sessionScope.user.headImage}" style="width: 150px;height: 150px">
            <input type="file" name="image">
        </div>
        <label class="layui-form-label"></label>
        <button type="submit" class="layui-btn" lay-submit="" lay-filter="demo1" style="margin-top: 20px">修改</button>
        <label style="color: red">${message}</label>
    </form>
</body>
</html>
