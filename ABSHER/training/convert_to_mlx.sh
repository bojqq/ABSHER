#!/bin/bash
# ============================================
# Convert Phi-3 Absher to MLX Format
# ============================================
# This script converts the fine-tuned Phi-3 model to MLX format
# for use on Apple Silicon devices.
#
# Prerequisites:
#   pip install mlx-lm
#
# Usage:
#   chmod +x convert_to_mlx.sh
#   ./convert_to_mlx.sh
# ============================================

set -e

echo "============================================"
echo "🍎 Converting to MLX Format"
echo "============================================"

# Check if mlx-lm is installed
if ! command -v mlx_lm.convert &> /dev/null; then
    echo "❌ mlx-lm not found. Installing..."
    pip install mlx-lm
fi

# Convert to MLX with 4-bit quantization
echo ""
echo "📦 Converting model..."
mlx_lm.convert \
    --hf-path ./phi3-absher-merged \
    --mlx-path ./phi3-absher-mlx \
    -q

echo ""
echo "✅ Conversion complete!"
echo "   MLX model saved to: ./phi3-absher-mlx"

# Test the model
echo ""
echo "============================================"
echo "🧪 Testing the model..."
echo "============================================"
echo ""

mlx_lm.generate \
    --model ./phi3-absher-mlx \
    --prompt "<|system|>أنت مساعد أبشر الذكي.<|end|><|user|>كيف أجدد جواز السفر؟<|end|><|assistant|>" \
    --max-tokens 150

echo ""
echo "============================================"
echo "🎉 All done!"
echo "============================================"
echo ""
echo "Your MLX model is ready at: ./phi3-absher-mlx"
echo ""
echo "To use in your iOS app:"
echo "1. Copy the phi3-absher-mlx folder to your Xcode project"
echo "2. Update MLXService.swift to load from this path"
echo ""
