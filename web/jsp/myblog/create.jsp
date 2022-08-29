<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css"  media="all">
    <script src="${pageContext.request.contextPath}/static/layui/layui.js"></script>
    <title>添加文章</title>
</head>
<body>
<div>
    <ul class="layui-nav layui-bg-cyan">
        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/main.myblog?userId=${sessionScope.checkedUserId}">主页</a></li>
        <c:if test="${sessionScope.user.role == 0}">
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/jsp/myblog/toCreate.myblog?userId=${sessionScope.user.id}">添加文章</a></li>
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/jsp/user/info.jsp">个人信息</a></li>
            <li class="layui-nav-item" style="float: right"><a href="${pageContext.request.contextPath}/logout.user">退出登录</a></li>
        </c:if>
        <c:if test="${sessionScope.user.role == 1}">
            <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/toIndex.admin">返回管理页面</a></li>
        </c:if>
    </ul>
</div>

<form class="layui-form" action="create.myblog" style="width: 60%;margin-left: 15%;margin-top: 20px">
    <label class="layui-form-label">标题</label>
    <div class="layui-input-block">
        <input type="text" name="title" lay-verify="title" autocomplete="off" placeholder="请输入标题" class="layui-input">
    </div>
    <div class="layui-form-item" style="margin-top: 20px">
        <label class="layui-form-label">标签</label>
        <div class="layui-input-block">
            <select name="tagId" lay-filter="aihao">
                <c:forEach items="${tagList}" var="tag">
                    <option value="${tag.id}">${tag.tagName}</option>
                </c:forEach>
            </select>
        </div>
    </div>
    <label class="layui-form-label">正文</label>
    <div class="layui-input-block">
        <textarea placeholder="请输入内容" class="layui-textarea" name="content"></textarea>
    </div>
    <label class="layui-form-label"></label>
    <button type="submit" class="layui-btn" lay-submit="" lay-filter="demo1" style="margin-top: 20px">创建</button>
    <label style="color: red">${message}</label>
</form>
</body>

<script>

    layui.use('form', function(){
        var form = layui.form;
        form.render();
    });

</script>
</html>
