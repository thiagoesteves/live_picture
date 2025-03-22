# Live Picture

> 📷 Analyze Your Images with AI

**Live Picture** is a Phoenix LiveView application designed for image analysis using machine learning (ML) techniques.

We currently use **Pythonx** and **EXLA** for integrating Python-based ML models and accelerating numerical computations.

### 🔧 Technologies Used

- **Pythonx**: An Elixir library that embeds a Python interpreter, enabling execution of Python code and access to Python-based ML libraries like TensorFlow and PyTorch within Elixir applications.
- **EXLA**: A backend for Elixir’s Nx library that provides just-in-time (JIT) compilation for numerical computations, optimizing tensor operations for CPUs, GPUs, and TPUs using Google's XLA (Accelerated Linear Algebra) technology.

## 🔉 Features

✅ Upload an image and choose a model for analysis.  
✅ View the image alongside the model’s predictions.  
✅ Supports multiple CNN architectures for image classification.

## 🖼️ Image Prediction Models Available

Live Picture supports the following image classification models:

- **AlexNet**: A pioneering convolutional neural network (CNN) that won the ImageNet Large Scale Visual Recognition Challenge in 2012.
- **ConvNeXt**: A modernized CNN that incorporates design elements from Vision Transformers for improved performance and efficiency.
- **ResNet18**: A residual network that introduces skip connections to solve the vanishing gradient problem, enabling deeper network training.
- **SqueezeNet**: A lightweight architecture with fewer parameters than AlexNet while achieving similar accuracy, making it ideal for resource-constrained environments.
- **VGG16**: A widely-used deep CNN with 16 layers, known for its simplicity and strong performance in image classification tasks.
- **DenseNet121**: A CNN architecture where each layer connects to every other layer in a feed-forward fashion, creating dense connections that promote feature reuse, reduce parameter count, and combat vanishing gradients.
- **EfficientNet**: A family of models that uses compound scaling to uniformly scale network width, depth, and resolution, achieving state-of-the-art accuracy with significantly fewer parameters and FLOPS.
- **MobileNet**: A lightweight CNN specifically designed for mobile and embedded devices, using depth-wise separable convolutions to reduce computational requirements while maintaining reasonable accuracy.
- **RegNet**: A systematically designed CNN architecture family developed through a structure-parameterized design space, optimizing the trade-off between accuracy, model size, and computational efficiency.
- **Vision** Transformer (ViT): A model that applies the transformer architecture from NLP to image recognition by splitting images into patches and processing them as sequences, demonstrating strong performance with sufficient training data.
- **Swin** Transformer: A hierarchical vision transformer that uses shifted windows for efficient attention computation, addressing the limitations of ViT by incorporating CNN-like properties of locality and hierarchical representation.
- **Inception**: A CNN architecture that uses parallel convolutions with different filter sizes to capture features at multiple scales simultaneously, allowing the network to extract both local and global patterns efficiently.

## 📁 Getting Started

It’s best to use [**asdf**](https://github.com/asdf-vm/asdf) to manage these dependencies and ensure compatibility across different environments.

### 🚀 Running the Application

Once all dependencies are installed, start the application by running:

```sh
iex -S mix phx.server
Erlang/OTP 26 [erts-14.2.5.8] [source] [64-bit] [smp:10:10] [ds:10:10:10] [async-threads:1] [jit]

Compiling 14 files (.ex)
Generated live_picture app
[info] Creating Onnx model for alexnet
[info] initializing server model for alexnet
[info] Creating Onnx model for convnext
[info] initializing server model for convnext
[info] Creating Onnx model for resnet18
...
```

Each time the application starts, it executes the Python script for each module to generate the ONNX
files and stores them in /tmp/live_picture. If the model files already exist, they will not be recreated
on subsequent runs. Instead, the application will load the existing ONNX files for their respective
models during runtime operations.

The application will be available at [http://localhost:4000](http://localhost:4000)

☎️ **Contact us:**
Feel free to contact me on [Linkedin](https://www.linkedin.com/in/thiago-cesar-calori-esteves-972368115/).

## ©️ Copyright and License

Copyright (c) 2025, Thiago Esteves.

LivePicture source code is licensed under the [MIT License](LICENSE.md). fix anything that can be made better
