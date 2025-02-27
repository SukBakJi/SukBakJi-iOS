//
//  AuthInterceptor.swift
//  Sukbakji
//
//  Created by 오현민 on 8/19/24.
//

import Alamofire

class AuthInterceptor: RequestInterceptor {

    // 토큰 저장 및 갱신 관련 프로퍼티
    private let lock = NSLock()
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []

    // 요청에 액세스 토큰 추가
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        if let accessToken = KeychainHelper.standard.read(service: "access-token", account: "user", type: String.self) {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            //request.setValue("Bearer ssdfsds", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    // 401 에러 발생 시 처리
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)

            if !isRefreshing {
                isRefreshing = true

                refreshToken { [weak self] success in
                    guard let self = self else { return }
                    
                    self.lock.lock()
                    defer { self.lock.unlock() }

                    self.isRefreshing = false

                    let retryResults: RetryResult = success ? .retry : .doNotRetryWithError(error)
                    self.requestsToRetry.forEach { $0(retryResults) }
                    self.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }

    // 리프레시 토큰을 사용하여 액세스 토큰 갱신
    private func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = KeychainHelper.standard.read(service: "refresh-token", account: "user", type: String.self) else {
            completion(false)
            return
        }
        
        let url = APIConstants.authRefreshToken.path
        let headers: HTTPHeaders = [
            "Accept": "*/*",
            "Content-Type": "application/json"
        ]
        let parameters: [String: String] = [
            "refresh_token": refreshToken
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: LoginResponseDTO.self) { response in
            switch response.result {
            case .success(let data):
                if let newAccessToken = data.result?.accessToken,
                   let newRefreshToken = data.result?.refreshToken { // 리프레시 토큰도 모델에서 가져오기
                    // 새로운 액세스 토큰을 Keychain에 저장
                    if let accessTokenData = newAccessToken.data(using: .utf8) {
                        KeychainHelper.standard.save(accessTokenData, service: "access-token", account: "user")
                    }
                    // 새로운 리프레시 토큰을 Keychain에 저장
                    if let refreshTokenData = newRefreshToken.data(using: .utf8) {
                        KeychainHelper.standard.save(refreshTokenData, service: "refresh-token", account: "user")
                    }
                    print("리프레시 토큰 갱신 완료")
                    print("리프레시토큰: \(data)")
                    completion(true)
                } else {
                    print("토큰 갱신 실패, 로그아웃 진행하겠습니다.")
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
}

