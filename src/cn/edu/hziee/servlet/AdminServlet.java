package cn.edu.hziee.servlet;

import cn.edu.hziee.bean.User;
import cn.edu.hziee.utils.DBUtils;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        String requestURI = request.getRequestURI();
        String prefix = requestURI.substring(requestURI.lastIndexOf("/") + 1, requestURI.lastIndexOf("."));
        if ("toIndex".equals(prefix)) {
            gotoPage(request, response, "/jsp/admin/index.jsp");
        } else if ("queryUsers".equals(prefix)) {
            String username = request.getParameter("username");
            String pageNum = request.getParameter("pageNum");
            String pageSize = request.getParameter("pageSize");
            DBUtils dbUtils = new DBUtils();
            String[] field = new String[]{"id", "username", "password", "head_image", "info"};
            String condition = " role = 0 ";
            if (username != null && username != "") {
                condition += " and username like '%"+username+"%'";
            }
            condition += " order by id desc ";
            List<String[]> countList = dbUtils.find("user", field, condition);
            int start = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(pageSize);
            condition += " limit " + start + ", " + pageSize;
            List<String[]> fields = dbUtils.find("user", field, condition);
            List<User> users = new ArrayList<>();
            for (int i = 0; i < fields.size(); i++) {
                User user = new User();
                user.setId(Integer.parseInt(fields.get(i)[0]));
                user.setUsername(fields.get(i)[1]);
                user.setPassword(fields.get(i)[2]);
                user.setHeadImage(fields.get(i)[3]);
                user.setInfo(fields.get(i)[4]);
                users.add(user);
            }
            PrintWriter out = response.getWriter();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("code", 0);
            resultMap.put("data", users);
            resultMap.put("count", countList.size());
            out.write(JSONObject.toJSONString(resultMap));
            out.flush();
        } else if ("addUser".equals(prefix)) {
            String username = request.getParameter("username");
            DBUtils dbUtils = new DBUtils();
            List<String[]> user = dbUtils.find("user", new String[]{"username"}, " username = '" + username + "'");
            PrintWriter writer = response.getWriter();
            if (user.size() > 0) {
                writer.write("-1");
                writer.flush();
                return;
            }
            String password = request.getParameter("password");
            String info = request.getParameter("info");
            String[] field = new String[]{"username", "password", "head_image", "info", "role"};
            String[] value = new String[]{username, password, "default.png", info, 0+""};
            boolean result = dbUtils.add("user", field, value);
            if (result) {
                writer.write("1");
            } else {
                writer.write("0");
            }
            writer.flush();
        }else if ("addTag".equals(prefix)) {
            String tag_name = request.getParameter("tag_name");
            DBUtils dbUtils = new DBUtils();
            PrintWriter writer = response.getWriter();
            List<String[]> tag = dbUtils.find("tag", new String[]{"tag_name"}, " tag_name = '" + tag_name + "'");

            if (tag.size() > 0) {
                writer.write("-1");
                writer.flush();
                return;
            }
            String user_id = request.getParameter("user_id");
            List<String[]> user = dbUtils.find("user",new String[]{"username"}," username = '" + user_id + "'");
            if (user.size() == 0) {
                writer.write("-2");
                writer.flush();
                return;
            }
            String[] field = new String[]{"tag_name", "user_id"};
            String[] value = new String[]{tag_name, user_id};
            boolean result = dbUtils.add("tag", field, value);
            if (result) {
                writer.write("1");
            } else {
                writer.write("0");
            }
            writer.flush();
        } else if ("userInfo".equals(prefix)) {
            String id = request.getParameter("id");
            DBUtils dbUtils = new DBUtils();
            List<String[]> list = dbUtils.find("user", new String[]{"id", "username", "password", "head_image", "info", "role"}, " id = " + id);
            User user = new User();
            user.setId(Integer.parseInt(list.get(0)[0]));
            user.setUsername(list.get(0)[1]);
            user.setPassword(list.get(0)[2]);
            user.setInfo(list.get(0)[4]);
            PrintWriter writer = response.getWriter();
            writer.write(JSONObject.toJSONString(user));
            writer.flush();
        } else if ("updateUserInfo".equals(prefix)) {
            String id = request.getParameter("id");
            DBUtils dbUtils = new DBUtils();
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String info = request.getParameter("info");
            String[] field = new String[]{"username", "password", "info"};
            String[] value = new String[]{username, password, info};
            boolean result = dbUtils.edit("user", field, value, " id = " + id);
            PrintWriter out = response.getWriter();
            if (result) {
                out.write("1");
            } else {
                out.write("0");
            }
            out.flush();
        } else if ("deleteUser".equals(prefix)) {
            String id = request.getParameter("id");
            DBUtils dbUtils = new DBUtils();
            dbUtils.delete("tag", " user_id = " + id);
            dbUtils.delete("myblog", " user_id = " + id);
            boolean flag = dbUtils.delete("user", " id = " + id);
            PrintWriter out = response.getWriter();
            if (flag) {
                out.write("1");
            } else {
                out.write("0");
            }
        } else if ("resetPassword".equals(prefix)) {
            String id = request.getParameter("id");
            DBUtils dbUtils = new DBUtils();
            boolean flag = dbUtils.edit(
                    "user",
                    new String[]{"password"},
                    new String[]{"123456"},
                    " id = " + id);

            PrintWriter out = response.getWriter();
            if (flag) {
                out.write("1");
            } else {
                out.write("0");
            }
        } else if ("removeUserMulti".equals(prefix)) {
            String ids = request.getParameter("ids");
            DBUtils dbUtils = new DBUtils();
            dbUtils.delete("tag", " user_id in ( " + ids + " )");
            dbUtils.delete("myblog", " user_id in ( " + ids + " )");
            boolean flag = dbUtils.delete("user", " id in (" + ids + ") ");
            PrintWriter out = response.getWriter();
            if (flag) {
                out.write("1");
            } else {
                out.write("0");
            }
        }
    }

    private void gotoPage(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        //请求分派
        RequestDispatcher rd = request.getRequestDispatcher(path);
        rd.forward(request, response);
    }
}
