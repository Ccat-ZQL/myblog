<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css"  media="all">
    <title>博客主页</title>
    <script>
        function searchTag(tagId){
            if (tagId === null){
                window.location.href = "${pageContext.request.contextPath}/main.myblog?userId=${sessionScope.checkedUserId}";
            } else {
                window.location.href = "${pageContext.request.contextPath}/main.myblog?tagId="+tagId+"&userId=${sessionScope.checkedUserId}";
            }
        }

        function toDetail(id) {
            window.location.href = "${pageContext.request.contextPath}/detail.myblog?blogId="+id;
        }

    </script>
</head>
<body>
    <div>
        <ul class="layui-nav layui-bg-cyan">
            <li class="layui-nav-item"><a href="">主页</a></li>
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
    <div>
        <form action="main.myblog">
            <div  style="margin-left: 15%;margin-top: 10px">
                <input type="text" name="title" required  lay-verify="required"
                       placeholder="请输入标题" autocomplete="off" class="layui-input"
                       style="width: 200px; float: left">
                <input type="text" name="userId" value="${sessionScope.checkedUserId}" hidden="hidden">
                <input type="submit" value="搜索" class="layui-btn">
                <button type="button" onclick="searchTag(null)"  class="layui-btn">全部</button>
            </div>
        </form>
        <div>
            <table class="layui-table" lay-size="lg" style="width: 25%;margin-left: 15%;float: left">
                <colgroup>
                    <col width="25%">
                </colgroup>
                <thead>
                <tr>
                    <th>普通文章</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${list}" var="map">
                    <tr onclick="toDetail(${map.myblog.id})">
                        <td><p style="width: 150px;overflow: no-display">${map.myblog.title}</p>
                            <p style="float: right;font-size: 13px">${map.myblog.addTimeFormat}</p>
                            <p style="float: right;font-size: 13px">${map.tag.tagName}&nbsp;&nbsp;</p></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <table class="layui-table" lay-size="lg" style="width: 25%;margin-left: 20px ;float: left">
                <colgroup>
                    <col width="25%">
                </colgroup>
                <thead>
                <tr>
                    <th>推荐文章</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${list1}" var="map">
                    <tr onclick="toDetail(${map.myblog.id})">
                        <td><p style="width: 150px;overflow: no-display">${map.myblog.title}</p>
                            <p style="float: right;font-size: 13px">${map.myblog.addTimeFormat}</p>
                            <p style="float: right;font-size: 13px">${map.tag.tagName}&nbsp;&nbsp;</p></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div style="margin-left: 50px;float: left;width: 300px;border: 1px solid gray;margin-top: 10px;border-radius: 5%">
                <div id="userInfo" style="width: 300px;border-bottom: 1px solid gray">
                    <div style="width: 300px;height: 120px;margin-top: 10px">
                        <a>
                            <img src="${pageContext.request.contextPath}/static/image/${userInfo.headImage}"
                                 style="width: 100px;height: 100px;border-radius: 50%;margin-left: 100px">
                        </a>
                    </div>
                    <div style="width: 300px;margin-bottom: 10px">
                        <p style="text-align: center;font-weight: bold">${userInfo.username}</p>
                        <div style="width: 280px;padding-left: 10px;padding-right: 5px;margin-top: 10px">
                            ${userInfo.info}
                        </div>
                    </div>
                </div>
                <div style="width: 300px">
                    <table class="layui-table" lay-size="lg" style="width: 280px;margin-left: 10px">
                        <thead>
                            <tr>
                                <th>选择分类</th>
                            </tr>
                        </thead>
                        <tbody>
                        <tr><td onclick="searchTag(null)">全部</td></tr>
                        <c:forEach items="${tagList}" var="tag">
                            <tr onclick="searchTag(${tag.id})" style="cursor: pointer">
                                <td>${tag.tagName}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>


</html>
