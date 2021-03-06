<%@ page import="Service.PlanService" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="Service.IPlanService" %>
<%@ page import="Service.ITaskService" %>
<%@ page import="Service.TaskService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    private final IPlanService planService = new PlanService();
    private final ITaskService taskService = new TaskService();

    // store plan
    private boolean storePlan(String userId, HttpServletRequest request) {
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        // System.out.println(startDate + " // " + endDate);
        Map<String, String> planData = new HashMap<>();

        planData.put("userId", userId);
        planData.put("title", title);
        planData.put("content", content);
        planData.put("startDate", startDate);
        planData.put("endDate", endDate);

        return planService.storePlan(planData).contentEquals("SUCCESS");
    }

    private boolean storeTask(String userId, HttpServletRequest request) {
        String title = request.getParameter("title");
        String recordTime = request.getParameter("recordTime");
        String startTime = request.getParameter("startTime");

        Map<String, String> taskData = new HashMap<>();
        taskData.put("userId", userId);
        taskData.put("title", title);
        taskData.put("recordTime", recordTime);
        taskData.put("startTime", startTime);

        return taskService.storeTask(taskData).contentEquals("SUCCESS");
    }

    private String getMonthContent(String userId, HttpServletRequest request) {
        String currentDate = request.getParameter("currentDate");
        String monthlyPlan = planService.getMonthlyPlans(userId, currentDate);
        // diary 도 불러와야함 ㅎ
        // task 도... ㅎ

        return monthlyPlan;
    }

    private String getWeeklyContent(String userId, HttpServletRequest request) {
        String currentWeek = request.getParameter("currentWeek");
        String weeklyPlan = planService.getWeeklyPlans(userId, currentWeek);

        return weeklyPlan;
    }
%>
<%
    // current login user
    String userId = (String) session.getAttribute("userId");

    // search target
    String target = request.getParameter("target") != null ? request.getParameter("target") : "";
    String result = "";
    switch (target) {
        case "plan":
            if (storePlan(userId, request))
                result = "plan store success";
            break;
        case "task":
            if (storeTask(userId, request))
                result = "task store success";
            break;
        case "month":
            result = getMonthContent(userId, request);
            break;
        case "week":
            result = getWeeklyContent(userId, request);
            break;
        default:
            result = "Please check target";
    }
%>
<%=result%>

