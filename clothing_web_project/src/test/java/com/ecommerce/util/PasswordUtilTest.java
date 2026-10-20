package com.ecommerce.util;

import org.junit.Test;
import static org.junit.Assert.*;

public class PasswordUtilTest {

    @Test
    public void testHashAndCheckPasswordSuccess() {
        String rawPassword = "SecurePassword123@";
        String hashed = PasswordUtil.hashPassword(rawPassword);

        assertNotNull(hashed);
        assertNotEquals(rawPassword, hashed);
        assertTrue(PasswordUtil.checkPassword(rawPassword, hashed));
    }

    @Test
    public void testCheckPasswordWrong() {
        String rawPassword = "Password123";
        String wrongPassword = "WrongPassword";
        String hashed = PasswordUtil.hashPassword(rawPassword);

        assertFalse(PasswordUtil.checkPassword(wrongPassword, hashed));
    }

    @Test(expected = IllegalArgumentException.class)
    public void testHashEmptyPasswordThrowsException() {
        PasswordUtil.hashPassword("");
    }

    @Test
    public void testCheckInvalidHashReturnsFalse() {
        assertFalse(PasswordUtil.checkPassword("raw", "invalid_hash_string"));
        assertFalse(PasswordUtil.checkPassword(null, "some_hash"));
        assertFalse(PasswordUtil.checkPassword("raw", null));
    }
}
