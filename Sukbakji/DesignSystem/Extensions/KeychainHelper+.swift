import Security
import Foundation

class KeychainHelper {
    
    static let standard = KeychainHelper()
    
    private init() {}
    
    func save<T: Codable>(_ value: T, service: String, account: String) {
        let data = try? JSONEncoder().encode(value) // 🔹 데이터를 JSON 형식으로 변환
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // 🔹 Keychain 저장 타입 (일반 비밀번호)
            kSecAttrService as String: service, // 🔹 서비스 이름 (구분자 역할)
            kSecAttrAccount as String: account, // 🔹 계정 식별자
            kSecValueData as String: data ?? Data() // 🔹 저장할 데이터
        ]
        
        // 🔹 기존에 데이터가 존재하면 업데이트, 없으면 추가
        SecItemDelete(query as CFDictionary) // 기존 값 삭제 후 저장 (중복 방지)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    /// ✅ Keychain에서 데이터 읽기
    func read<T: Codable>(service: String, account: String, type: T.Type) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true, // 🔹 데이터 반환 요청
            kSecMatchLimit as String: kSecMatchLimitOne // 🔹 하나의 데이터만 검색
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data) // 🔹 JSON 디코딩하여 반환
    }
    
    /// ✅ Keychain에서 데이터 삭제
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary) // 🔹 Keychain 데이터 삭제
    }
}
