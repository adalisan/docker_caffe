FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         unzip \
         curl \
         wget \
         vim \
         tmux \
         htop \
         less \
         locate \
         ca-certificates \
         libsm6 \
         libxext6 \
         libxrender1 &&\
         rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.5.4-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh

ENV PATH=/opt/conda/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8

RUN . /opt/conda/etc/profile.d/conda.sh

RUN pip install -U \
        tqdm \
        click \
        logzero \
        gensim \
        optuna \
        tensorboardX \
        scikit-image \
        lockfile \
        pytest \
        Cython \
        pyyaml \
        jupyter \
        jupyterthemes \
        kaggle \
        opencv-python \
        joblib \
        seaborn \
        pretrainedmodels \
        plotly \
        albumentations \
        line-profiler \
        tabulate \
        easydict \
        cloudpickle==0.5.6 # to suppress warning


RUN conda install -y -q -c pytorch pytorch torchvision cudatoolkit=10.0
RUN conda install -y -q -c conda-forge pandas scikit-learn matplotlib pytables tensorflow-gpu keras faiss-gpu
RUN conda clean --all
