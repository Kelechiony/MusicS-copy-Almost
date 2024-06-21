import StoreKit

struct MusicAuthorization {

    static func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SKCloudServiceController.requestAuthorization { status in
            switch status {
            case .authorized:
                completion(true)
            case .denied, .restricted, .notDetermined:
                completion(false)
            @unknown default:
                completion(false)
            }
        }
    }
}

