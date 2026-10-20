package com.ecommerce.util;

import java.text.Normalizer;
import java.util.regex.Pattern;

public class SlugUtil {
    private static final Pattern DIACRITICALS = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    private static final Pattern NON_ALPHANUMERIC = Pattern.compile("[^a-z0-9]+");
    private static final Pattern EDGE_HYPHENS = Pattern.compile("^-+|-+$");

    public static String toSlug(String input) {
        if (input == null || input.isEmpty()) {
            return "";
        }

        String result = input.trim().toLowerCase();
        result = result.replace('đ', 'd');
        result = Normalizer.normalize(result, Normalizer.Form.NFD);
        result = DIACRITICALS.matcher(result).replaceAll("");
        result = NON_ALPHANUMERIC.matcher(result).replaceAll("-");
        result = EDGE_HYPHENS.matcher(result).replaceAll("");

        return result;
    }
}
