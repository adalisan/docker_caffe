FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu14.04

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

ENV CONDA_DIR=/opt/conda
RUN conda create -n pytorch_1_cuda10_py36 'python=3.6'
RUN conda update -n base conda
RUN conda activate pytorch_1_cuda10_py36
RUN . $CONDA_DIR/etc/profile.d/conda.sh

RUN conda install -y pytorch torchvision cudatoolkit=10.0 -c pytorch && \
    conda install -y pandas scikit-learn matplotlib pytables tensorflow-gpu keras tqdm click logzero lockfile cython albumentations tabulate && \
    conda install -c conda-forge jupyter_contrib_nbextensions lightgbm && \
    conda install faiss-gpu cudatoolkit=10.0 -c pytorch # For CUDA10


RUN pip install -U \
        gensim \
        optuna \
        tensorboardX \
        scikit-image \
        lockfile \
        pytest \
        pyyaml \
        jupyter \
        jupyterthemes \
        kaggle \
        opencv-python \
        joblib \
        seaborn \
        pretrainedmodels \
        plotly \
        line-profiler \
        easydict \
        cloudpickle==0.5.6 # to suppress warning

# RUN conda update -n base conda
RUN conda clean --all

RUN jupyter contrib nbextension install --user
RUN jt -t grade3 -f firacode -nf firacode -altp -fs 100 -tfs 100 -nfs 100 -dfs 100 -ofs 100 -cellw 88% -T
RUN ipython profile create && echo "c = get_config(); c.IPCompleter.use_jedi = False" >> ~/.ipython/profile_default/ipython_config.py
#RUN conda deactivate
