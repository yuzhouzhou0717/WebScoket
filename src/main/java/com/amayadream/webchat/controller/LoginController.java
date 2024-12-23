package com.amayadream.webchat.controller;

import com.amayadream.webchat.pojo.User;
import com.amayadream.webchat.service.ILogService;
import com.amayadream.webchat.service.IUserService;
import com.amayadream.webchat.utils.CommonDate;
import com.amayadream.webchat.utils.LogUtil;
import com.amayadream.webchat.utils.NetUtil;
import com.amayadream.webchat.utils.WordDefined;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/user")
public class LoginController {

    @Resource
    private IUserService userService;

    @Resource
    private ILogService logService;

    // 登录页面显示
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login() {
        return "login";
    }

    // 登录处理
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(String userid, String password, HttpSession session, RedirectAttributes attributes,
                        WordDefined defined, CommonDate date, LogUtil logUtil, NetUtil netUtil, HttpServletRequest request) {
        String ip = netUtil.getIpAddress(request);
        User user = userService.selectUserByUserid(userid);
        if (user == null) {
            attributes.addFlashAttribute("error", defined.LOGIN_USERID_ERROR);
            return "redirect:/user/login";
        } else {
            if (!user.getPassword().equals(password)) {
                attributes.addFlashAttribute("error", defined.LOGIN_PASSWORD_ERROR);
                return "redirect:/user/login";
            } else {
                if (user.getStatus() != 1) {
                    attributes.addFlashAttribute("error", defined.LOGIN_USERID_DISABLED);
                    return "redirect:/user/login";
                } else {
                    ServletContext application = request.getServletContext();
                    if (application.getAttribute("online") == null) {
                        List<String> list = new ArrayList<>();
                        list.add(userid);
                        application.setAttribute("online", list);
                    } else {
                        List<String> list = (List<String>) application.getAttribute("online");
                        if (list.contains(userid)) {
                            attributes.addFlashAttribute("error", "已在线");
                            return "redirect:/user/login";
                        }
                    }
                    logService.insert(logUtil.setLog(userid, date.getTime24(), defined.LOG_TYPE_LOGIN, defined.LOG_DETAIL_USER_LOGIN, netUtil.getIpAddress(request)));
                    session.setAttribute("userid", userid);
                    session.setAttribute("login_status", true);
                    user.setLasttime(date.getTime24());
                    user.setIp(ip);
                    userService.update(user);
                    attributes.addFlashAttribute("message", defined.LOGIN_SUCCESS);
                    return "redirect:/chat";
                }
            }
        }
    }

    // 登出处理
    @RequestMapping(value = "/logout")
    public String logout(HttpSession session, RedirectAttributes attributes, WordDefined defined) {
        session.removeAttribute("userid");
        session.removeAttribute("login_status");
        attributes.addFlashAttribute("message", defined.LOGOUT_SUCCESS);
        return "redirect:/user/login";
    }

    // 注册页面显示
    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public String showRegisterPage() {
        return "register";  // 返回注册页面的视图名称
    }

    // 处理注册逻辑
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public String register(String userid, String password, String confirmPassword, HttpServletRequest request, RedirectAttributes attributes, WordDefined defined, CommonDate date) {
        // 检查用户名是否已存在
        User existingUser = userService.selectUserByUserid(userid);
        if (existingUser != null) {
            attributes.addFlashAttribute("error", "用户名已存在");
            return "redirect:/user/register";
        }

        // 检查密码是否一致
        if (!password.equals(confirmPassword)) {
            attributes.addFlashAttribute("error", "密码不一致");
            return "redirect:/user/register";
        }

        // 创建新用户对象
        User newUser = new User();
        newUser.setUserid(userid);
        newUser.setPassword(password);
        newUser.setStatus(1);  // 设置为激活状态
//        newUser.setRegtime(date.getTime24());  // 设置注册时间
        newUser.setLasttime(date.getTime24()); // 设置最后登录时间
        newUser.setIp(request.getRemoteAddr());  // 设置用户 IP

        // 保存用户信息
//        userService.addUser(newUser);

        attributes.addFlashAttribute("message", "注册成功，请登录");
        return "redirect:/user/login";
    }
}
