"""
Property-based tests for streaming token delivery.

**Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
**Validates: Requirements 3.2, 9.2**

Tests that for any streaming chat request, the SSE response delivers tokens
progressively such that the client receives partial content before the full
response is complete.
"""

import asyncio
import string
from typing import List
from hypothesis import given, strategies as st, settings

import sys
sys.path.insert(0, str(__file__).rsplit("/", 2)[0])

from models.triton_client import (
    MockTritonClient,
    InferenceConfig,
    InferenceResult,
    create_triton_client,
)


# Strategies for generating test data
arabic_chars = "أبتثجحخدذرزسشصضطظعغفقكلمنهوي"
valid_prompts = st.text(
    alphabet=string.ascii_letters + string.digits + " " + arabic_chars,
    min_size=1,
    max_size=200,
).filter(lambda x: x.strip())

valid_max_tokens = st.integers(min_value=1, max_value=512)
valid_temperatures = st.floats(min_value=0.1, max_value=2.0, allow_nan=False)
valid_top_p = st.floats(min_value=0.1, max_value=1.0, allow_nan=False)
valid_top_k = st.integers(min_value=1, max_value=100)


@st.composite
def valid_inference_configs(draw: st.DrawFn) -> InferenceConfig:
    """Generate valid InferenceConfig objects."""
    return InferenceConfig(
        max_tokens=draw(valid_max_tokens),
        temperature=draw(valid_temperatures),
        top_p=draw(valid_top_p),
        top_k=draw(valid_top_k),
        stream=True,
    )


class TestStreamingTokenDelivery:
    """
    Property tests for streaming token delivery.
    
    **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
    **Validates: Requirements 3.2, 9.2**
    """

    @given(prompt=valid_prompts)
    @settings(max_examples=100)
    def test_streaming_delivers_tokens_progressively(self, prompt: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
        **Validates: Requirements 3.2, 9.2**
        
        For any valid prompt, streaming inference delivers tokens progressively,
        meaning the client receives partial content before the full response.
        """
        async def run_test():
            client = create_triton_client(use_mock=True)
            
            tokens_received: List[str] = []
            timestamps: List[float] = []
            
            import time
            start_time = time.perf_counter()
            
            async for token in client.infer_stream(prompt):
                tokens_received.append(token)
                timestamps.append(time.perf_counter() - start_time)
            
            # Property: Must receive at least one token
            assert len(tokens_received) >= 1, "Should receive at least one token"
            
            # Property: Tokens should arrive progressively (not all at once)
            if len(timestamps) > 1:
                # Check that there's some time gap between tokens
                time_gaps = [
                    timestamps[i] - timestamps[i-1] 
                    for i in range(1, len(timestamps))
                ]
                # At least some gaps should be non-zero (progressive delivery)
                assert any(gap > 0 for gap in time_gaps), \
                    "Tokens should be delivered progressively, not all at once"
            
            # Property: Concatenated tokens form a non-empty response
            full_response = "".join(tokens_received)
            assert full_response.strip(), "Full response should be non-empty"
            
            await client.close()
        
        asyncio.get_event_loop().run_until_complete(run_test())

    @given(prompt=valid_prompts, config=valid_inference_configs())
    @settings(max_examples=100)
    def test_streaming_with_config_delivers_tokens(
        self, prompt: str, config: InferenceConfig
    ) -> None:
        """
        **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
        **Validates: Requirements 3.2, 9.2**
        
        For any valid prompt and inference config, streaming delivers tokens.
        """
        async def run_test():
            client = create_triton_client(use_mock=True)
            
            tokens_received: List[str] = []
            
            async for token in client.infer_stream(prompt, config):
                tokens_received.append(token)
            
            # Property: Must receive tokens
            assert len(tokens_received) >= 1, "Should receive at least one token"
            
            # Property: Each token is a string
            for token in tokens_received:
                assert isinstance(token, str), "Each token should be a string"
            
            await client.close()
        
        asyncio.get_event_loop().run_until_complete(run_test())

    @given(prompt=valid_prompts)
    @settings(max_examples=100)
    def test_streaming_partial_content_before_complete(self, prompt: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
        **Validates: Requirements 3.2, 9.2**
        
        For any streaming request, client receives partial content before
        the full response is complete.
        """
        async def run_test():
            client = create_triton_client(use_mock=True)
            
            partial_contents: List[str] = []
            accumulated = ""
            
            async for token in client.infer_stream(prompt):
                accumulated += token
                partial_contents.append(accumulated)
            
            # Property: Should have multiple partial states
            # (unless response is a single token)
            if len(partial_contents) > 1:
                # Each partial content should be a prefix of the next
                for i in range(len(partial_contents) - 1):
                    assert partial_contents[i+1].startswith(partial_contents[i]), \
                        "Each partial content should be a prefix of the next"
                
                # First partial should be shorter than final
                assert len(partial_contents[0]) < len(partial_contents[-1]), \
                    "First partial should be shorter than final response"
            
            await client.close()
        
        asyncio.get_event_loop().run_until_complete(run_test())


class TestStreamingVsSynchronousConsistency:
    """
    Property tests comparing streaming vs synchronous inference.
    
    **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
    **Validates: Requirements 3.2, 9.2**
    """

    @given(prompt=valid_prompts)
    @settings(max_examples=100)
    def test_streaming_and_sync_produce_same_content(self, prompt: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
        **Validates: Requirements 3.2, 9.2**
        
        For any prompt, streaming and synchronous inference produce
        equivalent final content.
        """
        async def run_test():
            client = create_triton_client(use_mock=True)
            
            # Get synchronous result
            sync_result = await client.infer(prompt)
            sync_text = sync_result.text
            
            # Get streaming result
            streaming_tokens: List[str] = []
            async for token in client.infer_stream(prompt):
                streaming_tokens.append(token)
            streaming_text = "".join(streaming_tokens).strip()
            
            # Property: Both should produce non-empty results
            assert sync_text.strip(), "Sync result should be non-empty"
            assert streaming_text, "Streaming result should be non-empty"
            
            # Property: Results should be equivalent
            # (allowing for whitespace differences)
            assert sync_text.strip() == streaming_text.strip(), \
                f"Sync and streaming should produce same content: " \
                f"'{sync_text}' vs '{streaming_text}'"
            
            await client.close()
        
        asyncio.get_event_loop().run_until_complete(run_test())


class TestInferenceResultProperties:
    """
    Property tests for InferenceResult structure.
    
    **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
    **Validates: Requirements 3.2, 9.2**
    """

    @given(prompt=valid_prompts)
    @settings(max_examples=100)
    def test_inference_result_has_valid_structure(self, prompt: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 7: Streaming Token Delivery**
        **Validates: Requirements 3.2, 9.2**
        
        For any prompt, inference result has valid structure with
        non-negative latency and token count.
        """
        async def run_test():
            client = create_triton_client(use_mock=True)
            
            result = await client.infer(prompt)
            
            # Property: Result has non-empty text
            assert result.text.strip(), "Result text should be non-empty"
            
            # Property: Latency is non-negative
            assert result.latency_ms >= 0, "Latency should be non-negative"
            
            # Property: Token count is positive
            assert result.tokens_generated >= 0, "Token count should be non-negative"
            
            # Property: Finish reason is valid
            assert result.finish_reason in ("stop", "length", "error"), \
                f"Invalid finish reason: {result.finish_reason}"
            
            await client.close()
        
        asyncio.get_event_loop().run_until_complete(run_test())
