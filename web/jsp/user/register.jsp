<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/login.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css">
</head>
<body>
<div class="login-main">
    <header class="layui-elip" style="width: 82%">注册页</header>

    <!-- 表单选项 -->
    <form action="register.user" class="layui-form">
        <div class="layui-input-inline">
            <!-- 用户名 -->
            <div class="layui-inline" style="width: 85%">
                <input type="text" id="user" name="username" required  lay-verify="required" placeholder="请输入用户名" autocomplete="off" class="layui-input">
            </div>
        </div>
        <!-- 密码 -->
        <div class="layui-input-inline">
            <div class="layui-inline" style="width: 85%">
                <input type="password" id="pwd" name="password" required  lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
            </div>
        </div>

        <div class="layui-input-inline login-btn" style="width: 85%">
            <button type="submit" lay-submit lay-filter="sub" class="layui-btn">注册</button>
            <p>${message}</p>
        </div>
        <hr style="width: 85%" />
        <p style="width: 85%"><a href="${pageContext.request.contextPath}/jsp/user/login.jsp" class="fl">已有账号？立即登录</a>
    </form>
</div>
</body>
</html>
