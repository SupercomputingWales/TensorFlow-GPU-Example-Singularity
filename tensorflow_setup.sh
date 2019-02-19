#!/bin/bash

echo "Setting up Anaconda environment"
conda env create -f tensorflow-gpu.yml

echo "Downloading example code"
#download example code
wget https://raw.githubusercontent.com/aymericdamien/TensorFlow-Examples/master/examples/3_NeuralNetworks/multilayer_perceptron.py

echo "Patching example code for GPU usage"
#the patch file contains changes to make this example use the GPU
#setup path to data files correctly, for some reason python/tensor flow doesn't like using ~/neuralnet_data so we need /home/<userid>/neuralnet_data
sed -i "s/a.cos/\/opt\/TensorFlow-GPU-Example-Singularity\/neuralnet_data\/" multilayer_perceptron.py.patch
patch multilayer_perceptron.py multilayer_perceptron.py.patch

echo "Downloading example MNIST data to /opt/TensorFlow-GPU-Example-Singularity/neuralnet_data"
mkdir /opt/TensorFlow-GPU-Example-Singularity/neuralnet_data
cd /opt/TensorFlow-GPU-Example-Singularity/neuralnet_dataneuralnet_data
wget http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz

