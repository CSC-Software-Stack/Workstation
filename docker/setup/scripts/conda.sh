#!/bin/bash


# Miniforge (includes mamba by default)
echo Changing permissions on miniforge. This can take a while.
sudo chown -R abc /miniforge
/miniforge/bin/conda config --set ssl_verify True 
/miniforge/bin/conda update -y conda
/miniforge/bin/conda init
source ~/.bashrc
gpu=$(which nvidia-smi)
if [[ $gpu == '/usr/bin/nvidia-smi' ]]; then
  echo Nvidia GPU found. Installing GPU standard env.
  mamba env create -f /setup/conda/standard_gpu_env.yaml --prefix ~/.conda/envs/developer
else
  echo No Nvidia GPU found. Installing standard env.
  mamba env create -f /setup/conda/standard_env.yaml --prefix ~/.conda/envs/developer
fi

conda activate developer

if grep -Fxq "conda activate developer" ~/.bashrc
then
    echo "conda activate developer not added to ~/.bashrc as already exists"
else 
    echo "conda activate developer" >> ~/.bashrc
fi
