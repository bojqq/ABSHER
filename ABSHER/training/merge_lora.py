#!/usr/bin/env python3
"""
Merge LoRA Adapter with Base Model
==================================
This script merges the trained LoRA adapter with the base Phi-3 model
to create a standalone fine-tuned model.

Usage:
    python merge_lora.py
"""

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer
from peft import PeftModel

# Configuration
BASE_MODEL_ID = "microsoft/Phi-3-mini-4k-instruct"
LORA_ADAPTER_PATH = "./phi3-absher-lora"
MERGED_OUTPUT_PATH = "./phi3-absher-merged"


def merge_lora():
    """Merge LoRA adapter with base model."""
    print("=" * 50)
    print("🔀 Merging LoRA Adapter with Base Model")
    print("=" * 50)
    
    # Load base model
    print("\n📦 Loading base model...")
    base_model = AutoModelForCausalLM.from_pretrained(
        BASE_MODEL_ID,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True,
    )
    
    # Load tokenizer
    print("📝 Loading tokenizer...")
    tokenizer = AutoTokenizer.from_pretrained(BASE_MODEL_ID, trust_remote_code=True)
    
    # Load LoRA adapter
    print("🔧 Loading LoRA adapter...")
    model = PeftModel.from_pretrained(base_model, LORA_ADAPTER_PATH)
    
    # Merge weights
    print("🔀 Merging weights...")
    merged_model = model.merge_and_unload()
    
    # Save merged model
    print(f"\n💾 Saving merged model to: {MERGED_OUTPUT_PATH}")
    merged_model.save_pretrained(MERGED_OUTPUT_PATH)
    tokenizer.save_pretrained(MERGED_OUTPUT_PATH)
    
    print("\n✅ Merge complete!")
    print(f"   Merged model saved to: {MERGED_OUTPUT_PATH}")
    
    print("\n" + "=" * 50)
    print("Next step: Convert to MLX format")
    print("=" * 50)
    print("\nRun:")
    print(f"  mlx_lm.convert --hf-path {MERGED_OUTPUT_PATH} --mlx-path ./phi3-absher-mlx -q")


if __name__ == "__main__":
    merge_lora()
