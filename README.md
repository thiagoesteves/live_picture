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

## 📁 Getting Started  

To run **Live Picture**, you need the following installed:  

### 🛠 Required Dependencies  

- **Erlang**: `26.2.5.9`  
- **Elixir**: `1.17.0-otp-26`  
- **Python**: `3.8.17`  
- **Rust**: Required for compiling the `ortex` dependency  

### 📌 Recommended Setup  

It’s best to use [**asdf**](https://github.com/asdf-vm/asdf) to manage these dependencies and ensure compatibility across different environments.  

### 🚀 Running the Application  

Once all dependencies are installed, start the application by running:  

```sh
mix phx.server
```

The application will be available at http://localhost:4000.

☎️ **Contact us:**
Feel free to contact me on [Linkedin](https://www.linkedin.com/in/thiago-cesar-calori-esteves-972368115/).

## ©️ Copyright and License

Copyright (c) 2025, Thiago Esteves.

DeployEx source code is licensed under the [MIT License](LICENSE.md). fix anything that can be made better