"""Pydantic models for API request/response validation."""

from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, Field, field_validator


class Message(BaseModel):
    """Chat message model."""
    role: str = Field(..., description="Message role: 'user' or 'assistant'")
    content: str = Field(..., description="Message content")
    
    @field_validator("role")
    @classmethod
    def validate_role(cls, v: str) -> str:
        if v not in ("user", "assistant", "system"):
            raise ValueError("role must be 'user', 'assistant', or 'system'")
        return v
    
    @field_validator("content")
    @classmethod
    def validate_content(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("content cannot be empty")
        return v


class ChatRequest(BaseModel):
    """Chat request model."""
    messages: List[Message] = Field(..., min_length=1, description="Conversation messages")
    user_id: str = Field(..., min_length=1, description="User identifier")
    session_id: Optional[str] = Field(None, description="Session identifier")
    
    @field_validator("user_id")
    @classmethod
    def validate_user_id(cls, v: str) -> str:
        if not v or not v.strip():
            raise ValueError("user_id cannot be empty")
        return v


class RAGSource(BaseModel):
    """RAG source reference."""
    document_id: str
    service_category: str
    relevance_score: float


class ChatResponse(BaseModel):
    """Chat response model."""
    response: str = Field(..., description="Assistant response")
    session_id: str = Field(..., description="Session identifier")
    sources: List[RAGSource] = Field(default_factory=list, description="RAG source references")
    latency_ms: float = Field(..., description="Response latency in milliseconds")


class HealthResponse(BaseModel):
    """Health check response model."""
    status: str
    timestamp: datetime
    triton_ready: bool
    qdrant_ready: bool
    version: str


class ErrorResponse(BaseModel):
    """Error response model."""
    error: str
    message_ar: str
    detail: Optional[str] = None
