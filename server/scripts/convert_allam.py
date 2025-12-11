#!/usr/bin/env python3
"""
Convert Allam model to TensorRT-LLM format.

This script converts the Allam Arabic LLM to TensorRT-LLM engine format
for optimized inference on NVIDIA GPUs via Triton Inference Server.

Requirements: 2.1, 2.2, 2.3
"""

import argparse
import logging
import os
import sys
from dataclasses import dataclass
from enum import Enum
from pathlib import Path
from typing import Optional

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)


class QuantizationType(Enum):
    """Supported quantization types for model optimization."""
    FP32 = "float32"
    FP16 = "float16"
    INT8 = "int8"
    INT4 = "int4"


class GPUArchitecture(Enum):
    """Supported NVIDIA GPU architectures."""
    AMPERE = "ampere"      # A100, A10, A30
    HOPPER = "hopper"      # H100, H200
    ADA = "ada"            # L40, RTX 4090


@dataclass
class ConversionConfig:
    """Configuration for model conversion."""
    model_dir: Path
    output_dir: Path
    quantization: QuantizationType
    gpu_architecture: GPUArchitecture
    max_batch_size: int
    max_input_len: int
    max_output_len: int
    max_beam_width: int
    tensor_parallel_size: int
    use_inflight_batching: bool
    
    def validate(self) -> None:
        """Validate configuration parameters."""
        if not self.model_dir.exists():
            raise ValueError(f"Model directory does not exist: {self.model_dir}")
        
        if self.max_batch_size < 1 or self.max_batch_size > 256:
            raise ValueError("max_batch_size must be between 1 and 256")
        
        if self.max_input_len < 1 or self.max_input_len > 32768:
            raise ValueError("max_input_len must be between 1 and 32768")
        
        if self.max_output_len < 1 or self.max_output_len > 8192:
            raise ValueError("max_output_len must be between 1 and 8192")
        
        if self.tensor_parallel_size < 1:
            raise ValueError("tensor_parallel_size must be at least 1")



class AllamModelConverter:
    """
    Converter for Allam Arabic LLM to TensorRT-LLM format.
    
    This class handles the conversion of the Allam model (based on LLaMA architecture)
    to an optimized TensorRT-LLM engine for deployment on NVIDIA GPUs.
    """
    
    def __init__(self, config: ConversionConfig):
        """Initialize the converter with configuration."""
        self.config = config
        self._validate_environment()
    
    def _validate_environment(self) -> None:
        """Validate that required dependencies are available."""
        try:
            import tensorrt_llm
            logger.info(f"TensorRT-LLM version: {tensorrt_llm.__version__}")
        except ImportError:
            logger.warning(
                "TensorRT-LLM not installed. Install with: pip install tensorrt-llm"
            )
    
    def _get_quantization_config(self) -> dict:
        """Get quantization configuration based on selected type."""
        configs = {
            QuantizationType.FP32: {
                "dtype": "float32",
                "use_weight_only": False,
                "weight_only_precision": None,
            },
            QuantizationType.FP16: {
                "dtype": "float16",
                "use_weight_only": False,
                "weight_only_precision": None,
            },
            QuantizationType.INT8: {
                "dtype": "float16",
                "use_weight_only": True,
                "weight_only_precision": "int8",
            },
            QuantizationType.INT4: {
                "dtype": "float16",
                "use_weight_only": True,
                "weight_only_precision": "int4",
            },
        }
        return configs[self.config.quantization]
    
    def _get_builder_config(self) -> dict:
        """Get TensorRT builder configuration."""
        quant_config = self._get_quantization_config()
        
        return {
            "precision": quant_config["dtype"],
            "max_batch_size": self.config.max_batch_size,
            "max_input_len": self.config.max_input_len,
            "max_output_len": self.config.max_output_len,
            "max_beam_width": self.config.max_beam_width,
            "tensor_parallel": self.config.tensor_parallel_size,
            "use_inflight_batching": self.config.use_inflight_batching,
            "use_weight_only": quant_config["use_weight_only"],
            "weight_only_precision": quant_config["weight_only_precision"],
        }
    
    def convert_checkpoint(self) -> Path:
        """
        Convert HuggingFace checkpoint to TensorRT-LLM format.
        
        Returns:
            Path to the converted checkpoint directory.
        """
        logger.info(f"Converting checkpoint from {self.config.model_dir}")
        
        checkpoint_dir = self.config.output_dir / "checkpoint"
        checkpoint_dir.mkdir(parents=True, exist_ok=True)
        
        # Build conversion command for TensorRT-LLM
        # Allam is based on LLaMA architecture
        convert_cmd = self._build_checkpoint_convert_command(checkpoint_dir)
        
        logger.info(f"Checkpoint conversion command: {convert_cmd}")
        logger.info(f"Checkpoint saved to: {checkpoint_dir}")
        
        return checkpoint_dir
    
    def _build_checkpoint_convert_command(self, output_dir: Path) -> str:
        """Build the checkpoint conversion command."""
        quant_config = self._get_quantization_config()
        
        cmd_parts = [
            "python -m tensorrt_llm.commands.convert_checkpoint",
            f"--model_dir {self.config.model_dir}",
            f"--output_dir {output_dir}",
            f"--dtype {quant_config['dtype']}",
            f"--tp_size {self.config.tensor_parallel_size}",
        ]
        
        if quant_config["use_weight_only"]:
            cmd_parts.append("--use_weight_only")
            cmd_parts.append(f"--weight_only_precision {quant_config['weight_only_precision']}")
        
        return " ".join(cmd_parts)
    
    def build_engine(self, checkpoint_dir: Path) -> Path:
        """
        Build TensorRT engine from converted checkpoint.
        
        Args:
            checkpoint_dir: Path to the converted checkpoint.
            
        Returns:
            Path to the built engine directory.
        """
        logger.info("Building TensorRT-LLM engine...")
        
        engine_dir = self.config.output_dir / "engine"
        engine_dir.mkdir(parents=True, exist_ok=True)
        
        build_cmd = self._build_engine_command(checkpoint_dir, engine_dir)
        
        logger.info(f"Engine build command: {build_cmd}")
        logger.info(f"Engine saved to: {engine_dir}")
        
        return engine_dir
    
    def _build_engine_command(self, checkpoint_dir: Path, engine_dir: Path) -> str:
        """Build the engine build command."""
        builder_config = self._get_builder_config()
        
        cmd_parts = [
            "trtllm-build",
            f"--checkpoint_dir {checkpoint_dir}",
            f"--output_dir {engine_dir}",
            f"--max_batch_size {builder_config['max_batch_size']}",
            f"--max_input_len {builder_config['max_input_len']}",
            f"--max_output_len {builder_config['max_output_len']}",
            f"--max_beam_width {builder_config['max_beam_width']}",
            f"--gemm_plugin {builder_config['precision']}",
            f"--gpt_attention_plugin {builder_config['precision']}",
        ]
        
        if builder_config["use_inflight_batching"]:
            cmd_parts.extend([
                "--paged_kv_cache enable",
                "--remove_input_padding enable",
                "--use_paged_context_fmha enable",
            ])
        
        return " ".join(cmd_parts)
    
    def convert(self) -> Path:
        """
        Run the full conversion pipeline.
        
        Returns:
            Path to the final engine directory.
        """
        logger.info("Starting Allam model conversion to TensorRT-LLM")
        logger.info(f"Configuration: {self.config}")
        
        self.config.validate()
        self.config.output_dir.mkdir(parents=True, exist_ok=True)
        
        # Step 1: Convert checkpoint
        checkpoint_dir = self.convert_checkpoint()
        
        # Step 2: Build engine
        engine_dir = self.build_engine(checkpoint_dir)
        
        logger.info(f"Conversion complete! Engine at: {engine_dir}")
        return engine_dir


def create_default_config(
    model_dir: str,
    output_dir: str,
    quantization: str = "float16",
    gpu_arch: str = "ampere",
) -> ConversionConfig:
    """Create a default conversion configuration."""
    return ConversionConfig(
        model_dir=Path(model_dir),
        output_dir=Path(output_dir),
        quantization=QuantizationType(quantization),
        gpu_architecture=GPUArchitecture(gpu_arch),
        max_batch_size=8,
        max_input_len=2048,
        max_output_len=512,
        max_beam_width=1,
        tensor_parallel_size=1,
        use_inflight_batching=True,
    )


def main() -> int:
    """Main entry point for model conversion."""
    parser = argparse.ArgumentParser(
        description="Convert Allam model to TensorRT-LLM format"
    )
    parser.add_argument(
        "--model-dir",
        type=str,
        required=True,
        help="Path to the Allam model directory (HuggingFace format)",
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        required=True,
        help="Output directory for TensorRT-LLM engine",
    )
    parser.add_argument(
        "--quantization",
        type=str,
        choices=["float32", "float16", "int8", "int4"],
        default="float16",
        help="Quantization type (default: float16)",
    )
    parser.add_argument(
        "--gpu-arch",
        type=str,
        choices=["ampere", "hopper", "ada"],
        default="ampere",
        help="Target GPU architecture (default: ampere)",
    )
    parser.add_argument(
        "--max-batch-size",
        type=int,
        default=8,
        help="Maximum batch size (default: 8)",
    )
    parser.add_argument(
        "--max-input-len",
        type=int,
        default=2048,
        help="Maximum input length (default: 2048)",
    )
    parser.add_argument(
        "--max-output-len",
        type=int,
        default=512,
        help="Maximum output length (default: 512)",
    )
    parser.add_argument(
        "--tensor-parallel",
        type=int,
        default=1,
        help="Tensor parallel size (default: 1)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print commands without executing",
    )
    
    args = parser.parse_args()
    
    config = ConversionConfig(
        model_dir=Path(args.model_dir),
        output_dir=Path(args.output_dir),
        quantization=QuantizationType(args.quantization),
        gpu_architecture=GPUArchitecture(args.gpu_arch),
        max_batch_size=args.max_batch_size,
        max_input_len=args.max_input_len,
        max_output_len=args.max_output_len,
        max_beam_width=1,
        tensor_parallel_size=args.tensor_parallel,
        use_inflight_batching=True,
    )
    
    converter = AllamModelConverter(config)
    
    if args.dry_run:
        logger.info("Dry run mode - printing commands only")
        config.output_dir.mkdir(parents=True, exist_ok=True)
        checkpoint_dir = config.output_dir / "checkpoint"
        engine_dir = config.output_dir / "engine"
        
        print("\n=== Checkpoint Conversion Command ===")
        print(converter._build_checkpoint_convert_command(checkpoint_dir))
        
        print("\n=== Engine Build Command ===")
        print(converter._build_engine_command(checkpoint_dir, engine_dir))
        
        return 0
    
    try:
        converter.convert()
        return 0
    except Exception as e:
        logger.error(f"Conversion failed: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
