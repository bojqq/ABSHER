# Design: TensorRT-LLM Absher Chatbot Server

## Overview

This design describes a server-based Arabic chatbot architecture using NVIDIA's TensorRT-LLM for accelerating the Allam model, served via Triton Inference Server. The system includes a vector database for RAG, content guardrails, and a REST API for the Absher iOS application.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           Absher iOS App                                     │
│                    (Swift/SwiftUI Chat Interface)                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ HTTPS/SSE
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           API Gateway (FastAPI)                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐        │
│  │ Auth        │  │ Rate        │  │ Request     │  │ SSE         │        │
│  │ Middleware  │  │ Limiter     │  │ Validator   │  │ Streaming   │        │
│  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘        │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    │               │               │
                    ▼               ▼               ▼
┌─────────────────────┐  ┌─────────────────────┐  ┌─────────────────────┐
│   Input Guardrails  │  │   RAG Pipeline      │  │   Output Guardrails │
│   (Content Filter)  │  │   (Context Retrieval)│  │   (Response Filter) │
└─────────────────────┘  └─────────────────────┘  └─────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    Vector Database (Milvus/Qdrant)                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │  Absher Service Documents │ Embeddings │ Metadata                    │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                      NVIDIA Triton Inference Server                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    TensorRT-LLM Engine                               │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                  │   │
│  │  │ Allam Model │  │ KV Cache    │  │ Batch       │                  │   │
│  │  │ (Optimized) │  │ Management  │  │ Scheduler   │                  │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘                  │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         NVIDIA GPU Server                                    │
│                    (A100/H100 with High VRAM)                               │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. API Gateway (FastAPI)

The API Gateway handles all incoming requests from the iOS app and orchestrates the inference pipeline.

```python
# api/main.py
from fastapi import FastAPI, HTTPException, Depends
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
from typing import List, Optional

app = FastAPI(title="Absher Chatbot API")

class Message(BaseModel):
    role: str  # "user" or "assistant"
    content: str

class ChatRequest(BaseModel):
    messages: List[Message]
    user_id: str
    session_id: Optional[str] = None

class ChatResponse(BaseModel):
    response: str
    session_id: str
    sources: List[str]  # RAG source references

@app.post("/v1/chat")
async def chat(request: ChatRequest, auth: str = Depends(verify_auth)):
    # 1. Input guardrails check
    # 2. RAG context retrieval
    # 3. Triton inference
    # 4. Output guardrails check
    # 5. Return streaming response
    pass

@app.post("/v1/chat/stream")
async def chat_stream(request: ChatRequest):
    return StreamingResponse(
        generate_stream(request),
        media_type="text/event-stream"
    )
```

### 2. Triton Inference Server Configuration

```
# model_repository/allam_tensorrt/config.pbtxt
name: "allam_tensorrt"
backend: "tensorrtllm"
max_batch_size: 8

input [
  {
    name: "input_ids"
    data_type: TYPE_INT32
    dims: [-1]
  },
  {
    name: "input_lengths"
    data_type: TYPE_INT32
    dims: [1]
  },
  {
    name: "request_output_len"
    data_type: TYPE_INT32
    dims: [1]
  }
]

output [
  {
    name: "output_ids"
    data_type: TYPE_INT32
    dims: [-1]
  }
]

instance_group [
  {
    count: 1
    kind: KIND_GPU
    gpus: [0]
  }
]

parameters {
  key: "gpt_model_type"
  value: { string_value: "llama" }
}

parameters {
  key: "gpt_model_path"
  value: { string_value: "/models/allam_engine" }
}
```

### 3. TensorRT-LLM Model Conversion

```python
# scripts/convert_allam.py
from tensorrt_llm import Builder
from tensorrt_llm.models import LLaMAForCausalLM
import tensorrt_llm

def convert_allam_to_tensorrt():
    """Convert Allam model to TensorRT-LLM engine"""
    
    # Load the Allam model weights
    model_dir = "/models/allam-base"
    
    # Build TensorRT engine
    builder = Builder()
    
    # Configure for optimal Arabic inference
    builder_config = builder.create_builder_config(
        precision="float16",
        max_batch_size=8,
        max_input_len=2048,
        max_output_len=512,
        max_beam_width=1
    )
    
    # Build and save engine
    engine = builder.build_engine(model, builder_config)
    engine.save("/models/allam_engine")
```

### 4. RAG Pipeline

```python
# rag/pipeline.py
from qdrant_client import QdrantClient
from sentence_transformers import SentenceTransformer

class AbsherRAG:
    def __init__(self):
        self.client = QdrantClient(host="localhost", port=6333)
        self.encoder = SentenceTransformer("sentence-transformers/paraphrase-multilingual-mpnet-base-v2")
        self.collection_name = "absher_services"
    
    def retrieve(self, query: str, top_k: int = 5) -> List[dict]:
        """Retrieve relevant Absher service documents"""
        query_vector = self.encoder.encode(query).tolist()
        
        results = self.client.search(
            collection_name=self.collection_name,
            query_vector=query_vector,
            limit=top_k
        )
        
        return [
            {
                "content": hit.payload["content"],
                "service": hit.payload["service_category"],
                "score": hit.score
            }
            for hit in results
        ]
    
    def build_context(self, query: str) -> str:
        """Build context string from retrieved documents"""
        docs = self.retrieve(query)
        context = "\n\n".join([
            f"[{doc['service']}]: {doc['content']}"
            for doc in docs
        ])
        return context
```

### 5. Guardrails System

```python
# guardrails/filters.py
from typing import Tuple
import re

class ContentGuardrails:
    def __init__(self):
        self.blocked_patterns = [
            # Patterns for inappropriate content
            r"(كلمات غير لائقة)",  # Inappropriate words
        ]
        self.allowed_topics = [
            "رخصة القيادة", "جواز السفر", "الهوية الوطنية",
            "المركبات", "التأشيرات", "المخالفات", "العنوان الوطني"
        ]
    
    def check_input(self, text: str) -> Tuple[bool, str]:
        """Check if input is appropriate"""
        for pattern in self.blocked_patterns:
            if re.search(pattern, text):
                return False, "عذراً، لا يمكنني المساعدة في هذا الطلب."
        return True, ""
    
    def check_output(self, text: str) -> Tuple[bool, str]:
        """Filter output for appropriate content"""
        # Redact any detected PII
        text = self.redact_pii(text)
        
        # Ensure response is on-topic
        if not self.is_on_topic(text):
            return False, "يمكنني مساعدتك في خدمات أبشر فقط."
        
        return True, text
    
    def redact_pii(self, text: str) -> str:
        """Redact personal information from responses"""
        # Redact Saudi ID numbers (10 digits starting with 1 or 2)
        text = re.sub(r'\b[12]\d{9}\b', '[رقم الهوية محجوب]', text)
        # Redact phone numbers
        text = re.sub(r'\b05\d{8}\b', '[رقم الجوال محجوب]', text)
        return text
    
    def is_on_topic(self, text: str) -> bool:
        """Check if response is related to Absher services"""
        # Implementation for topic detection
        return True
```

### 6. iOS API Client

```swift
// ABSHER/Services/ChatAPIService.swift
import Foundation

class ChatAPIService: ObservableObject {
    private let baseURL = "https://api.absher-chatbot.sa/v1"
    private var eventSource: URLSessionDataTask?
    
    struct ChatRequest: Codable {
        let messages: [ChatMessage]
        let userId: String
        let sessionId: String?
    }
    
    func sendMessage(
        messages: [ChatMessage],
        userId: String,
        onToken: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let request = ChatRequest(
            messages: messages,
            userId: userId,
            sessionId: nil
        )
        
        // Create SSE connection for streaming
        var urlRequest = URLRequest(url: URL(string: "\(baseURL)/chat/stream")!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        // Handle streaming response
        let session = URLSession(configuration: .default)
        eventSource = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                onError(error)
                return
            }
            
            if let data = data, let text = String(data: data, encoding: .utf8) {
                // Parse SSE events
                self.parseSSEEvents(text, onToken: onToken)
            }
            
            onComplete()
        }
        eventSource?.resume()
    }
    
    private func parseSSEEvents(_ text: String, onToken: @escaping (String) -> Void) {
        let lines = text.components(separatedBy: "\n")
        for line in lines {
            if line.hasPrefix("data: ") {
                let token = String(line.dropFirst(6))
                if token != "[DONE]" {
                    DispatchQueue.main.async {
                        onToken(token)
                    }
                }
            }
        }
    }
}
```

## Data Models

### Chat Message

```swift
// Existing ChatMessage.swift - no changes needed
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let role: MessageRole
    let content: String
    let timestamp: Date
    
    enum MessageRole: String, Codable {
        case user
        case assistant
        case system
    }
}
```

### API Response Models

```python
# api/models.py
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class ServiceDocument(BaseModel):
    id: str
    service_category: str
    title_ar: str
    title_en: str
    content_ar: str
    requirements: List[str]
    fees: Optional[str]
    duration: Optional[str]
    
class RAGResult(BaseModel):
    document: ServiceDocument
    relevance_score: float

class InferenceResult(BaseModel):
    response: str
    tokens_generated: int
    latency_ms: float
    rag_sources: List[RAGResult]
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: API Request-Response Consistency
*For any* valid chat request with a non-empty message, the API SHALL return a response containing a non-empty assistant message within the timeout period.
**Validates: Requirements 3.1, 3.3**

### Property 2: Guardrails Input Filtering
*For any* input text containing blocked patterns, the guardrails system SHALL reject the input and return a polite refusal message.
**Validates: Requirements 5.1**

### Property 3: Guardrails Output Filtering
*For any* generated response containing PII patterns (Saudi ID, phone numbers), the guardrails system SHALL redact the sensitive information before returning.
**Validates: Requirements 5.3**

### Property 4: RAG Retrieval Relevance
*For any* user query about Absher services, the RAG system SHALL return documents where at least one result has a relevance score above the threshold.
**Validates: Requirements 4.2**

### Property 5: Language Consistency
*For any* Arabic user query, the system SHALL return a response in Arabic with proper RTL formatting markers.
**Validates: Requirements 6.1, 6.4**

### Property 6: Rate Limiting Enforcement
*For any* user exceeding 60 requests per minute, the API SHALL reject subsequent requests with a 429 status code until the rate limit window resets.
**Validates: Requirements 3.5**

### Property 7: Streaming Token Delivery
*For any* streaming chat request, the SSE response SHALL deliver tokens progressively such that the client receives partial content before the full response is complete.
**Validates: Requirements 3.2, 9.2**

### Property 8: Service Category Coverage
*For any* query mentioning a supported Absher service category (driving license, passport, national ID, vehicles, visas, traffic violations), the response SHALL contain relevant procedural information for that service.
**Validates: Requirements 7.1, 7.2, 7.3, 7.4, 7.5, 7.6**

## Error Handling

| Error Type | HTTP Code | Arabic Message | Action |
|------------|-----------|----------------|--------|
| Invalid Request | 400 | طلب غير صالح | Return validation errors |
| Unauthorized | 401 | غير مصرح | Redirect to login |
| Rate Limited | 429 | تم تجاوز الحد المسموح | Wait and retry |
| Server Error | 500 | حدث خطأ، يرجى المحاولة لاحقاً | Log and alert |
| Model Timeout | 504 | انتهت مهلة الطلب | Retry with backoff |
| Guardrails Block | 403 | لا يمكن معالجة هذا الطلب | Log for audit |

## Testing Strategy

### Unit Testing
- Test guardrails pattern matching with Arabic text samples
- Test RAG retrieval with mock vector database
- Test API request validation
- Test SSE event parsing in iOS client

### Property-Based Testing
Using Hypothesis (Python) and SwiftCheck (iOS):

1. **API Response Property Tests**: Generate random valid requests and verify response structure
2. **Guardrails Property Tests**: Generate text with/without PII and verify redaction
3. **RAG Property Tests**: Generate queries and verify retrieval returns relevant results
4. **Rate Limiter Property Tests**: Generate request sequences and verify rate limiting behavior

### Integration Testing
- End-to-end flow from iOS app to Triton server
- Load testing with concurrent users
- Failover and recovery testing

### Performance Testing
- Response latency under various loads
- GPU memory usage monitoring
- Throughput measurement (tokens/second)
