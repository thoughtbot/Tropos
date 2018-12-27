import OHHTTPStubs

struct StubCondition {
    let condition: OHHTTPStubsTestBlock
    let description: String

    static func && (lhs: StubCondition, rhs: StubCondition) -> StubCondition {
        return StubCondition(
            condition: lhs.condition && rhs.condition,
            description: "\(lhs.description), \(rhs.description)"
        )
    }
}

extension StubCondition {
    static func host(_ host: String) -> StubCondition {
        return StubCondition(condition: isHost(host), description: "host=\(host)")
    }

    static func path(_ path: String) -> StubCondition {
        return StubCondition(condition: isPath(path), description: "path=\(path)")
    }

    static func path(regex pattern: String) -> StubCondition {
        return StubCondition(condition: pathMatches(pattern), description: "path~=\(pattern)")
    }

    static func scheme(_ scheme: String) -> StubCondition {
        return StubCondition(condition: isScheme(scheme), description: "scheme=\(scheme)")
    }
}
