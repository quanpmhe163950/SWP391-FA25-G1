package util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Hash password
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12)); 
        // 12 là cost factor, càng cao càng an toàn nhưng chậm hơn
    }

    // Kiểm tra password nhập vào có khớp với hash trong DB không
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
