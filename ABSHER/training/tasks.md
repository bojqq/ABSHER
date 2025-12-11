# Phi-3 Absher Training - Quick Reference

> 📋 **For clickable tasks, see:** `.kiro/specs/phi3-absher-training/tasks.md`

## Quick Start Commands

```bash
# 1. Install dependencies
pip install transformers peft datasets accelerate bitsandbytes trl torch mlx-lm

# 2. Train the model (on GPU)
cd ABSHER/training
python train_phi3_absher.py

# 3. Merge LoRA weights
python merge_lora.py

# 4. Convert to MLX
chmod +x convert_to_mlx.sh
./convert_to_mlx.sh

# 5. Test
mlx_lm.generate --model ./phi3-absher-mlx --prompt "<|user|>وش خدمات أبشر؟<|end|><|assistant|>"
```

## Files in This Directory

| File | Description |
|------|-------------|
| `absher_data.jsonl` | 301 training examples |
| `train_phi3_absher.py` | Main training script |
| `merge_lora.py` | LoRA merge script |
| `convert_to_mlx.sh` | MLX conversion script |

## Training Data Coverage (301 examples)

| Category | Arabic | Count |
|----------|--------|-------|
| Driving License | رخصة القيادة | ~50 |
| Passport | جواز السفر | ~50 |
| National ID | الهوية الوطنية | ~40 |
| Vehicles | المركبات | ~40 |
| Visas | التأشيرات | ~40 |
| Traffic Violations | المخالفات | ~30 |
| National Address | العنوان الوطني | ~20 |
| General Services | خدمات عامة | ~30 |

## Hardware Options

| Option | GPU | Time | Cost |
|--------|-----|------|------|
| Google Colab Pro | T4/A100 | 1-2 hours | $10/month |
| RunPod | A100 | 30 min | ~$2 |
| Local Mac M1/M2/M3 | - | 4-6 hours | Free |
