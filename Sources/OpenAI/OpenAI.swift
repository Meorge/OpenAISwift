//
//  OpenAI.swift
//  
//
//  Created by Malcolm Anderson on 9/30/22.
//

import Foundation

@available(macOS 12.0, *)
public class OpenAI {
    var apiKey: String = ""
    
    init(_ apiKey: String) {
        self.apiKey = apiKey
    }
    
    func submitRequest<T: Encodable, R: Decodable>(_ requestBody: T, _ apiEndpoint: String, _ httpMethod: String, _ decodeType: R.Type) async throws -> R {
        let encodedObj = try! JSONEncoder().encode(requestBody)
        
        let url = URL(string: "https://api.openai.com/v1/\(apiEndpoint)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: encodedObj)
        
        if let responseHTTP = response as? HTTPURLResponse {
            if responseHTTP.statusCode != 200 {
                throw ResponseError.badStatusCode(code: responseHTTP.statusCode)
            }
        }
        
        let decodedResponse = try JSONDecoder().decode(decodeType, from: data)
        return decodedResponse
    }

    func submitRequest<R: Decodable>(_ apiEndpoint: String, _ httpMethod: String, _ decodeType: R.Type) async throws -> R {
        let url = URL(string: "https://api.openai.com/v1/\(apiEndpoint)")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = httpMethod
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let responseHTTP = response as? HTTPURLResponse {
            print("Response status code was \(responseHTTP.statusCode)")
            if responseHTTP.statusCode != 200 {
                throw ResponseError.badStatusCode(code: responseHTTP.statusCode)
            }
        }
        
        let decodedResponse = try JSONDecoder().decode(decodeType, from: data)
        return decodedResponse
    }
    
    public func listModels() async throws -> [ModelItem] {
        let response = try await submitRequest("models", "GET", ModelListResponse.self)
        return response.data
    }
    
    public func retrieveModel(_ name: String) async throws -> ModelItem {
        return try await submitRequest("models/\(name)", "GET", ModelItem.self)
    }
    
    func complete(
        _ prompt: String,
        withModel model: String,
        withMaxTokens maxTokens: Int = 16,
        withTemperature temperature: Double = 1.0,
        withTopP topP: Double = 1.0) async throws -> CompletionResult {
        
        let requestObject = CompletionRequest(
            model: model,
            prompt: prompt,
            max_tokens: maxTokens,
            temperature: temperature,
            top_p: topP
        )
            
        return try await submitRequest(requestObject, "completions", "POST", CompletionResult.self)
    }
    
    func edit(
        _ input: String,
        withInstruction instruction: String,
        withModel model: String,
        n: Int = 1,
        withTemperature temperature: Double = 1.0,
        withTopP topP: Double = 1.0
    ) async throws -> EditResponse {
        let request = EditRequest(
            model: model,
            input: input,
            instruction: instruction,
            n: n,
            temperature: temperature,
            top_p: topP
        )
        
        return try await submitRequest(request, "edits", "POST", EditResponse.self)
    }
}
