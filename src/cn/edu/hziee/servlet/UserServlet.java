package cn.edu.hziee.servlet;

import cn.edu.hziee.bean.User;
import cn.edu.hziee.utils.DBUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.UUID;

public class UserServlet extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        String prefix = path.substring(path.lastIndexOf('/') + 1, path.lastIndexOf('.'));
        request.setCharacterEncoding("utf-8");
        DBUtils dbUtils = new DBUtils();
        HttpSession session = request.getSession(false);
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if ("login".equals(prefix)){
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String[] field = {"id","username","password","head_image","info","role"};
            List<String[]> list = dbUtils.find("user", field, "username = '" + username + "' and password = '" + password + "'");
            if (list.size() == 0){
                request.setAttribute("message","用户名或密码错误！");
                gotoPage(request,response,"/jsp/user/login.jsp");
            } else{
                String[] strings = list.get(0);
                User user = new User();
                user.setId(Integer.parseInt(strings[0]));
                user.setUsername(strings[1]);
                user.setPassword(strings[2]);
                user.setHeadImage(strings[3]);
                user.setInfo(strings[4]);
                user.setRole(Integer.parseInt(strings[5]));
                session.setAttribute("user",user);
                if (user.getRole() == 0){
                    //跳转到用户主页
                    gotoPage(request,response,"main.myblog");
                } else {
                    gotoPage(request,response,"toIndex.admin");
                }
            }
        } else if ("register".equals(prefix)){
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            boolean checkLogin = dbUtils.checkLogin("user", "username = '" + username + "'");
            if (checkLogin){
                request.setAttribute("message","该用户名已被注册");
                gotoPage(request,response,"/jsp/user/register.jsp");
            } else {
                String[] field = {"username","password","role","head_image"};
                String[] value = {username,password,"0","default.jpg"};
                if (dbUtils.add("user",field,value)){
                    gotoPage(request,response,"/jsp/user/login.jsp");
                } else {
                    request.setAttribute("message","注册失败！");
                    gotoPage(request,response,"/jsp/user/register.jsp");
                }

            }
        } else if ("logout".equals(prefix)){
            session.removeAttribute("user");
            gotoPage(request,response,"/jsp/user/login.jsp");
        } else if ("edit".equals(prefix)){
            response.setContentType("text/html;charset=utf-8");
            DiskFileItemFactory factory = new DiskFileItemFactory();
            File f = new File("/Users/zhoumx/Desktop/upload");
            if (!f.exists()) {
                f.mkdirs();
            }
            factory.setRepository(f);// 设置临时缓存目录
            ServletFileUpload upload = new ServletFileUpload(factory);
            try {
                String username = "";
                String password = "";
                String info = "";
                String headImage = "";

                String pictureName = "";
                List<FileItem> list = upload.parseRequest(request);
                for (FileItem item : list) {
                    if (item.isFormField()) {// 普通字段
                        String fieldName = item.getFieldName();
                        String value = item.getString("UTF-8");
                        if(fieldName.equals("username")){
                            username = value;
                        }
                        if(fieldName.equals("password")){
                            password = value;
                        }
                        if(fieldName.equals("info")){
                            info = value;
                        }
                    } else {// 文件字段
                        String filename = item.getName();
                        String os = System.getProperty("os.name");
                        if (os.contains("indows")) {
                            if (filename.contains("\\"))
                                filename = filename.substring(filename.lastIndexOf("\\"));
                        } else {
                            if (filename.contains("/"))
                                filename = filename.substring(filename.lastIndexOf("/"));
                        }
                        // 上传文件开始
                        // 步骤1：得到文件输入流
                        InputStream in = item.getInputStream();
                        // 步骤2：设置输出流对应的File
                        headImage = UUID.randomUUID().toString()+filename.substring(filename.indexOf('.'));
                        String realPath = this.getServletContext().getRealPath( "/static/image/" +headImage);
                        File file = new File(realPath);
                        file.getParentFile().mkdirs();
                        file.createNewFile();// 新建一个长度为0字节的文件
                        // 步骤3：新建输出流
                        FileOutputStream fileOut = new FileOutputStream(file);
                        // 定义字节数组，用于每次读取输入流的数据存储
                        byte[] buffer = new byte[1024];
                        int len;
                        while ((len = in.read(buffer)) > 0) {
                            fileOut.write(buffer, 0, len);
                        }

                        // 关闭流
                        in.close();
                        fileOut.close();
                        // 删除临时文件
                        item.delete();
                    }
                }
                User user = (User)session.getAttribute("user");
                String[] field;
                String[] value;
                if ("".equals(headImage)){
                    field = new String[]{"username", "password","info"};
                    value = new String[]{username,password,info};
                }else{
                    //如果有图片
                    field = new String[]{"username", "password", "head_image","info"};
                    value = new String[]{username,password,headImage,info};
                }
                if (dbUtils.edit("user", field, value,"id = "+user.getId())){
                    User newUser = new User();
                    newUser.setId(user.getId());
                    newUser.setUsername(username);
                    newUser.setPassword(password);
                    newUser.setHeadImage(headImage);
                    newUser.setInfo(info);
                    newUser.setRole(user.getRole());

                    session.removeAttribute("user");
                    session.setAttribute("user",newUser);

                    request.setAttribute("message","修改成功");
                } else {
                    request.setAttribute("message","修改失败");

                }
                gotoPage(request,response,"/jsp/user/info.jsp");
            } catch (Exception e) {
                e.printStackTrace();
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
