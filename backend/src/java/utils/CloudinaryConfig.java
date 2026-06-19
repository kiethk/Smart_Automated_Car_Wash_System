package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.io.File;
import java.util.Map;

public class CloudinaryConfig {

    private static Cloudinary cloudinary;

    private static final String CLOUD_NAME = "dtkasmhud";
    private static final String API_KEY = "588547395879143";
    private static final String API_SECRET = "GQHV1h75-nFHOqwmUJMm60Cexy4";

    public static Cloudinary getCloudinary() {
        if (cloudinary == null) {
            Map config = ObjectUtils.asMap(
                    "cloud_name", CLOUD_NAME,
                    "api_key", API_KEY,
                    "api_secret", API_SECRET,
                    "secure", true
            );

            cloudinary = new Cloudinary(config);
        }

        return cloudinary;
    }

    public static String uploadImage(File file) throws Exception {
        Cloudinary cloudinaryClient = getCloudinary();

        Map uploadResult = cloudinaryClient.uploader().upload(file, ObjectUtils.asMap(
                "folder", "autowash/promotions",
                "resource_type", "image"
        ));

        Object secureUrl = uploadResult.get("secure_url");

        if (secureUrl == null) {
            throw new RuntimeException("Cloudinary upload failed: secure_url is null");
        }

        return secureUrl.toString();
    }
}
