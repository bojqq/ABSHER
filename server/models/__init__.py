"""
Models module for TensorRT-LLM and Triton configurations.

This module contains:
- Triton model repository configurations (config.pbtxt files)
- Model configuration utilities

The triton_model_repository/ directory contains:
- allam_tensorrt/: TensorRT-LLM engine configuration
- preprocessing/: Tokenization model
- postprocessing/: Detokenization model  
- ensemble/: End-to-end pipeline configuration
"""

from pathlib import Path

# Path to Triton model repository
TRITON_MODEL_REPOSITORY = Path(__file__).parent / "triton_model_repository"

# Model names
ALLAM_MODEL_NAME = "allam_tensorrt"
PREPROCESSING_MODEL_NAME = "preprocessing"
POSTPROCESSING_MODEL_NAME = "postprocessing"
ENSEMBLE_MODEL_NAME = "ensemble"

__all__ = [
    "TRITON_MODEL_REPOSITORY",
    "ALLAM_MODEL_NAME",
    "PREPROCESSING_MODEL_NAME",
    "POSTPROCESSING_MODEL_NAME",
    "ENSEMBLE_MODEL_NAME",
]
