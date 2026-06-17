package utils;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import java.util.Map;

public class CloudinaryConfig {
    private static Cloudinary cloudinary;

    public static Cloudinary getCloudinary() {
        if (cloudinary == null) {
            
            Map config = ObjectUtils.asMap(
                "cloud_name", "dtkasmhud",
                "api_key", "588547395879143",
                "api_secret", "GQHV1h75-nFHOqwmUJMm60Cexy4",
                "secure", true
            );
            cloudinary = new Cloudinary(config);
        }
        return cloudinary;
    }
}