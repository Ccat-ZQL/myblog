<%--
  Created by IntelliJ IDEA.
  User: Mango
  Date: 2021/6/8
  Time: 11:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>文章标签管理</title>
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

    <div style="margin-bottom: 5px;">

        <!-- 示例-970 -->
        <ins class="adsbygoogle" style="display:inline-block;width:970px;height:90px" data-ad-client="ca-pub-6111334333458862" data-ad-slot="3820120620"></ins>

    </div>

    <div class="demoTable" style="margin-top: 10px">
        <label for="demoReload">搜索关键字：</label>
        <div class="layui-inline">
            <input class="layui-input" name="id" id="demoReload" autocomplete="off">
        </div>
        <label for="demoReload">搜索类型：</label>
        <select name="type" id="type" class="layui-select" style="width: 150px;">
            <option value="0" selected>标签名称</option>
            <option value="1">用户名称</option>
        </select>
        <button class="layui-btn layui-btn-primary layui-border-green" data-type="reload" style="margin-left: 15px">搜索</button>
        <button class="layui-btn reset layui-btn-primary layui-border-blue" data-type="reload" id="resetInput">清空</button>
        <button class="layui-btn layui-btn-primary layui-border-green" id="addTag" style="float: right; margin-right: 30px">添加标签</button>
        <button class="layui-btn layui-btn-primary layui-border-blue" onclick="removeTagMulti()" id="removeUserMulti" style="float: right; margin-right: 30px">批量删除</button>
    </div>
    <table class="layui-table" id="test" lay-filter="tags"></table>

    <script type="text/html" id="toolbarDemo">
        <div class="layui-btn-container">
            <button type="button" class="layui-btn layui-btn-sm layui-btn-danger" lay-event="deleteTag">删除</button>
            <button type="button" class="layui-btn layui-btn-sm layui-btn-normal" lay-event="viewInfo" class="viewInfo">查看详情</button>
        </div>
    </script>
</body>


<script src="${pageContext.request.contextPath}/static/js/jquery-3.1.1.min.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.js" charset="utf-8"></script>
<script src="${pageContext.request.contextPath}/static/layui/layui.js" charset="utf-8"></script>
<script>
    layui.use('table', function(){
        var table = layui.table;
        table.render({
            elem: '#test'
            ,url:'${pageContext.request.contextPath}/queryTags.tag'
            ,toolbar: true
            ,title: '用户标签管理'
            ,totalRow: true
            ,id: "tagTable"
            ,cols: [[
                {type: 'checkbox', width:'5%'}
                ,{field: 'id', title: 'ID'}
                ,{title: '序号', width:'15%', type: 'numbers'}
                ,{field: 'tagName', title: '标签名', width:'20%'}
                ,{field: 'username', title: '用户名', width:'30%'}
                ,{title:'操作', toolbar: '#toolbarDemo', width:'30%'}
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
        table.on('tool(tags)', function(obj){
            var data = obj.data;
            if(obj.event === 'deleteTag'){
                layer.confirm("是否删除用户 " + data.username + " 的标签 "+data.tagName+"(以及该标签的所有文章)", function(index){
                    $.ajax({
                        url: "${pageContext.request.contextPath}/deleteTag.tag",
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
            } else if (obj.event === 'viewInfo') {
                $.ajax({
                    type: "get",
                    url: "${pageContext.request.contextPath}/blogNums.tag",
                    dataType: "json",
                    data: {
                        "id": data.id
                    },
                    success: function (res) {
                        if (res != null) {
                            layer.open({
                                type: 1,
                                area: ['600px', "200px"],
                                shadeClose: false, //点击遮罩关闭
                                title: "",
                                content: "<div style='position: absolute;\n" +
                                    "    left:50%;\n" +
                                    "    top:50%;\n" +
                                    "    transform: translate(-50%, -50%); width: 100%; text-align: center'><span style=\"font-size: larger; font-weight: bold\">"+data.username+" 用户的 "+data.tagName+"" +
                                    "标签的文章数量: "+res+"篇</span></div>",
                            });
                        } else {
                            alert("请求出错了，请稍后再试")
                        }
                    },
                    error: function (res) {
                        alert(res)
                        console.log(res);
                        alert("请求出错了，请稍后再试")
                    }
                })
            }
        });

        /**
         * 按用户名模糊查询
         * */
        var $ = layui.$, active = {
            reload: function(){
                //执行重载
                table.reload('tagTable', {
                    url: "${pageContext.request.contextPath}/queryTags.tag",
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        key: $('#demoReload').val(),
                        type: $("#type").val()
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
                $("#type").selectedIndex = 0
                //执行重载
                table.reload('tagTable', {
                    url: "${pageContext.request.contextPath}/queryTags.tag",
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    ,where: {
                        key: "",
                        type: 0
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
    })

    function removeTagMulti() {
        let checkStatus = layui.table.checkStatus('tagTable').data;
        let ids = [];
        for (let i = 0; i < checkStatus.length; i++) {
            ids.push(checkStatus[i].id);
        }
        if (ids.length === 0) {
            alert("请先选择标签");
            return
        }
        if (confirm("是否删除这些用户的标签(包含文章)")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/removeTagMulti.tag",
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

    //弹出一个页面层
    $('#addTag').on('click', function(){
        layer.open({
            type: 1,
            area: ['800px', "500px"],
            shadeClose: false, //点击遮罩关闭
            title: "<span style=\"font-size: larger; font-weight: bold\">添加标签</span>",
            content: "<div style='margin-top: 30px; width:80%; margin: 50px auto; font-weight:bold'><div class='form-group'>" +
                "<label for='name' class='modal-span'>标签名称</label>" +
                "<input type='text' class='form-control' id='tag_name' " +
                "placeholder='请输入标签名称'>" +
                "</div>" +
                "<div class='form-group'>" +
                "<label for='name' class='modal-span'>用户名</label>" +
                "<input type='text' class='form-control' id='user_id' " +
                "placeholder='请输入用户名'>" +
                "</div><button type='button' class='btn btn-primary' data-dismiss='modal' style='float: right; margin-top: 10px' onclick='addTag()'>提交</button>" +
                "<button type='button' class='btn btn-danger' data-dismiss='modal' style='float: right; margin-top: 10px; margin-right: 10px' onclick='closeModal()'>关闭</button>" +
                "</div>"
        });

    });

    function addTag() {
        let tag_name = $("#tag_name").val();
        if (tag_name == null || tag_name == "") {
            alert("请输入标签名");
            return
        }
        let user_id = $("#user_id").val();
        if (user_id == null || user_id == "") {
            alert("请输入用户名");
            return
        }
        // let info = $("#info").val();
        $.ajax({
            url: "${pageContext.request.contextPath}/addTag.admin",
            type: "post",
            dataType: "json",
            data: {
                "tag_name": tag_name,
                "user_id": user_id
            },
            success: function (res) {
                if (res === 1) {
                    $("#tag_name").val("");
                    $("#user_id").val("");
                    updateTableData();
                    alert("添加成功");
                    layer.closeAll();
                } else if (res === -1) {
                    alert("该名已经存在")
                } else if (res === -2) {
                    alert("该用户不存在")
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
        $("#tag_name").val("");
        $("#user_id").val("");
        layer.closeAll();
    }

</script>
</html>
