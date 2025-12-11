"""
Property-based tests for API request validation.

**Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
**Validates: Requirements 3.1, 3.3**

Tests that for any valid chat request with a non-empty message,
the API returns a valid response structure.
"""

import string
from hypothesis import given, strategies as st, settings
from pydantic import ValidationError

from api.models import Message, ChatRequest, ChatResponse, RAGSource


# Strategies for generating valid data
valid_roles = st.sampled_from(["user", "assistant", "system"])
non_empty_strings = st.text(
    alphabet=string.ascii_letters + string.digits + " أبتثجحخدذرزسشصضطظعغفقكلمنهوي",
    min_size=1,
    max_size=500,
).filter(lambda x: x.strip())

valid_user_ids = st.text(
    alphabet=string.ascii_letters + string.digits + "-_",
    min_size=1,
    max_size=100,
).filter(lambda x: x.strip())


@st.composite
def valid_messages(draw: st.DrawFn) -> Message:
    """Generate valid Message objects."""
    role = draw(valid_roles)
    content = draw(non_empty_strings)
    return Message(role=role, content=content)


@st.composite
def valid_chat_requests(draw: st.DrawFn) -> ChatRequest:
    """Generate valid ChatRequest objects."""
    messages = draw(st.lists(valid_messages(), min_size=1, max_size=10))
    user_id = draw(valid_user_ids)
    session_id = draw(st.one_of(st.none(), valid_user_ids))
    return ChatRequest(messages=messages, user_id=user_id, session_id=session_id)


class TestMessageValidation:
    """Property tests for Message model validation."""

    @given(role=valid_roles, content=non_empty_strings)
    @settings(max_examples=100)
    def test_valid_message_creation(self, role: str, content: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any valid role and non-empty content, Message creation succeeds.
        """
        message = Message(role=role, content=content)
        assert message.role == role
        assert message.content == content

    @given(content=non_empty_strings)
    @settings(max_examples=100)
    def test_invalid_role_rejected(self, content: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any invalid role, Message creation fails with ValidationError.
        """
        invalid_roles = ["admin", "bot", "unknown", "", "USER", "ASSISTANT"]
        for invalid_role in invalid_roles:
            try:
                Message(role=invalid_role, content=content)
                assert False, f"Should have rejected role: {invalid_role}"
            except ValidationError:
                pass  # Expected

    @given(role=valid_roles)
    @settings(max_examples=100)
    def test_empty_content_rejected(self, role: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any empty or whitespace-only content, Message creation fails.
        """
        empty_contents = ["", "   ", "\t", "\n", "  \t\n  "]
        for empty_content in empty_contents:
            try:
                Message(role=role, content=empty_content)
                assert False, f"Should have rejected empty content: {repr(empty_content)}"
            except ValidationError:
                pass  # Expected


class TestChatRequestValidation:
    """Property tests for ChatRequest model validation."""

    @given(request=valid_chat_requests())
    @settings(max_examples=100)
    def test_valid_request_structure(self, request: ChatRequest) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any valid ChatRequest, all fields are properly set.
        """
        assert len(request.messages) >= 1
        assert request.user_id.strip()
        for msg in request.messages:
            assert msg.role in ("user", "assistant", "system")
            assert msg.content.strip()

    @given(messages=st.lists(valid_messages(), min_size=1, max_size=5))
    @settings(max_examples=100)
    def test_empty_user_id_rejected(self, messages: list) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any empty user_id, ChatRequest creation fails.
        """
        empty_user_ids = ["", "   ", "\t"]
        for empty_id in empty_user_ids:
            try:
                ChatRequest(messages=messages, user_id=empty_id)
                assert False, f"Should have rejected empty user_id: {repr(empty_id)}"
            except ValidationError:
                pass  # Expected

    @given(user_id=valid_user_ids)
    @settings(max_examples=100)
    def test_empty_messages_rejected(self, user_id: str) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any empty messages list, ChatRequest creation fails.
        """
        try:
            ChatRequest(messages=[], user_id=user_id)
            assert False, "Should have rejected empty messages"
        except ValidationError:
            pass  # Expected


class TestChatResponseValidation:
    """Property tests for ChatResponse model validation."""

    @given(
        response_text=non_empty_strings,
        session_id=valid_user_ids,
        latency=st.floats(min_value=0.0, max_value=30000.0, allow_nan=False),
    )
    @settings(max_examples=100)
    def test_valid_response_structure(
        self, response_text: str, session_id: str, latency: float
    ) -> None:
        """
        **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
        **Validates: Requirements 3.1, 3.3**
        
        For any valid response data, ChatResponse creation succeeds
        and contains non-empty response.
        """
        response = ChatResponse(
            response=response_text,
            session_id=session_id,
            sources=[],
            latency_ms=latency,
        )
        assert response.response == response_text
        assert response.response.strip()  # Non-empty
        assert response.session_id == session_id
        assert response.latency_ms >= 0


class TestRequestResponseConsistency:
    """
    Property tests for request-response consistency.
    
    **Feature: tensorrt-llm-server, Property 1: API Request-Response Consistency**
    **Validates: Requirements 3.1, 3.3**
    """

    @given(request=valid_chat_requests())
    @settings(max_examples=100)
    def test_request_can_be_serialized_and_deserialized(
        self, request: ChatRequest
    ) -> None:
        """
        For any valid ChatRequest, serialization round-trip preserves data.
        """
        json_data = request.model_dump()
        restored = ChatRequest.model_validate(json_data)
        
        assert restored.user_id == request.user_id
        assert restored.session_id == request.session_id
        assert len(restored.messages) == len(request.messages)
        
        for orig, rest in zip(request.messages, restored.messages):
            assert orig.role == rest.role
            assert orig.content == rest.content
