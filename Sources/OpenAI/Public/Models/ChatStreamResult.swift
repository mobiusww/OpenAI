//
//  ChatStreamResult.swift
//  
//
//  Created by Sergii Kryvoblotskyi on 15/05/2023.
//

import Foundation

public struct ChatStreamResult: Codable, Equatable {
    
    public struct Choice: Codable, Equatable {
        public typealias FinishReason = ChatResult.Choice.FinishReason

        public struct ChoiceDelta: Codable, Equatable {
            public typealias Role = ChatQuery.ChatCompletionMessageParam.Role

            /// The contents of the chunk message.
            public let content: String?
            /// The role of the author of this message.
            public let role: Self.Role?
            public let toolCalls: [Self.ChoiceDeltaToolCall]?

            public struct ChoiceDeltaToolCall: Codable, Equatable {

                public let index: Int
                /// The ID of the tool call.
                public let id: String?
                /// The function that the model called.
                public let function: Self.ChoiceDeltaToolCallFunction?
                /// The type of the tool. Currently, only function is supported.
                public let type: String?

                public init(
                    index: Int,
                    id: String? = nil,
                    function: Self.ChoiceDeltaToolCallFunction? = nil
                ) {
                    self.index = index
                    self.id = id
                    self.function = function
                    self.type = "function"
                }

                public struct ChoiceDeltaToolCallFunction: Codable, Equatable {

                    /// The arguments to call the function with, as generated by the model in JSON format. Note that the model does not always generate valid JSON, and may hallucinate parameters not defined by your function schema. Validate the arguments in your code before calling your function.
                    public let arguments: String?
                    /// The name of the function to call.
                    public let name: String?

                    public init(
                        arguments: String? = nil,
                        name: String? = nil
                    ) {
                        self.arguments = arguments
                        self.name = name
                    }
                }
            }

            public enum CodingKeys: String, CodingKey {
                case content
                case role
                case toolCalls = "tool_calls"
            }
        }

        /// The index of the choice in the list of choices.
        public let index: Int
        /// A chat completion delta generated by streamed model responses.
        public let delta: Self.ChoiceDelta
        /// The reason the model stopped generating tokens.
        /// This will be `stop` if the model hit a natural stop point or a provided stop sequence, `length` if the maximum number of tokens specified in the request was reached, `content_filter` if content was omitted due to a flag from our content filters, `tool_calls` if the model called a tool, or `function_call` (deprecated) if the model called a function.
        public let finishReason: FinishReason?
        /// Log probability information for the choice.
        public let logprobs: Self.ChoiceLogprobs?

        public struct ChoiceLogprobs: Codable, Equatable {
            /// A list of message content tokens with log probability information.
            public let content: [Self.ChatCompletionTokenLogprob]?

            public struct ChatCompletionTokenLogprob: Codable, Equatable {
                /// The token.
                public let token: String
                /// A list of integers representing the UTF-8 bytes representation of the token. Useful in instances where characters are represented by multiple tokens and their byte representations must be combined to generate the correct text representation. Can be null if there is no bytes representation for the token.
                public let bytes: [Int]?
                /// The log probability of this token.
                public let logprob: Double
                /// List of the most likely tokens and their log probability, at this token position. In rare cases, there may be fewer than the number of requested top_logprobs returned.
                public let topLogprobs: [Self.TopLogprob]?

                public struct TopLogprob: Codable, Equatable {
                    /// The token.
                    public let token: String
                    /// A list of integers representing the UTF-8 bytes representation of the token. Useful in instances where characters are represented by multiple tokens and their byte representations must be combined to generate the correct text representation. Can be null if there is no bytes representation for the token.
                    public let bytes: [Int]?
                    /// The log probability of this token.
                    public let logprob: Double
                }

                public enum CodingKeys: String, CodingKey {
                    case token
                    case bytes
                    case logprob
                    case topLogprobs = "top_logprobs"
                }
            }
        }

        public enum CodingKeys: String, CodingKey {
            case index
            case delta
            case finishReason = "finish_reason"
            case logprobs
        }
    }

    /// A unique identifier for the chat completion. Each chunk has the same ID.
    public let id: String
    /// The object type, which is always `chat.completion.chunk`.
    public let object: String
    /// The Unix timestamp (in seconds) of when the chat completion was created.
    /// Each chunk has the same timestamp.
    public let created: TimeInterval
    /// The model to generate the completion.
    public let model: String
    /// A list of chat completion choices.
    /// Can be more than one if `n` is greater than 1.
    public let choices: [Choice]
    /// This fingerprint represents the backend configuration that the model runs with. Can be used in conjunction with the `seed` request parameter to understand when backend changes have been made that might impact determinism.
    public let systemFingerprint: String?
    // Add the CompletionUsage property
    public let usage: ChatResult.CompletionUsage?
    
    public enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case choices
        case systemFingerprint = "system_fingerprint"
        case usage // Include usage in the coding keys
    }
}
