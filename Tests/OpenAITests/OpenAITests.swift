import XCTest
@testable import OpenAI

@available(macOS 12.0, *)
final class OpenAITests: XCTestCase {
    let key = "KEY"
    
    func testBadKey() async throws {
        XCTAssertThrowsError(OpenAI("bad key").listModels)
    }
    
    func testListModels() async throws {
        let models = try await OpenAI(key).listModels()
        print(models)
    }
    
    func testGetModel() async throws {
        let singleModel = try await OpenAI(key).retrieveModel("text-ada-001")
        print(singleModel)
    }
    
    func testCompletion() async throws {
        let prompt = "Tell me a story about a Golden Retriever going for a hike.\nOnce upon a time,"
        let completion = try await OpenAI(key).complete(
            prompt,
            withModel: "text-davinci-002",
            withMaxTokens: 256,
            withTemperature: 0.75
        )
        print(prompt + completion.choices[0].text)
    }
    
    func testEdit() async throws {
        let edit = try await OpenAI(key).edit(
            "Helo my naem iz Bob adn I liek to eate chezzburgar.",
            withInstruction: "Fix all the spelling mistakes.",
            withModel: "text-davinci-edit-001"
        )
        print(edit.choices[0].text)
    }
}
