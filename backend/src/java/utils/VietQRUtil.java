package utils;

import config.VietQRConfig;
import java.net.URLEncoder;

public class VietQRUtil {

    public static String generateQRUrl(
            int bookingId,
            long amount) {

        try {

            String description = "AW-BK-" + bookingId;

            return "https://img.vietqr.io/image/"
                    + VietQRConfig.BANK_ID
                    + "-"
                    + VietQRConfig.ACCOUNT_NO
                    + "-compact2.png"
                    + "?amount="
                    + amount
                    + "&addInfo="
                    + URLEncoder.encode(
                            description,
                            "UTF-8")
                    + "&accountName="
                    + URLEncoder.encode(
                            VietQRConfig.ACCOUNT_NAME,
                            "UTF-8");

        } catch (Exception e) {

            e.printStackTrace();

            return "";
        }
    }
}
