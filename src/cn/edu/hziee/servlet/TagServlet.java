package cn.edu.hziee.servlet;

import cn.edu.hziee.bean.Tag;
import cn.edu.hziee.bean.User;
import cn.edu.hziee.utils.DBUtils;
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

/**
 * @author Mango
 * @Date: 2021/6/8 11:38:16
 */
public class TagServlet extends HttpServlet {

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        String requestURI = request.getRequestURI();
        String prefix = requestURI.substring(requestURI.lastIndexOf("/") + 1, requestURI.lastIndexOf("."));
        if ("toTag".equals(prefix)) {
            gotoPage(request, response, "/jsp/admin/tag.jsp");
        } else if ("queryTags".equals(prefix)) {
            String key = request.getParameter("key");
            String pageNum = request.getParameter("pageNum");
            String pageSize = request.getParameter("pageSize");
            String type = request.getParameter("type");
            DBUtils dbUtils = new DBUtils();
            String[] field = new String[]{"id", "tag_name", "user_id"};
            String condition = " 1 = 1 ";
            List<Tag> tags = new ArrayList<>();
            int count = 0;
            if (type == null) {
                type = "0";
                System.out.println("get in");
            }
            if (type.equals("0")) {
                // 按照 标签名 模糊查询
                if (key != null && !"".equals(key)) {
                    condition += " and tag_name like '%"+key+"%'";
                }
                condition += " order by id desc ";
                List<String[]> countList = dbUtils.find("tag", field, condition);
                count = countList.size();
                int start = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(pageSize);
                condition += " limit " + start + ", " + pageSize;

                List<String[]> fields = dbUtils.find("tag", field, condition);
                for (int i = 0; i < fields.size(); i++) {
                    Tag tag = new Tag();
                    tag.setId(Integer.parseInt(fields.get(i)[0]));
                    tag.setTagName(fields.get(i)[1]);
                    tag.setUserId(Integer.parseInt(fields.get(i)[2]));
                    List<String[]> temp = dbUtils.find("user", new String[]{"username"}, " id = " + tag.getUserId());
                    tag.setUsername(temp.get(0)[0]);
                    tags.add(tag);
                }
            } else {
                // 按照 用户名 模糊查询
                if (key != null && !key.equals("")) {
                    condition += " and username like '%"+key+"%'";
                }
                String tableName = " tag INNER JOIN `user` ON tag.user_id = `user`.id ";
                List<String[]> countList = dbUtils.find(
                        tableName,
                        new String[]{"tag.id", "tag.tag_name", "tag.user_id", "username"},
                        condition
                );
                count = countList.size();
                int start = (Integer.parseInt(pageNum) - 1) * Integer.parseInt(pageSize);
                condition += " order by tag.id desc ";
                condition += " limit " + start + ", " + pageSize;
                List<String[]> fields = dbUtils.find(
                        tableName,
                        new String[]{"tag.id", "tag.tag_name", "tag.user_id", "username"},
                        condition
                );
                for (int i = 0; i < fields.size(); i++) {
                    Tag tag = new Tag();
                    tag.setId(Integer.parseInt(fields.get(i)[0]));
                    tag.setTagName(fields.get(i)[1]);
                    tag.setUserId(Integer.parseInt(fields.get(i)[2]));
                    tag.setUsername(fields.get(i)[3]);
                    tags.add(tag);
                }
            }

            PrintWriter out = response.getWriter();
            Map<String, Object> resultMap = new HashMap<>();
            resultMap.put("code", 0);
            resultMap.put("data", tags);
            resultMap.put("count", count);
            out.write(JSONObject.toJSONString(resultMap));
            out.flush();
        } else if ("removeTagMulti".equals(prefix)) {
            String ids = request.getParameter("ids");
            DBUtils dbUtils = new DBUtils();
            dbUtils.delete("myblog", " tag_id in ( " + ids + " )");
            boolean flag = dbUtils.delete("tag", " id in (" + ids + ") ");
            PrintWriter out = response.getWriter();
            if (flag) {
                out.write("1");
            } else {
                out.write("0");
            }
        } else if ("deleteTag".equals(prefix)) {
            String id = request.getParameter("id");
            DBUtils dbUtils = new DBUtils();
            dbUtils.delete("myblog", " tag_id = " + id);
            boolean flag = dbUtils.delete("tag", " id = " + id);
            PrintWriter out = response.getWriter();
            if (flag) {
                out.write("1");
            } else {
                out.write("0");
            }
        } else if ("blogNums".equals(prefix)) {
            String id = request.getParameter("id");
            DBUtils dbUtils = new DBUtils();
            List<String[]> myblog = dbUtils.find("myblog", new String[]{"id"}, " tag_id = " + id);
            PrintWriter writer = response.getWriter();
            writer.write(myblog.size()+"");
            writer.flush();
        }
    }

    private void gotoPage(HttpServletRequest request, HttpServletResponse response, String path)
            throws ServletException, IOException {
        //请求分派
        RequestDispatcher rd = request.getRequestDispatcher(path);
        rd.forward(request, response);
    }
}
