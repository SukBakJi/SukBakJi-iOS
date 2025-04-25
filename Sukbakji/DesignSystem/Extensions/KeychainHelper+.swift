import Security
import Foundation

class KeychainHelper {
    
    static let standard = KeychainHelper()
    
    private init() {}

    /// ✅ Keychain에 `String`을 원본 그대로 저장
    func save(_ value: String, service: String, account: String) {
        guard let data = value.data(using: .utf8) else {
            print("❌ Keychain 저장 실패 - 데이터를 UTF-8로 변환할 수 없음 (\(service))")
            return
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, // Keychain 저장 타입 (일반 비밀번호)
            kSecAttrService as String: service, // 서비스 이름 (구분자 역할)
            kSecAttrAccount as String: account, // 계정 식별자
            kSecValueData as String: data // 저장할 데이터
        ]

        SecItemDelete(query as CFDictionary) // 기존 값 삭제 후 저장 (중복 방지)
        let status = SecItemAdd(query as CFDictionary, nil)
    }

    /// ✅ Keychain에서 `String`을 원본 그대로 읽기
    func read(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true, // 데이터 반환 요청
            kSecMatchLimit as String: kSecMatchLimitOne // 하나의 데이터만 검색
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            print("❌ Keychain 읽기 실패 - \(service): \(status)")
            return nil
        }

        let stringValue = String(decoding: data, as: UTF8.self) // 🔹 Base64 변환 없이 직접 UTF-8로 변환
        return stringValue
    }

    /// ✅ Keychain에서 데이터 삭제
    func delete(service: String, account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
    }
}
