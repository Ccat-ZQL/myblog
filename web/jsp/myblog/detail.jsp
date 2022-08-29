<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css"  media="all">
    <title>博客详情</title>
    <script>
        function searchTag(tagId){
            if (tagId === null){
                window.location.href = "${pageContext.request.contextPath}/main.myblog?userId=${sessionScope.checkedUserId}";
            } else {
                window.location.href = "${pageContext.request.contextPath}/main.myblog?tagId="+tagId+"&userId=${sessionScope.checkedUserId}";
            }
        }

        function deleteBlog() {
            window.location.href = "${pageContext.request.contextPath}/delete.myblog?blogId=${myblog.id}&userId=${sessionScope.checkedUserId}";
        }

        function toEdit() {
            window.location.href = "${pageContext.request.contextPath}/toEdit.myblog?blogId=${myblog.id}&userId=${sessionScope.checkedUserId}";
        }

        function setRecommend(action) {
            window.location.href = "${pageContext.request.contextPath}/setRecommend.myblog?blogId=${myblog.id}&userId=${sessionScope.checkedUserId}&action="+action;
        }
    </script>
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
<div class="layui-container">
    <p style="font-size: 35px;font-weight: bold;text-align: center;margin-top: 5%">详情</p>
    <div style="float: top;margin-top: 5%">
        <label class="layui-form-label" style="font-size: 20px;font-weight: bold;margin-left: 32%">标题：</label>
            <div class="layui-form-mid layui-word-aux" style="font-size: 20px">${myblog.title}</div>
    </div>
    <div style="float: bottom">
        <label class="layui-form-label" style="font-size: 20px;font-weight: bold;">标签：</label>
        <div class="layui-form-mid layui-word-aux" style="font-size: 20px">${tagName}</div>
    </div>
        <div class="layui-card" style="margin-top: 15%">

        <div class="layui-card" style="float: top;text-align: center">
            <div class="layui-card-header" style="font-size: 20px;font-weight: bold">正文</div>
            <div class="layui-card-body">
                ${myblog.content}
            </div>
    </div>
        </div>
    <button type="submit" onclick="toEdit()" class="layui-btn" lay-submit="" lay-filter="demo1" style="margin-top: 20px">修改</button>
    <c:if test="${sessionScope.user.role == 1}">
        <c:if test="${myblog.recommend == 0}">
            <button type="submit" onclick="setRecommend(1)" class="layui-btn" lay-submit="" lay-filter="demo1" style="margin-top: 20px">设为推荐</button>
        </c:if>
        <c:if test="${myblog.recommend == 1}">
            <button type="submit" onclick="setRecommend(0)" class="layui-btn" lay-submit="" lay-filter="demo1" style="margin-top: 20px">取消推荐</button>
        </c:if>
    </c:if>
    <button type="submit" onclick="deleteBlog()" class="layui-btn" lay-submit="" lay-filter="demo1" style="margin-top: 20px">删除</button>
    <label style="color: red">${message}</label>
        </div>

</body>
</html>