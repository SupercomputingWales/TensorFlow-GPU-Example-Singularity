#!/bin/bash --login
#$ -cwd
#SBATCH --job-name=tensorflow_gpu_demo
#SBATCH --out=tensorflow_gpu_demo.out.%J
#SBATCH --err=tensorflow_gpu_demo.err.%J
#SBATCH -p gpu
#SBATCH --mem-per-cpu=30G
#SBATCH -n 1
#SBATCH --gres=gpu:1

module load CUDA cuDNN anaconda
conda activate tensorflow-gpu
python multilayer_perceptron.py