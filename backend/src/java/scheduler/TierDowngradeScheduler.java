package scheduler;

import dao.TierDowngradeDAO;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class TierDowngradeScheduler {

    private ScheduledExecutorService scheduler;

    public void start() {
        scheduler = Executors.newSingleThreadScheduledExecutor();

        long initialDelay = computeInitialDelaySeconds();
        long periodSeconds = TimeUnit.DAYS.toSeconds(1); // check mỗi ngày

        scheduler.scheduleAtFixedRate(() -> {
            try {
                LocalDate today = LocalDate.now();

                // Chỉ chạy vào ngày 1 đầu tháng
                if (today.getDayOfMonth() == 17) {
                    System.out.println("[TierDowngradeScheduler] Running monthly tier downgrade at " + LocalDateTime.now());
                    TierDowngradeDAO dao = new TierDowngradeDAO();
                    boolean success = dao.runMonthlyDowngradeAuto();
                    System.out.println("[TierDowngradeScheduler] Result: " + (success ? "SUCCESS" : "FAILED"));
                }
            } catch (Exception e) {
                System.out.println("[TierDowngradeScheduler] Error: " + e.getMessage());
                e.printStackTrace();
            }
        }, initialDelay, periodSeconds, TimeUnit.SECONDS);

        System.out.println("[TierDowngradeScheduler] Started. Next check in " + initialDelay + "s.");
    }

    public void stop() {
        if (scheduler != null && !scheduler.isShutdown()) {
            scheduler.shutdownNow();
            System.out.println("[TierDowngradeScheduler] Stopped.");
        }
    }

    // Tính số giây delay đến 00:05 sáng hôm nay hoặc ngày mai
    private long computeInitialDelaySeconds() {
//        LocalDateTime now = LocalDateTime.now();
//        // Chạy lúc 00:05 sáng mỗi ngày
//        LocalDateTime nextRun = now.toLocalDate().atTime(LocalTime.of(0, 5));
//
//        if (now.isAfter(nextRun)) {
//            nextRun = nextRun.plusDays(1);
//        }
//
//        return ChronoUnit.SECONDS.between(now, nextRun);

        return 3;
    }
}
