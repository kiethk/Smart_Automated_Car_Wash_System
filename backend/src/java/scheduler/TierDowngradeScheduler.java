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
        long periodSeconds = TimeUnit.DAYS.toSeconds(1); // check má»—i ngÃ y

        scheduler.scheduleAtFixedRate(() -> {
            try {
                LocalDate today = LocalDate.now();

                // Chá»‰ cháº¡y vÃ o ngÃ y 1 Ä‘áº§u thÃ¡ng
                if (today.getDayOfMonth() == 1) {
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

    // TÃ­nh sá»‘ giÃ¢y delay Ä‘áº¿n 00:05 sÃ¡ng hÃ´m nay hoáº·c ngÃ y mai
    private long computeInitialDelaySeconds() {
        LocalDateTime now = LocalDateTime.now();
        // Cháº¡y lÃºc 00:05 sÃ¡ng má»—i ngÃ y
        LocalDateTime nextRun = now.toLocalDate().atTime(LocalTime.of(0, 5));

        if (now.isAfter(nextRun)) {
            nextRun = nextRun.plusDays(1);
        }

        return ChronoUnit.SECONDS.between(now, nextRun);

//        return 3;
    }
}
