"""FastAPI application for Absher Chatbot Server."""

import os
from datetime import datetime
from contextlib import asynccontextmanager
from typing import AsyncGenerator

from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from api.models import HealthResponse, ErrorResponse

# Application version
VERSION = "0.1.0"


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Application lifespan handler for startup/shutdown."""
    # Startup
    print("Starting Absher Chatbot Server...")
    yield
    # Shutdown
    print("Shutting down Absher Chatbot Server...")


app = FastAPI(
    title="Absher Chatbot API",
    description="TensorRT-LLM powered Arabic chatbot for Absher government services",
    version=VERSION,
    lifespan=lifespan,
)

# Configure CORS for iOS app
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://absher.sa",
        "https://*.absher.sa",
        "http://localhost:*",
        "*",  # Allow all origins for development
    ],
    allow_credentials=True,
    allow_methods=["GET", "POST", "OPTIONS"],
    allow_headers=["*"],
    expose_headers=["X-Request-ID"],
)


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
    """Global exception handler returning Arabic error messages."""
    return JSONResponse(
        status_code=500,
        content=ErrorResponse(
            error="internal_server_error",
            message_ar="حدث خطأ، يرجى المحاولة لاحقاً",
            detail=str(exc) if os.getenv("DEBUG") else None,
        ).model_dump(),
    )


@app.get("/health", response_model=HealthResponse, tags=["Health"])
async def health_check() -> HealthResponse:
    """
    Health check endpoint.
    
    Returns the server status and readiness of dependent services.
    Responds within 100ms as per Requirements 1.3.
    """
    return HealthResponse(
        status="healthy",
        timestamp=datetime.utcnow(),
        triton_ready=True,  # Will be updated with actual check
        qdrant_ready=True,  # Will be updated with actual check
        version=VERSION,
    )


@app.get("/", tags=["Root"])
async def root() -> dict:
    """Root endpoint with API information."""
    return {
        "name": "Absher Chatbot API",
        "version": VERSION,
        "docs": "/docs",
        "health": "/health",
    }
