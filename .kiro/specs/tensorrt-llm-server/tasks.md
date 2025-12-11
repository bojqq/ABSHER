# Implementation Plan: TensorRT-LLM Absher Chatbot Server

## Phase 1: Server Infrastructure Setup

- [x] 1. Set up project structure
  - [x] 1.1 Create server directory structure with api/, models/, rag/, guardrails/, scripts/ folders
    - Initialize Python project with pyproject.toml
    - Set up Docker configuration for containerized deployment
    - _Requirements: 1.1, 3.1_

  - [x] 1.2 Create FastAPI application skeleton
    - Implement main.py with app initialization
    - Add health check endpoint
    - Configure CORS for iOS app
    - _Requirements: 3.1, 1.3_

  - [x] 1.3 Write property test for API request validation
    - **Property 1: API Request-Response Consistency**
    - **Validates: Requirements 3.1, 3.3**

## Phase 2: TensorRT-LLM Model Setup

- [-] 2. Configure TensorRT-LLM and Triton
  - [x] 2.1 Create model conversion script
    - Write script to convert Allam model to TensorRT-LLM format
    - Configure quantization settings (FP16/INT8)
    - _Requirements: 2.1, 2.2, 2.3_

  - [x] 2.2 Create Triton model repository configuration
    - Write config.pbtxt for TensorRT-LLM backend
    - Configure batch scheduling and GPU allocation
    - _Requirements: 1.1, 2.4_

  - [x] 2.3 Create Triton client wrapper
    - Implement Python client for Triton inference
    - Add streaming support for token generation
    - _Requirements: 3.2_

  - [ ] 2.4 Write property test for streaming token delivery
    - **Property 7: Streaming Token Delivery**
    - **Validates: Requirements 3.2, 9.2**

## Phase 3: RAG Pipeline

- [ ] 3. Implement RAG system
  - [ ] 3.1 Set up vector database client
    - Configure Qdrant/Milvus connection
    - Create collection schema for Absher documents
    - _Requirements: 4.1_

  - [ ] 3.2 Create document ingestion pipeline
    - Implement embedding generation for Arabic text
    - Create batch ingestion for Absher service documents
    - _Requirements: 4.1, 4.4_

  - [ ] 3.3 Implement retrieval logic
    - Create semantic search function
    - Build context assembly from retrieved documents
    - _Requirements: 4.2, 4.3_

  - [ ] 3.4 Write property test for RAG retrieval
    - **Property 4: RAG Retrieval Relevance**
    - **Validates: Requirements 4.2**

- [ ] 4. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Phase 4: Content Guardrails

- [ ] 5. Implement guardrails system
  - [ ] 5.1 Create input content filter
    - Implement blocked pattern detection for Arabic text
    - Add inappropriate content classification
    - _Requirements: 5.1_

  - [ ] 5.2 Write property test for input guardrails
    - **Property 2: Guardrails Input Filtering**
    - **Validates: Requirements 5.1**

  - [ ] 5.3 Create output content filter
    - Implement PII detection and redaction (Saudi ID, phone numbers)
    - Add off-topic response filtering
    - _Requirements: 5.2, 5.3_

  - [ ] 5.4 Write property test for PII redaction
    - **Property 3: Guardrails Output Filtering**
    - **Validates: Requirements 5.3**

  - [ ] 5.5 Implement audit logging
    - Log all filtered content with timestamps
    - Create audit trail for compliance
    - _Requirements: 5.4_

## Phase 5: API Endpoints

- [ ] 6. Implement chat API
  - [ ] 6.1 Create chat request/response models
    - Define Pydantic models for API contracts
    - Add validation for Arabic text
    - _Requirements: 3.1_

  - [ ] 6.2 Implement synchronous chat endpoint
    - Create /v1/chat POST endpoint
    - Integrate guardrails, RAG, and Triton inference
    - _Requirements: 3.1, 3.3_

  - [ ] 6.3 Implement streaming chat endpoint
    - Create /v1/chat/stream POST endpoint with SSE
    - Implement token-by-token streaming
    - _Requirements: 3.2_

  - [ ] 6.4 Add authentication middleware
    - Implement API key or JWT validation
    - Return 401 for invalid credentials
    - _Requirements: 3.4_

  - [ ] 6.5 Add rate limiting middleware
    - Implement 60 requests/minute per user limit
    - Return 429 when limit exceeded
    - _Requirements: 3.5_

  - [ ] 6.6 Write property test for rate limiting
    - **Property 6: Rate Limiting Enforcement**
    - **Validates: Requirements 3.5**

- [ ] 7. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Phase 6: Absher Service Data

- [ ] 8. Populate Absher knowledge base
  - [ ] 8.1 Create service document templates
    - Define JSON schema for service documents
    - Include Arabic/English titles, requirements, fees, procedures
    - _Requirements: 7.1-7.6_

  - [ ] 8.2 Create driving license service documents
    - Add renewal, issuance, replacement procedures
    - Include fees and requirements
    - _Requirements: 7.1_

  - [ ] 8.3 Create passport service documents
    - Add application, renewal, child passport procedures
    - Include fees and requirements
    - _Requirements: 7.2_

  - [ ] 8.4 Create national ID service documents
    - Add renewal, replacement, update procedures
    - Include fees and requirements
    - _Requirements: 7.3_

  - [ ] 8.5 Create vehicle service documents
    - Add registration, transfer, plate procedures
    - Include fees and requirements
    - _Requirements: 7.4_

  - [ ] 8.6 Create visa service documents
    - Add visit, exit/re-entry, final exit procedures
    - Include fees and requirements
    - _Requirements: 7.5_

  - [ ] 8.7 Create traffic violation service documents
    - Add inquiry, payment, objection procedures
    - Include fees and requirements
    - _Requirements: 7.6_

  - [ ] 8.8 Write property test for service coverage
    - **Property 8: Service Category Coverage**
    - **Validates: Requirements 7.1-7.6**

## Phase 7: Language Handling

- [ ] 9. Implement Arabic language support
  - [ ] 9.1 Create language detection utility
    - Detect Arabic vs English input
    - Handle mixed language queries
    - _Requirements: 6.3_

  - [ ] 9.2 Implement RTL formatting
    - Add RTL markers to Arabic responses
    - Ensure proper text direction in JSON responses
    - _Requirements: 6.4_

  - [ ] 9.3 Write property test for language consistency
    - **Property 5: Language Consistency**
    - **Validates: Requirements 6.1, 6.4**

## Phase 8: iOS Integration

- [ ] 10. Update iOS app for server API
  - [ ] 10.1 Create ChatAPIService
    - Implement API client with URLSession
    - Add SSE parsing for streaming responses
    - _Requirements: 9.1, 9.2_

  - [ ] 10.2 Update ChatViewModel for API integration
    - Replace MLXService with ChatAPIService
    - Handle streaming token updates
    - _Requirements: 9.2_

  - [ ] 10.3 Implement error handling
    - Display Arabic error messages
    - Handle network connectivity issues
    - _Requirements: 9.3, 9.4_

  - [ ] 10.4 Write property test for error message display
    - **Property: Error messages are displayed in Arabic**
    - **Validates: Requirements 9.4**

- [ ] 11. Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.

## Phase 9: Docker and Deployment

- [ ] 12. Create deployment configuration
  - [ ] 12.1 Create Dockerfile for API server
    - Multi-stage build for Python FastAPI app
    - Include all dependencies
    - _Requirements: 1.1_

  - [ ] 12.2 Create docker-compose.yml
    - Configure Triton server container
    - Configure API server container
    - Configure vector database container
    - _Requirements: 1.1, 4.1_

  - [ ] 12.3 Create deployment documentation
    - Document environment variables
    - Document GPU requirements
    - Document scaling configuration
    - _Requirements: 8.1-8.4_

- [ ] 13. Final Checkpoint - Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
