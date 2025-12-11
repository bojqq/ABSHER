# Absher Chatbot Server

TensorRT-LLM powered Arabic chatbot server for Absher government services.

## Architecture

- **FastAPI**: REST API gateway with SSE streaming support
- **Triton Inference Server**: TensorRT-LLM model serving
- **Qdrant**: Vector database for RAG
- **Redis**: Rate limiting and caching

## Project Structure

```
server/
├── api/           # FastAPI application and endpoints
├── models/        # TensorRT-LLM and Triton configurations
├── rag/           # RAG pipeline and vector database
├── guardrails/    # Content filtering and safety
├── scripts/       # Model conversion and utilities
├── tests/         # Property-based and unit tests
└── docker-compose.yml
```

## Quick Start

### Development

```bash
# Install dependencies
pip install -e ".[dev]"

# Run the server
uvicorn api.main:app --reload --port 8000
```

### Docker Deployment

```bash
# Build and run all services
docker-compose up -d

# Check health
curl http://localhost:8000/health
```

## API Endpoints

- `POST /v1/chat` - Synchronous chat
- `POST /v1/chat/stream` - Streaming chat (SSE)
- `GET /health` - Health check

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TRITON_URL` | Triton server URL | `localhost:8001` |
| `QDRANT_URL` | Qdrant server URL | `localhost:6333` |
| `REDIS_URL` | Redis URL for rate limiting | `redis://localhost:6379` |
| `LOG_LEVEL` | Logging level | `INFO` |

## Testing

```bash
# Run all tests
pytest

# Run property-based tests
pytest tests/test_properties.py -v
```
