package com.ecommerce.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;
import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;

public class CloudinaryUtil {
    private static final String CONFIG_FILE = "cloudinary.properties";
    private static final Cloudinary CLOUDINARY;
    private static final String FOLDER;

    static {
        Properties props = new Properties();
        try (InputStream in = CloudinaryUtil.class.getClassLoader().getResourceAsStream(CONFIG_FILE)) {
            if (in == null) {
                throw new IllegalStateException("Không tìm thấy file " + CONFIG_FILE + " trong classpath.");
            }
            props.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("Không đọc được file " + CONFIG_FILE, e);
        }

        CLOUDINARY = new Cloudinary(ObjectUtils.asMap("cloud_name", props.getProperty("cloud_name"), "api_key", props.getProperty("api_key"),
                "api_secret", props.getProperty("api_secret"), "secure", true));
        FOLDER = props.getProperty("folder", "products");
    }

    private CloudinaryUtil() {}

    public static String uploadImage(Part file) {
        try (InputStream in = file.getInputStream()) {
            Map<?, ?> result = CLOUDINARY.uploader().upload(in.readAllBytes(), ObjectUtils.asMap("folder", FOLDER, "resource_type", "image"));
            return (String)result.get("secure_url");
        } catch (IOException e) {
            throw new RuntimeException("Không upload được ảnh lên Cloudinary.", e);
        }
    }
}
