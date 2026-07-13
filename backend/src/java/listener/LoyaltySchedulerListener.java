package listener;

import config.LoyaltyConfig;
import dao.LoyaltyReviewDAO;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class LoyaltySchedulerListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduleNextMonthlyReview();
        sce.getServletContext().log("Loyalty monthly tier review scheduler started.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
        sce.getServletContext().log("Loyalty monthly tier review scheduler stopped.");
    }

    private void scheduleNextMonthlyReview() {
        if (scheduler == null || scheduler.isShutdown()) {
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        LocalDateTime nextRun = now
                .withDayOfMonth(LoyaltyConfig.MONTHLY_REVIEW_DAY_OF_MONTH)
                .withHour(LoyaltyConfig.MONTHLY_REVIEW_HOUR)
                .withMinute(LoyaltyConfig.MONTHLY_REVIEW_MINUTE)
                .withSecond(0)
                .withNano(0);

        if (!nextRun.isAfter(now)) {
            nextRun = nextRun.plusMonths(1);
        }

        long delayMillis = Duration.between(now, nextRun).toMillis();

        scheduler.schedule(new Runnable() {
            @Override
            public void run() {
                try {
                    new LoyaltyReviewDAO().runMonthlyTierDowngrade();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    scheduleNextMonthlyReview();
                }
            }
        }, delayMillis, TimeUnit.MILLISECONDS);
    }
}
