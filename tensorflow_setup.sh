#!/bin/bash

filecount=`myquota | tail -1 | awk '{print $4}'`
filelimit=$[`myquota | tail -1 | awk '{print $5}' | tr -d 'k'`*1000]

#check user has enough files left
if [ $[$filelimit-$filecount] -lt "40000" ] ; then
  echo "This script requires the creation of approximately 40,000 files"
  echo "You currently have $filecount files out of a limit of $filelimit"
  echo "Please delete some files before proceeding" 
  echo "You can check how many files you have by looking at the 'files' column in the myquota command"
  exit 1
fi


echo "Testing if Anaconda is configured"
grep "/apps/languages/anaconda3/etc/profile.d/conda.sh" ~/.bashrc > /dev/null
if [ "$?" != "0" ] ; then
  echo "Anaconda is not currently setup, do you want configure it?"
  echo "This will add \". /apps/languages/anaconda3/etc/profile.d/conda.sh\" to your .bashrc file"
  echo "Y/N?"
  read r
  if [ "$r" = "Y" -o "$r" = "y" ] ; then
    echo ". /apps/languages/anaconda3/etc/profile.d/conda.sh" >> ~/.bashrc
    . /apps/languages/anaconda3/etc/profile.d/conda.sh
  else 
    echo "Installation cannot proceed without Conda"
    exit 1
  fi
else
  echo "Anaconda is already configured"
fi  
  
echo "Setting up Anaconda environment"
module purge
module load anaconda
conda env create -f tensorflow-gpu.yml 

echo "Downloading example code"
#download example code
wget https://raw.githubusercontent.com/aymericdamien/TensorFlow-Examples/master/examples/3_NeuralNetworks/multilayer_perceptron.py

echo "Patching example code for GPU usage"
#the patch file contains changes to make this example use the GPU
#setup path to data files correctly, for some reason python/tensor flow doesn't like using ~/neuralnet_data so we need /home/<userid>/neuralnet_data
sed -i "s/a.cos/$USER/" multilayer_perceptron.py.patch 
patch multilayer_perceptron.py multilayer_perceptron.py.patch

echo "Downloading example MNIST data to ~/neuralnet_data"
mkdir ~/neuralnet_data
cd ~/neuralnet_data
wget http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz
wget http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz
cd -
