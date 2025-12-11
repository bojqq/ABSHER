"""
Triton Inference Server client wrapper for Allam model.

This module provides a Python client for communicating with Triton Inference Server
running the TensorRT-LLM optimized Allam model, with support for streaming responses.

Requirements: 3.2
"""

import logging
from dataclasses import dataclass
from typing import AsyncIterator, Optional
import asyncio
import queue
import threading

logger = logging.getLogger(__name__)


@dataclass
class InferenceConfig:
    """Configuration for inference requests."""
    max_tokens: int = 512
    temperature: float = 0.7
    top_p: float = 0.9
    top_k: int = 50
    repetition_penalty: float = 1.1
    stream: bool = True


@dataclass
class InferenceResult:
    """Result from inference request."""
    text: str
    tokens_generated: int
    latency_ms: float
    finish_reason: str  # "stop", "length", "error"


class TritonClientError(Exception):
    """Exception raised for Triton client errors."""
    pass



class TritonClient:
    """
    Client for Triton Inference Server with TensorRT-LLM backend.
    
    Supports both synchronous and streaming inference for the Allam model.
    """
    
    def __init__(
        self,
        url: str = "localhost:8001",
        model_name: str = "ensemble",
        verbose: bool = False,
    ):
        """
        Initialize Triton client.
        
        Args:
            url: Triton server gRPC URL (host:port)
            model_name: Name of the model to use
            verbose: Enable verbose logging
        """
        self.url = url
        self.model_name = model_name
        self.verbose = verbose
        self._client = None
        self._connected = False
    
    def _ensure_client(self) -> None:
        """Ensure Triton client is initialized."""
        if self._client is None:
            try:
                import tritonclient.grpc.aio as grpcclient
                self._client = grpcclient.InferenceServerClient(
                    url=self.url,
                    verbose=self.verbose,
                )
                self._connected = True
            except ImportError:
                logger.warning(
                    "tritonclient not installed. Install with: pip install tritonclient[all]"
                )
                raise TritonClientError("tritonclient not available")
            except Exception as e:
                raise TritonClientError(f"Failed to connect to Triton: {e}")
    
    async def is_server_ready(self) -> bool:
        """Check if Triton server is ready."""
        try:
            self._ensure_client()
            return await self._client.is_server_ready()
        except Exception as e:
            logger.error(f"Server ready check failed: {e}")
            return False
    
    async def is_model_ready(self) -> bool:
        """Check if the model is loaded and ready."""
        try:
            self._ensure_client()
            return await self._client.is_model_ready(self.model_name)
        except Exception as e:
            logger.error(f"Model ready check failed: {e}")
            return False
    
    async def infer(
        self,
        prompt: str,
        config: Optional[InferenceConfig] = None,
    ) -> InferenceResult:
        """
        Run synchronous inference.
        
        Args:
            prompt: Input text prompt
            config: Inference configuration
            
        Returns:
            InferenceResult with generated text
        """
        import time
        import numpy as np
        
        if config is None:
            config = InferenceConfig(stream=False)
        
        self._ensure_client()
        
        try:
            import tritonclient.grpc.aio as grpcclient
            
            start_time = time.perf_counter()
            
            # Prepare inputs
            inputs = self._prepare_inputs(prompt, config, grpcclient)
            
            # Run inference
            result = await self._client.infer(
                model_name=self.model_name,
                inputs=inputs,
            )
            
            # Extract output
            output = result.as_numpy("text_output")
            generated_text = output[0].decode("utf-8") if output is not None else ""
            
            latency_ms = (time.perf_counter() - start_time) * 1000
            
            return InferenceResult(
                text=generated_text,
                tokens_generated=len(generated_text.split()),  # Approximate
                latency_ms=latency_ms,
                finish_reason="stop",
            )
            
        except Exception as e:
            logger.error(f"Inference failed: {e}")
            raise TritonClientError(f"Inference failed: {e}")
    
    async def infer_stream(
        self,
        prompt: str,
        config: Optional[InferenceConfig] = None,
    ) -> AsyncIterator[str]:
        """
        Run streaming inference, yielding tokens as they are generated.
        
        Args:
            prompt: Input text prompt
            config: Inference configuration
            
        Yields:
            Generated tokens as strings
        """
        import numpy as np
        
        if config is None:
            config = InferenceConfig(stream=True)
        else:
            config.stream = True
        
        self._ensure_client()
        
        try:
            import tritonclient.grpc.aio as grpcclient
            
            # Prepare inputs
            inputs = self._prepare_inputs(prompt, config, grpcclient)
            
            # Create streaming request
            response_iterator = self._client.stream_infer(
                model_name=self.model_name,
                inputs=inputs,
            )
            
            async for response in response_iterator:
                result, error = response
                
                if error:
                    logger.error(f"Streaming error: {error}")
                    raise TritonClientError(f"Streaming error: {error}")
                
                if result:
                    output = result.as_numpy("text_output")
                    if output is not None:
                        token = output[0].decode("utf-8")
                        yield token
                        
        except Exception as e:
            logger.error(f"Streaming inference failed: {e}")
            raise TritonClientError(f"Streaming inference failed: {e}")
    
    def _prepare_inputs(self, prompt: str, config: InferenceConfig, grpcclient) -> list:
        """Prepare input tensors for inference."""
        import numpy as np
        
        inputs = []
        
        # Text input
        text_input = grpcclient.InferInput("text_input", [1, 1], "BYTES")
        text_input.set_data_from_numpy(
            np.array([[prompt.encode("utf-8")]], dtype=object)
        )
        inputs.append(text_input)
        
        # Max tokens
        max_tokens = grpcclient.InferInput("max_tokens", [1, 1], "INT32")
        max_tokens.set_data_from_numpy(
            np.array([[config.max_tokens]], dtype=np.int32)
        )
        inputs.append(max_tokens)
        
        # Temperature
        temperature = grpcclient.InferInput("temperature", [1, 1], "FP32")
        temperature.set_data_from_numpy(
            np.array([[config.temperature]], dtype=np.float32)
        )
        inputs.append(temperature)
        
        # Top P
        top_p = grpcclient.InferInput("top_p", [1, 1], "FP32")
        top_p.set_data_from_numpy(
            np.array([[config.top_p]], dtype=np.float32)
        )
        inputs.append(top_p)
        
        # Top K
        top_k = grpcclient.InferInput("top_k", [1, 1], "INT32")
        top_k.set_data_from_numpy(
            np.array([[config.top_k]], dtype=np.int32)
        )
        inputs.append(top_k)
        
        # Stream flag
        stream = grpcclient.InferInput("stream", [1, 1], "BOOL")
        stream.set_data_from_numpy(
            np.array([[config.stream]], dtype=bool)
        )
        inputs.append(stream)
        
        return inputs
    
    async def close(self) -> None:
        """Close the client connection."""
        if self._client is not None:
            await self._client.close()
            self._client = None
            self._connected = False


class MockTritonClient:
    """
    Mock Triton client for testing without a running server.
    
    Simulates streaming token generation for development and testing.
    """
    
    def __init__(
        self,
        url: str = "localhost:8001",
        model_name: str = "ensemble",
        verbose: bool = False,
    ):
        self.url = url
        self.model_name = model_name
        self.verbose = verbose
    
    async def is_server_ready(self) -> bool:
        """Always returns True for mock."""
        return True
    
    async def is_model_ready(self) -> bool:
        """Always returns True for mock."""
        return True
    
    async def infer(
        self,
        prompt: str,
        config: Optional[InferenceConfig] = None,
    ) -> InferenceResult:
        """Return mock inference result."""
        mock_response = self._generate_mock_response(prompt)
        return InferenceResult(
            text=mock_response,
            tokens_generated=len(mock_response.split()),
            latency_ms=150.0,
            finish_reason="stop",
        )
    
    async def infer_stream(
        self,
        prompt: str,
        config: Optional[InferenceConfig] = None,
    ) -> AsyncIterator[str]:
        """Yield mock tokens with simulated delay."""
        mock_response = self._generate_mock_response(prompt)
        tokens = mock_response.split()
        
        for token in tokens:
            await asyncio.sleep(0.05)  # Simulate token generation delay
            yield token + " "
    
    def _generate_mock_response(self, prompt: str) -> str:
        """Generate a mock Arabic response."""
        # Simple mock responses for testing
        if "رخصة" in prompt or "license" in prompt.lower():
            return "لتجديد رخصة القيادة، يرجى زيارة أقرب مركز مرور أو استخدام تطبيق أبشر."
        elif "جواز" in prompt or "passport" in prompt.lower():
            return "يمكنك تجديد جواز السفر من خلال منصة أبشر الإلكترونية."
        else:
            return "مرحباً بك في خدمة أبشر. كيف يمكنني مساعدتك اليوم؟"
    
    async def close(self) -> None:
        """No-op for mock client."""
        pass


def create_triton_client(
    url: str = "localhost:8001",
    model_name: str = "ensemble",
    use_mock: bool = False,
    verbose: bool = False,
) -> TritonClient | MockTritonClient:
    """
    Factory function to create appropriate Triton client.
    
    Args:
        url: Triton server URL
        model_name: Model name to use
        use_mock: If True, return mock client for testing
        verbose: Enable verbose logging
        
    Returns:
        TritonClient or MockTritonClient instance
    """
    if use_mock:
        return MockTritonClient(url=url, model_name=model_name, verbose=verbose)
    return TritonClient(url=url, model_name=model_name, verbose=verbose)
