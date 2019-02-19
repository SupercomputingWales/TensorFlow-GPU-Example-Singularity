# TensorFlow-GPU-Example
An simple example of how to use Tensorflow with Anaconda, Python and GPU on Super Computing Wales.

Note that this example sets up an Anaconda environment which takes around 40,000 files. The default quota on Super Computing Wales is only 100,000 files, please delete or achive some files before running this if you have more than 60,000 files already.

## Setup

```
git clone https://github.com/SupercomputingWales/TensorFlow-GPU-Example
cd TensorFlow-GPU-Example
./tensorflow_setup.sh
```

## Running the example

`sbatch TensorFlow-GPU-Example.slurm`

This should result in tensorflow_gpu_demo.out.XXXXX and tensorflow_gpu_demo.err.XXXXX (where XXXXX is the job number) files being created. The output file should contain something like:

```Extracting /home/a.cos/neuralnet_data/train-images-idx3-ubyte.gz
Extracting /home/a.cos/neuralnet_data/train-labels-idx1-ubyte.gz
Extracting /home/a.cos/neuralnet_data/t10k-images-idx3-ubyte.gz
Extracting /home/a.cos/neuralnet_data/t10k-labels-idx1-ubyte.gz
Epoch: 0001 cost=316.534357009
Epoch: 0002 cost=99.598349252
Epoch: 0003 cost=72.017426792
Epoch: 0004 cost=57.256541054
Epoch: 0005 cost=48.566505551
Epoch: 0006 cost=42.126385042
Epoch: 0007 cost=38.068715960
Epoch: 0008 cost=33.654687686
Epoch: 0009 cost=30.905442436
Epoch: 0010 cost=28.964738740
Epoch: 0011 cost=27.089578144
Epoch: 0012 cost=25.210279087
Epoch: 0013 cost=24.343561058
Epoch: 0014 cost=22.425776573
Epoch: 0015 cost=21.565193366
Optimization Finished!
Accuracy: 0.8936
```

## Verifying the GPU was used
The error log should contain a line similar to:
```
Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 14873 MB memory) -> physical GPU (device: 0, name: Tesla V100-PCIE-16GB, pci bus id: 0000:3b:00.0, compute capability: 7.0)
```

You can also SSH to the node and run the nvidia-smi command. 
This can be done in one command with:
`ssh $(squeue -u $USER --format=%N | tail -1) nvidia-smi`
 
This should show something like:
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 396.37                 Driver Version: 396.37                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  Tesla V100-PCIE...  On   | 00000000:3B:00.0 Off |                    0 |
| N/A   36C    P0    45W / 250W |  15431MiB / 16160MiB |     30%      Default |
+-------------------------------+----------------------+----------------------+
|   1  Tesla V100-PCIE...  On   | 00000000:D8:00.0 Off |                    0 |
| N/A   37C    P0    27W / 250W |      0MiB / 16160MiB |      0%      Default |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                       GPU Memory |
|  GPU       PID   Type   Process name                             Usage      |
|=============================================================================|
|    0    431923      C   python                                     15420MiB |
+-----------------------------------------------------------------------------+
```` 


## Potential Problems 

### SCW_TPN_OVERRIDE error
Hawk will not let you submit a single core job to the GPU partition without first running the commmand:
`export SCW_TPN_OVERRIDE=1`

This shouldn't be required on Sunbird.


