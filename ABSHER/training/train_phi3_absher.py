#!/usr/bin/env python3
"""
Phi-3 Fine-tuning Script for Absher Chatbot
============================================
This script fine-tunes Microsoft's Phi-3-mini-4k-instruct model
on Absher government services data using LoRA (Low-Rank Adaptation).

Requirements:
    pip install transformers peft datasets accelerate bitsandbytes trl torch

Usage:
    python train_phi3_absher.py

Output:
    - ./phi3-absher-lora/     : LoRA adapter weights
    - ./phi3-absher-merged/   : Merged full model
"""

import os
import torch
from datasets import load_dataset
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    BitsAndBytesConfig,
)
from peft import LoraConfig, get_peft_model, prepare_model_for_kbit_training
from trl import SFTTrainer

# ============================================
# Configuration
# ============================================

MODEL_ID = "microsoft/Phi-3-mini-4k-instruct"
DATASET_PATH = "absher_data.jsonl"
OUTPUT_DIR = "./phi3-absher-lora"
MERGED_OUTPUT_DIR = "./phi3-absher-merged"

# Training hyperparameters
NUM_EPOCHS = 5
BATCH_SIZE = 2
GRADIENT_ACCUMULATION_STEPS = 4
LEARNING_RATE = 2e-4
MAX_SEQ_LENGTH = 512

# LoRA configuration
LORA_R = 32  # Higher rank for better Arabic learning
LORA_ALPHA = 64
LORA_DROPOUT = 0.05

# ============================================
# Setup
# ============================================

def setup_model_and_tokenizer():
    """Load and configure the model and tokenizer."""
    print("📦 Loading model and tokenizer...")
    
    # Quantization config for memory efficiency
    bnb_config = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_compute_dtype=torch.bfloat16,
        bnb_4bit_use_double_quant=True,
    )
    
    # Load model
    model = AutoModelForCausalLM.from_pretrained(
        MODEL_ID,
        quantization_config=bnb_config,
        device_map="auto",
        trust_remote_code=True,
        attn_implementation="eager",  # For compatibility
    )
    
    # Load tokenizer
    tokenizer = AutoTokenizer.from_pretrained(MODEL_ID, trust_remote_code=True)
    tokenizer.pad_token = tokenizer.eos_token
    tokenizer.padding_side = "right"
    
    return model, tokenizer


def setup_lora(model):
    """Configure LoRA for efficient fine-tuning."""
    print("🔧 Configuring LoRA...")
    
    # Prepare model for k-bit training
    model = prepare_model_for_kbit_training(model)
    
    # LoRA configuration
    lora_config = LoraConfig(
        r=LORA_R,
        lora_alpha=LORA_ALPHA,
        target_modules=[
            "q_proj", "k_proj", "v_proj", "o_proj",
            "gate_proj", "up_proj", "down_proj"
        ],
        lora_dropout=LORA_DROPOUT,
        bias="none",
        task_type="CAUSAL_LM",
    )
    
    model = get_peft_model(model, lora_config)
    model.print_trainable_parameters()
    
    return model


def load_training_data():
    """Load and prepare the training dataset."""
    print("📚 Loading training data...")
    
    dataset = load_dataset("json", data_files=DATASET_PATH, split="train")
    print(f"   Loaded {len(dataset)} examples")
    
    return dataset


def format_chat_template(example):
    """Format examples for Phi-3 chat template."""
    messages = example["messages"]
    formatted = ""
    
    for msg in messages:
        role = msg["role"]
        content = msg["content"]
        
        if role == "system":
            formatted += f"<|system|>\n{content}<|end|>\n"
        elif role == "user":
            formatted += f"<|user|>\n{content}<|end|>\n"
        elif role == "assistant":
            formatted += f"<|assistant|>\n{content}<|end|>\n"
    
    return {"text": formatted}


# ============================================
# Training
# ============================================

def train():
    """Main training function."""
    print("=" * 50)
    print("🚀 Phi-3 Absher Fine-tuning")
    print("=" * 50)
    
    # Setup
    model, tokenizer = setup_model_and_tokenizer()
    model = setup_lora(model)
    dataset = load_training_data()
    
    # Format dataset
    print("📝 Formatting dataset...")
    dataset = dataset.map(format_chat_template)
    
    # Training arguments
    training_args = TrainingArguments(
        output_dir=OUTPUT_DIR,
        num_train_epochs=NUM_EPOCHS,
        per_device_train_batch_size=BATCH_SIZE,
        gradient_accumulation_steps=GRADIENT_ACCUMULATION_STEPS,
        learning_rate=LEARNING_RATE,
        warmup_ratio=0.1,
        logging_steps=10,
        save_strategy="epoch",
        save_total_limit=2,
        bf16=True,
        optim="paged_adamw_8bit",
        gradient_checkpointing=True,
        max_grad_norm=0.3,
        lr_scheduler_type="cosine",
        report_to="none",  # Disable wandb
    )
    
    # Trainer
    trainer = SFTTrainer(
        model=model,
        train_dataset=dataset,
        tokenizer=tokenizer,
        args=training_args,
        max_seq_length=MAX_SEQ_LENGTH,
        dataset_text_field="text",
        packing=False,
    )
    
    # Train!
    print("\n🏋️ Starting training...")
    print(f"   Epochs: {NUM_EPOCHS}")
    print(f"   Batch size: {BATCH_SIZE}")
    print(f"   Learning rate: {LEARNING_RATE}")
    print(f"   LoRA rank: {LORA_R}")
    print()
    
    trainer.train()
    
    # Save LoRA adapter
    print("\n💾 Saving LoRA adapter...")
    trainer.save_model(OUTPUT_DIR)
    tokenizer.save_pretrained(OUTPUT_DIR)
    
    print("\n✅ Training complete!")
    print(f"   LoRA adapter saved to: {OUTPUT_DIR}")
    
    return model, tokenizer


def merge_and_save(model, tokenizer):
    """Merge LoRA weights with base model and save."""
    print("\n🔀 Merging LoRA weights with base model...")
    
    # Merge and unload
    merged_model = model.merge_and_unload()
    
    # Save merged model
    print(f"💾 Saving merged model to: {MERGED_OUTPUT_DIR}")
    merged_model.save_pretrained(MERGED_OUTPUT_DIR)
    tokenizer.save_pretrained(MERGED_OUTPUT_DIR)
    
    print("✅ Merged model saved!")


# ============================================
# Main
# ============================================

if __name__ == "__main__":
    # Check CUDA
    if torch.cuda.is_available():
        print(f"🎮 GPU: {torch.cuda.get_device_name(0)}")
        print(f"   Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB")
    else:
        print("⚠️  No GPU detected. Training will be slow!")
    
    print()
    
    # Train
    model, tokenizer = train()
    
    # Merge (optional - uncomment if you want merged model)
    # merge_and_save(model, tokenizer)
    
    print("\n" + "=" * 50)
    print("🎉 All done!")
    print("=" * 50)
    print("\nNext steps:")
    print("1. Merge LoRA weights (if not done):")
    print("   python merge_lora.py")
    print("\n2. Convert to MLX format:")
    print("   mlx_lm.convert --hf-path ./phi3-absher-merged --mlx-path ./phi3-absher-mlx -q")
    print("\n3. Test the model:")
    print("   mlx_lm.generate --model ./phi3-absher-mlx --prompt '<|user|>كيف أجدد الجواز؟<|end|><|assistant|>'")
