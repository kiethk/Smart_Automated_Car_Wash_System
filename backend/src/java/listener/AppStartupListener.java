package listener;

import scheduler.TierDowngradeScheduler;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppStartupListener implements ServletContextListener {

    private TierDowngradeScheduler scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[AppStartupListener] Application starting...");
        scheduler = new TierDowngradeScheduler();
        scheduler.start();
        // Lưu vào context để có thể stop khi shutdown
        sce.getServletContext().setAttribute("TIER_SCHEDULER", scheduler);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[AppStartupListener] Application shutting down...");
        if (scheduler != null) {
            scheduler.stop();
        }
    }
}
