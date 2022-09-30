import Foundation

struct CompletionRequest : Encodable {
    var model: String
    var prompt: String? = ""
    var max_tokens: Int = 16
    var temperature: Double = 1
    var top_p: Double = 1
}

struct CompletionResult : Decodable {
    var id: String
    var object: String
    var created: Int
    var model: String
    var choices: [CompletionChoiceResult]
    var usage: UsageResponse
}

struct CompletionChoiceResult : Decodable {
    var text: String
    var index: Int
    var logprobs: Int?
    var finish_reason: String
}
