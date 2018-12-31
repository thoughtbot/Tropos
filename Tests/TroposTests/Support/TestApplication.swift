final class TestApplication: NSObject, TRApplication {
    var didSetMinimumBackgroundFetchInterval: ((TimeInterval) -> Void)?

    func setMinimumBackgroundFetchInterval(_ minimumBackgroundFetchInterval: TimeInterval) {
        didSetMinimumBackgroundFetchInterval?(minimumBackgroundFetchInterval)
    }
}
