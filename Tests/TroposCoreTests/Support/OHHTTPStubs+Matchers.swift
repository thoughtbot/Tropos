import Nimble
import OHHTTPStubs
import Quick
import ReactiveSwift

private let isAnyRequest: OHHTTPStubsTestBlock = { _ in true }

func handleUnexpectedNetworkRequests(_ metadata: ExampleMetadata) {
    stub(condition: isAnyRequest) { request in
        let callsite = metadata.example.callsite
        fail("unexpected request: \(request)", file: callsite.file, line: callsite.line)
        return OHHTTPStubsResponse(error: TestError.unexpectedRequest)
    }
}

func makeNetworkRequest<S: SignalProducerConvertible>(matching condition: StubCondition) -> Predicate<S> {
    var disposable: Disposable?
    var isMatch = false

    stub(condition: condition.condition) { _ in
        isMatch = true
        return OHHTTPStubsResponse()
    }

    var currentResult: PredicateResult {
        return PredicateResult(
            status: isMatch ? .matches : .fail,
            message: .fail("expected to fire network request matching condition '\(condition.description)'")
        )
    }

    return Predicate.define { expression in
        if disposable == nil {
            let producer = try expression.evaluate()!.producer
            disposable = ScopedDisposable(producer.start())
        }

        return currentResult
    }.requireNonNil
}
