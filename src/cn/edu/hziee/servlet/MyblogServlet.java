package cn.edu.hziee.servlet;


import cn.edu.hziee.bean.Myblog;
import cn.edu.hziee.bean.Tag;
import cn.edu.hziee.bean.User;
import cn.edu.hziee.utils.DBUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

public class MyblogServlet extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        String prefix = path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.'));
        request.setCharacterEncoding("utf-8");
        DBUtils dbUtils = new DBUtils();
        HttpSession session = request.getSession(false);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if ("main".equals(prefix)){
            String userId = request.getParameter("userId");
            if (userId == null){
                User user =(User)session.getAttribute("user");
                userId = user.getId().toString();
            }
            String condition = "user_id ="+userId;
            String title = request.getParameter("title");
            String tagId = request.getParameter("tagId");
            if (tagId != null){
                condition +="  and tag_id ="+tagId;
            }
            if (title != null){
                condition +=" and title like '%"+title+"%' ";
            }
            condition += " order by add_time desc";
            String[] field = {"id","user_id","title","content","tag_id","add_time","recommend"};
            List<String[]> myblogList = dbUtils.find("myblog", field, condition);
            //普通文章list
            List<Map<String,Object>> list = new ArrayList<>();
            //推荐文章list
            List<Map<String,Object>> list1 = new ArrayList<>();
            for (String[] strings:myblogList){
                Myblog myblog = new Myblog();
                myblog.setId(Integer.parseInt(strings[0]));
                myblog.setUserId(Integer.parseInt(strings[1]));
                myblog.setTitle(strings[2]);
                myblog.setContent(strings[3]);
                myblog.setTagId(Integer.parseInt(strings[4]));
                try {
                    if (strings[5] != null){
                        myblog.setAddTime(simpleDateFormat.parse(strings[5]));
                        myblog.setAddTimeFormat(simpleDateFormat.format(myblog.getAddTime()));
                    }
                }catch (Exception e){
                    e.printStackTrace();
                }
                myblog.setRecommend(Integer.parseInt(strings[6]));
                List<String[]> t = dbUtils.find("tag", new String[]{"id", "tag_name", "user_id"}, "id =" + myblog.getTagId());
                Tag tag = new Tag();
                tag.setId(Integer.parseInt(t.get(0)[0]));
                tag.setTagName(t.get(0)[1]);
                tag.setUserId(Integer.parseInt(t.get(0)[2]));
                Map<String,Object> map = new HashMap<>();
                map.put("myblog",myblog);
                map.put("tag",tag);
                //如果是普通文章则 放入 普通文章list
                if (myblog.getRecommend().equals(0)){
                    list.add(map);
                } else {
                    //推荐文章放入推荐文章list
                    list1.add(map);
                }
            }
            List<String[]> userList = dbUtils.find("user", new String[]{"username", "head_image", "info"}," id ="+userId);
            User user = new User();
            user.setUsername(userList.get(0)[0]);
            user.setHeadImage(userList.get(0)[1]);
            user.setInfo(userList.get(0)[2]);

            List<Tag> tagList = new ArrayList<>();
            List<String[]> t = dbUtils.find("tag", new String[]{"id", "tag_name", "user_id"}, "user_id =" +userId);
            for (String[] strings : t){
                Tag tag = new Tag();
                tag.setId(Integer.parseInt(strings[0]));
                tag.setTagName(strings[1]);
                tag.setUserId(Integer.parseInt(strings[2]));
                tagList.add(tag);
            }

            request.setAttribute("userInfo",user);
            request.setAttribute("list",list);
            request.setAttribute("list1",list1);
            request.setAttribute("tagList",tagList);
            //保存当前查看页面的userid   （可能是管理员登录，查看用户的页面，）
            session.setAttribute("checkedUserId",userId);
            gotoPage(request,response,"/jsp/myblog/main.jsp");
        } else if ("toCreate".equals(prefix)){
            String userId = request.getParameter("userId");
            List<Tag> tagList = new ArrayList<>();
            List<String[]> t = dbUtils.find("tag", new String[]{"id", "tag_name", "user_id"}, "user_id =" +userId);
            for (String[] strings : t){
                Tag tag = new Tag();
                tag.setId(Integer.parseInt(strings[0]));
                tag.setTagName(strings[1]);
                tag.setUserId(Integer.parseInt(strings[2]));
                tagList.add(tag);
            }

            request.setAttribute("tagList",tagList);
            gotoPage(request,response,"/jsp/myblog/create.jsp");
        } else if ("create".equals(prefix)){
            User user = (User)session.getAttribute("user");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String tagId = request.getParameter("tagId");
            String now = simpleDateFormat.format(new Date());
            String[] field = {"user_id","title","content","tag_id","add_time","recommend"};
            String[] value = {user.getId().toString(),title,content,tagId,now,"0"};
            boolean flag = dbUtils.add("myblog", field, value);
            if (flag){
                response.sendRedirect("main.myblog");
            } else {
                request.setAttribute("message","创建失败");
                gotoPage(request,response,"/jsp/myblog/create.jsp");
            }
        } else if ("detail".equals(prefix)){
            String blogId = request.getParameter("blogId");
            String[] field = {"id","user_id","title","content","tag_id","add_time","recommend"};
            List<String[]> list = dbUtils.find("myblog", field, "id =" + blogId);
            Myblog myblog = new Myblog();
            String[] strings = list.get(0);
            myblog.setId(Integer.parseInt(strings[0]));
            myblog.setUserId(Integer.parseInt(strings[1]));
            myblog.setTitle(strings[2]);
            myblog.setContent(strings[3]);
            myblog.setTagId(Integer.parseInt(strings[4]));
            try{
                if (strings[5] != null){
                    myblog.setAddTime(simpleDateFormat.parse(strings[5]));
                    myblog.setAddTimeFormat(simpleDateFormat.format(myblog.getAddTime()));
                }
            }catch (Exception e){
                e.printStackTrace();
            }
            myblog.setRecommend(Integer.parseInt(strings[6]));
            List<String[]> list1 = dbUtils.find("tag", new String[]{"tag_name"}, "id =" + myblog.getTagId());
            request.setAttribute("myblog",myblog);
            request.setAttribute("tagName",list1.get(0)[0]);
            gotoPage(request,response,"/jsp/myblog/detail.jsp");
        } else if ("delete".equals(prefix)){
            String blogId = request.getParameter("blogId");
            boolean flag = dbUtils.delete("myblog", "id =" + blogId);
            if (flag){
                gotoPage(request,response,"main.myblog");
            } else {
                request.setAttribute("message","删除失败");
                gotoPage(request,response,"/jsp/myblog/detail.jsp");
            }
        } else if ("toEdit".equals(prefix)){
            String userId = request.getParameter("userId");
            String blogId = request.getParameter("blogId");
            String[] field = {"id","user_id","title","content","tag_id","add_time","recommend"};
            List<String[]> list = dbUtils.find("myblog", field, "id =" + blogId);
            String[] strings = list.get(0);
            Myblog myblog = new Myblog();
            myblog.setId(Integer.parseInt(strings[0]));
            myblog.setUserId(Integer.parseInt(strings[1]));
            myblog.setTitle(strings[2]);
            myblog.setContent(strings[3]);
            myblog.setTagId(Integer.parseInt(strings[4]));
            try{
                if (strings[5] != null){
                    myblog.setAddTime(simpleDateFormat.parse(strings[5]));
                    myblog.setAddTimeFormat(simpleDateFormat.format(myblog.getAddTime()));
                }
            }catch (Exception e){
                e.printStackTrace();
            }
            myblog.setRecommend(Integer.parseInt(strings[6]));

            List<String[]> list1 = dbUtils.find("tag", new String[]{"id", "tag_name", "user_id"}, " user_id = " + userId);
            List<Tag> tagList = new ArrayList<>();
            for (String[] strings1 : list1){
                Tag tag = new Tag();
                tag.setId(Integer.parseInt(strings1[0]));
                tag.setTagName(strings1[1]);
                tag.setUserId(Integer.parseInt(strings1[2]));
                tagList.add(tag);
            }
            request.setAttribute("myblog",myblog);
            request.setAttribute("tagList",tagList);
            gotoPage(request,response,"/jsp/myblog/edit.jsp");
        } else if ("edit".equals(prefix)){
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String tagId = request.getParameter("tagId");
            String blogId = request.getParameter("blogId");

            String[] field = {"title","content","tag_id"};
            String[] value = {title ,content , tagId };
            boolean flag = dbUtils.edit("myblog", field, value, " id = " + blogId);
            if (flag){
                gotoPage(request,response,"detail.myblog");
            } else {
                request.setAttribute("message","修改失败");
                gotoPage(request,response,"toEdit.myblog");
            }
        } else if ("setRecommend".equals(prefix)){
            String blogId = request.getParameter("blogId");
            String action = request.getParameter("action");
            String[] value = {action};
            boolean flag = dbUtils.edit("myblog", new String[]{"recommend"}, value, " id =" + blogId);
            if (flag){
                request.setAttribute("message","修改成功");
            } else {
                request.setAttribute("message","修改失败");
            }
            gotoPage(request,response,"detail.myblog");
        }
    }

    private void gotoPage(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        //请求分派
        RequestDispatcher rd = request.getRequestDispatcher(path);
        rd.forward(request, response);
    }
}
