# MLX Swift Setup Instructions

## Adding MLX Swift Packages to the Xcode Project

To integrate MLX Swift for local LLM inference, follow these steps:

### Step 1: Add Swift Package Dependencies

1. Open `ABSHER.xcodeproj` in Xcode
2. Go to **File > Add Package Dependencies...**
3. Add the following packages:

#### MLX Swift
- URL: `https://github.com/ml-explore/mlx-swift`
- Version: Latest stable release
- Add to target: `ABSHER`

#### MLX Swift LLM (for LLM-specific functionality)
- URL: `https://github.com/ml-explore/mlx-swift-examples`
- Version: Latest stable release
- Add to target: `ABSHER`
- Select the `MLXLLM` product

### Step 2: Configure Build Settings for Apple Silicon

1. Select the `ABSHER` target
2. Go to **Build Settings**
3. Ensure the following settings:
   - **Architectures**: Standard Architectures (Apple Silicon, Intel)
   - **Build Active Architecture Only**: Yes (for Debug)
   - **Optimization Level**: `-O` for Release builds

### Step 3: Verify Installation

After adding the packages, verify by importing in any Swift file:

```swift
import MLX
import MLXLLM
```

If the imports compile without errors, the setup is complete.

## Requirements

- macOS with Apple Silicon (M1/M2/M3) or Intel with 16GB+ RAM
- Xcode 15.0 or later
- iOS 17.0+ deployment target (for MLX support)

## Model Setup

The Sci 3 model should be placed in the app's documents directory or bundled with the app. See `MLXService.swift` for model loading implementation.
