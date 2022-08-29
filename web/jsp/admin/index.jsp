<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/layui/css/layui.css"  media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/bootstrap.css"  media="all">
</head>
<body>

<div>
    <ul class="layui-nav layui-bg-cyan">
        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/toIndex.admin">用户管理</a></li>
        <li class="layui-nav-item"><a href="${pageContext.request.contextPath}/toTag.tag">文章标签管理</a></li>
        <li class="layui-nav-item" style="float: right"><a href="${pageContext.request.contextPath}/logout.user">退出登录</a></li>
    </ul>
</div>
<!--放大图的imgModal-->
<div class="modal fade bs-example-modal-lg text-center" id="imgModal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" >
    <div class="modal-dialog modal-lg" style="display: inline-block; width: auto;">
        <div class="modal-content">
            <img  id="imgInModalID"
                  class="carousel-inner img-responsive img-rounded"
                  onclick="closeImageViewer()"
                  onmouseover="this.style.cursor='pointer';this.style.cursor='hand'"
                  onmouseout="this.style.cursor='default'"
            />
        </div>
    </div>
</div>
<div style="margin-bottom: 5px;">

    <!-- 示例-970 -->
    <ins class="adsbygoogle" style="display:inline-block;width:970px;height:90px" data-ad-client="ca-pub-6111334333458862" data-ad-slot="3820120620"></ins>

</div>

    <div class="demoTable" style="margin-top: 10px">
        <label for="demoReload">搜索关键字：</label>
        <div class="layui-inline">
            <input class="layui-input" name="id" id="demoReload" autocomplete="off">
        </div>
        <button class="layui-btn layui-btn-primary layui-border-green" data-type="reload" style="margin-left: 15px">搜索</button>
        <button class="layui-btn reset layui-btn-primary layui-border-blue" data-type="reload" id="resetInput">清空</button>
        <button class="layui-btn layui-btn-primary layui-border-green" id="addUser" style="float: right; margin-right: 30px">添加用户</button>
        <button class="layui-btn layui-btn-primary layui-border-blue" onclick="removeUserMulti()" id="removeUserMulti" style="float: right; margin-right: 10px">批量删除</button>
    </div>
    <table class="layui-table" id="test" lay-filter="user"></table>



<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button type="button" class="layui-btn layui-btn-sm" lay-event="editInfo">编辑信息</button>
        <button type="button" class="layui-btn layui-btn-sm layui-btn-warm" lay-event="resetPwd">重置密码</button>
        <button type="button" class="layui-btn layui-btn-sm layui-btn-danger" lay-event="deleteUser">删除</button>
        <button type="button" class="layui-btn layui-btn-sm layui-btn-normal" lay-event="viewBlog">查看文章</button>
    </div>
</script>



<script src="${pageContext.request.contextPath}/static/js/jquery-3.1.1.min.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/layui/layui.js" charset="utf-8"></script>
<!-- 注意：如果你直接复制所有代码到本地，上述 JS 路径需要改成你本地的 -->
<script>
    layui.use('table', function(){
        var table = layui.table;
        table.render({
            elem: '#test'
            ,url:'${pageContext.request.contextPath}/queryUsers.admin'
            ,toolbar: true
            ,title: '用户数据表'
            ,totalRow: true
            ,id: "userTable"
            ,cols: [[
                {type: 'checkbox', width:'5%'}
                ,{field: 'id', title: 'ID'}
                ,{title: '序号', width:'15%', type: 'numbers'}
                ,{field: 'username', title: '用户名', width:'15%'}
                ,{field: 'head_image', title: '头像(点击查看大图)', width:'15%', templet: function (data) {
                        return "<img title='点我查看大图' onclick='showImage(\""+"${pageContext.request.contextPath}/static/image/" +data.headImage+"\")' " +
                            "style='height:15px; width:20px' src='${pageContext.request.contextPath}/static/image/"+data.headImage+"'" +
                            "/>";
                    }}
                ,{field: 'info', title: '个人信息', width:'30%'}
                ,{title:'操作', toolbar: '#toolbarDemo', width:'20%'}
            ]]
            ,done: function () {
                $("[data-field='id']").css('display','none');
                $('td').css({"text-align" : "center"});
                $('th').css({"text-align" : "center"});
            }
            ,page: { //支持传入 laypage 组件的所有参数（某些参数除外，如：jump/elem） - 详见文档
                layout: ['limit', 'count', 'prev', 'page', 'next'] //自定义分页布局
                ,groups: 3 //只显示 3 个连续页码
                ,first: '首页' //首页
                ,prev: '上一页'
                ,next: '下一页'
                ,last: '尾页' //尾页
                ,limit:6
                ,limits:[6,12]
            }
            ,response: {
                statusCode: 200 //重新规定成功的状态码为 200，table 组件默认为 0
            }
            ,request: {
                pageName: 'pageNum' //页码的参数名称，默认：page
                ,limitName: 'pageSize' //每页数据量的参数名，默认：limit
            }
            ,parseData: function(res){ //将原始数据解析成 table 组件所规定的数据
                return {
                    "code": 200, //解析接口状态
                    // "msg": "", //解析提示文本
                    "count": res.count, //解析数据长度
                    "data": res.data //解析数据列表
                };
            }
        });

        //监听工具条
        table.on('tool(user)', function(obj){
            var data = obj.data;
            if(obj.event === 'editInfo'){
                $.ajax({
                    type: "get",
                    url: "${pageContext.request.contextPath}/userInfo.admin",
                    dataType: "json",
                    data: {
                        "id": data.id
                    },
                    success: function (res) {
                        if (res != null) {
                            layer.open({
                                type: 1,
                                area: ['800px', "500px"],
                                shadeClose: false, //点击遮罩关闭
                                title: "<span style=\"font-size: larger; font-weight: bold\">添加用户</span>",
                                content: "<div style='margin-top: 30px; width:80%; margin: 50px auto; font-weight:bold'><div class='form-group'>" +
                                    "<label for='name' class='modal-span'>用户名称</label>" +
                                    "<input type='text' class='form-control' disabled id='username' value='"+res.username+"' " +
                                    "placeholder='请输入用户姓名'>" +
                                    "</div>" +
                                    "<div class='form-group'>" +
                                    "<label for='name' class='modal-span'>用户密码</label>" +
                                    "<input type='password' class='form-control' id='password' value='"+res.password+"'  " +
                                    "placeholder='请输入用户密码'>" +
                                    "</div>" +
                                    "<div class='form-group'>" +
                                    "<label for='info' class='modal-span'>个性签名</label>" +
                                    " <textarea class='form-control' id='info'" +
                                    " name='sign' rows='5' style='min-width: 90%'>"+res.info+"</textarea>" +
                                    "</div><button type='button' class='btn btn-primary' data-dismiss='modal' style='float: right; margin-top: 10px' onclick='updateUser("+data.id+")'>更新</button>" +
                                    "<button type='button' class='btn btn-danger' data-dismiss='modal' style='float: right; margin-top: 10px; margin-right: 10px' onclick='closeModal()'>关闭</button>" +
                                    "</div>"
                            });
                        } else {
                            alert("请求出错了，请稍后再试")
                        }
                    },
                    error: function () {
                        alert("请求出错了，请稍后再试")
                    }
                })
            } else if(obj.event === 'resetPwd'){
                layer.confirm('是否重置 ' + data.username + " 的密码", function(index){
                    $.ajax({
                        url: "${pageContext.request.contextPath}/resetPassword.admin",
                        type: "get",
                        dataType: "json",
                        data: {
                            "id": data.id
                        },
                        success: function (res) {
                            if (res == 1) {
                                alert("重置密码成功，密码为123456")
                            } else {
                                alert("重置密码失败")
                            }
                            layer.close(index);
                        },
                        error: function () {
                            alert("出错了，请稍后再试！");
                            layer.close(index);
                        }
                    })
                });
            } else if(obj.event === 'deleteUser'){
                layer.confirm("是否删除用户名为 " + data.username + " 的用户(以及该用户的所有文章)", function(index){
                    $.ajax({
                        url: "${pageContext.request.contextPath}/deleteUser.admin",
                        type: "get",
                        dataType: "json",
                        data: {
                            "id": data.id
                        },
                        success: function (res) {
                            if (res == 1) {
                                alert("删除成功");
                                updateTableData()
                            } else {
                                alert("删除失败")
                            }
                            layer.close(index);
                        },
                        error: function () {
                            alert("出错了，请稍后再试！");
                            layer.close(index);
                        }
                    })
                });
            } else if (obj.event === 'viewBlog') {
                window.location.href = "${pageContext.request.contextPath}/main.myblog?userId="+data.id;
            }
        });


        /**
         * 按用户名模糊查询
         * */
        var $ = layui.$, active = {
            reload: function(){
                var demoReload = $('#demoReload');

                //执行重载
                table.reload('userTable', {
                    url: "${pageContext.request.contextPath}/queryUsers.admin",
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        username: demoReload.val()
                    }
                });
            }
        };
        /***
         * 重置输入框
         * */
        var $ = layui.$, active2 = {
            reload: function(){
                $('#demoReload').val("");
                //执行重载
                table.reload('userTable', {
                    url: "${pageContext.request.contextPath}/queryUsers.admin",
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        username: ""
                    }
                });
            }
        };

        $('.demoTable .layui-btn').on('click', function(){
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });
        $('.demoTable .reset').on('click', function(){
            var type = $(this).data('type');
            active2[type] ? active2[type].call(this) : '';
        });
    });

    function removeUserMulti() {
        let checkStatus = layui.table.checkStatus('userTable').data;
        let ids = [];
        for (let i = 0; i < checkStatus.length; i++) {
            ids.push(checkStatus[i].id);
        }
        if (ids.length === 0) {
            alert("请先选择用户");
            return
        }
        if (confirm("是否删除这些用户")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/removeUserMulti.admin",
                dataType: "json",
                data: {
                    "ids": ids.join(",")
                },
                success: function (res) {
                    if (res === 1) {
                        updateTableData();
                        alert("删除成功")
                    } else {
                        alert("删除失败")
                    }
                },
                error: function () {
                    alert("出错了，请稍后重试")
                }
            })
        }
    }

    /**
     * 刷新表格数据
     */
    function updateTableData() {
        $("#resetInput").click()
    }

    function updateUser(id) {
        let username = $("#username").val();
        if (username == null || username == "") {
            alert("请输入用户名");
            return
        }
        let password = $("#password").val();
        if (password == null || password == "") {
            alert("请输入用户密码");
            return
        }
        let info = $("#info").val();
        $.ajax({
            url: "${pageContext.request.contextPath}/updateUserInfo.admin",
            type: "post",
            dataType: "json",
            data: {
                "id": id,
                "username": username,
                "password": password,
                "info": info
            },
            success: function (res) {
                if (res == 1) {
                    $("#username").val("");
                    $("#password").val("");
                    $("#info").val("");
                    updateTableData();
                    alert("更新成功");
                    layer.closeAll();
                } else {
                    alert("更新失败")
                }
            },
            error: function () {
                alert("出错了，请稍后再试！")
            }
        })
    }

    //弹出一个页面层
    $('#addUser').on('click', function(){
        layer.open({
            type: 1,
            area: ['800px', "500px"],
            shadeClose: false, //点击遮罩关闭
            title: "<span style=\"font-size: larger; font-weight: bold\">添加用户</span>",
            content: "<div style='margin-top: 30px; width:80%; margin: 50px auto; font-weight:bold'><div class='form-group'>" +
                "<label for='name' class='modal-span'>用户名称</label>" +
                "<input type='text' class='form-control' id='username' " +
                "placeholder='请输入用户姓名'>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='name' class='modal-span'>用户密码</label>" +
                "<input type='password' class='form-control' id='password' " +
                "placeholder='请输入用户密码'>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='info' class='modal-span'>个性签名</label>" +
                " <textarea class='form-control' id='info'" +
                " name='sign' rows='5' style='min-width: 90%'></textarea>" +
                "</div><button type='button' class='btn btn-primary' data-dismiss='modal' style='float: right; margin-top: 10px' onclick='addUser()'>提交</button>" +
                "<button type='button' class='btn btn-danger' data-dismiss='modal' style='float: right; margin-top: 10px; margin-right: 10px' onclick='closeModal()'>关闭</button>" +
                "</div>"
        });

    });

    function addUser() {
        let username = $("#username").val();
        if (username == null || username == "") {
            alert("请输入用户名");
            return
        }
        let password = $("#password").val();
        if (password == null || password == "") {
            alert("请输入用户密码");
            return
        }
        let info = $("#info").val();
        $.ajax({
            url: "${pageContext.request.contextPath}/addUser.admin",
            type: "post",
            dataType: "json",
            data: {
                "username": username,
                "password": password,
                "info": info
            },
            success: function (res) {
                if (res === 1) {
                    $("#username").val("");
                    $("#password").val("");
                    $("#info").val("");
                    updateTableData();
                    alert("添加成功");
                    layer.closeAll();
                } else if (res === -1) {
                    alert("该用户名已经存在")
                } else {
                    alert("发生错误，请稍后重试")
                }
            },
            error: function () {
                alert("出错了，请稍后重试")
            }
        })
    }

    function closeModal() {
        $("#username").val("");
        $("#password").val("");
        $("#info").val("");
        layer.closeAll();
    }

    //显示大图
    function showImage(source) {
        $("#imgModal").find("#imgInModalID").attr("src",source);
        $("#imgModal").modal("show");
    }
    //关闭
    function closeImageViewer() {
        $("#imgModal").modal('hide');
    }
</script>


</body>
</html>