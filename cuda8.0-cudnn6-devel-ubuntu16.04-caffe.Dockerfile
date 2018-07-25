FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

MAINTAINER Sancar Adali <sad.ali.remove_this_string@googles_email_sth_sth.com>

ARG PYTHON_MAJOR_VERSION=2
ARG PYTHON_MINOR_VERSION=7
ARG TENSORFLOW_VERSION=1.3.0
ARG TENSORFLOW_ARCH=gpu
ARG KERAS_VERSION=2.0.8
ARG LASAGNE_VERSION=v0.1
ARG TORCH_VERSION=latest
ARG CAFFE_VERSION=master
ARG R=r-cran-recommended
ARG NUMPY_VERSION=
ARG NETWORKX_VERSION=



#RUN echo -e "\n**********************\nNVIDIA Driver Version\n**********************\n" && \
#	cat /proc/driver/nvidia/version && \
#	echo -e "\n**********************\nCUDA Version\n**********************\n" && \
#	nvcc -V && \
#	echo -e "\n\nBuilding your Deep Learning Docker Image...\n"

# Install some dependencies
RUN apt-get update && apt-get install -y \
        bc \
        bzip2 \
        build-essential \
        cmake \
        curl \
        g++ \
        gfortran \
        git \
        libffi-dev \
        libfreetype6-dev \
        libhdf5-dev \
        libjpeg-dev \
        liblcms2-dev \
        libopenblas-dev \
        liblapack-dev \
        libjpeg8 \
        libpng12-dev \
        libssl-dev \
        libtiff-dev \
        libwebp-dev \
        libzmq3-dev \
        nano \
        pkg-config \
        python-dev \
        software-properties-common \
        unzip \
        vim \
        wget \
        zlib1g-dev \
        qt5-default \
        libvtk6-dev \
        zlib1g-dev \
        libjpeg8-dev \
        libwebp-dev \
        libpng-dev \		
        libjasper-dev \
        libopenexr-dev \
        libgdal-dev \
        libdc1394-22-dev \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        libtheora-dev \
        libvorbis-dev \
        libxvidcore-dev \
        libx264-dev \
        yasm \
        libopencore-amrnb-dev \
        libopencore-amrwb-dev \
        libv4l-dev \
        libxine2-dev \
        libtbb-dev \
        libeigen3-dev \
        ant \
        default-jdk \
        doxygen \
        ca-certificates \
        && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
# Link BLAS library to use OpenBLAS using the alternatives mechanism (https://www.scipy.org/scipylib/building/linux.html#debian-ubuntu)
    update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3


RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.3.31-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy

ENV CONDA_DIR /opt/conda
ENV PATH ${CONDA_DIR}/bin:${PATH}

RUN apt-get update && apt-get install -y \
        graphviz && \
         apt-get clean && \
            apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*              
# Install other useful Python packages using pip
RUN conda install ipython=5.5 && \
    conda install \
        Cython \
        ipykernel \
        jupyter \
        path.py \
        Pillow \
        pygments \
        six \
        sphinx \
        wheel \
    #zmq \
        networkx \ 
     #   igraph \
        && \
    python -m ipykernel.kernelspec


ENV PYTHONPATH /src:${PYTHONPATH}
ENV LD_LIBRARY_PATH /usr/lib64/nvidia:${LD_LIBRARY_PATH}
ENV CAFFE_ROOT /opt/visdetect/caffe
ENV PYCAFFE_ROOT /opt/visdetect/caffe/python
ENV PYTHONPATH /opt/visdetect/caffe/python:${PYTHONPATH}
ENV PATH /opt/visdetect/caffe/build/tools:/opt/visdetect/caffe/python:${PATH}
ENV VISUAL_DETECTOR_DIR /opt/visdetect
RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
    apt-get update && \
    apt-get install -y wget git libhdf5-dev g++ graphviz   && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.2.12-Linux-x86_64.sh && \
    /bin/bash /Miniconda2-4.2.12-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda2-4.2.12-Linux-x86_64.sh

RUN  conda install -q -y python=2.7 && \
    pip install --quiet --upgrade pip  && \
    #conda install -q -y fasteners && \
    #conda install -q -y tqdm && \
    #pip install tensorflow && \
    #pip install --quiet tensorflow-gpu && \
    #conda install -q Pillow scikit-learn  scikit-image notebook pandas matplotlib && \
    #conda install -q  mkl nose pyyaml six h5py && \
    #conda install -q theano pygpu && \
    #conda install theano && \
    #pip install --quiet ipython==5.5 && \
    #git clone git://github.com/fchollet/keras.git /src && pip install -e /src[tests] && \
    #pip install --quiet git+git://github.com/fchollet/keras.git && \
    conda install -q -y nltk  && \
    pip install --quiet opencv-python 


# Install dependencies for Caffe
RUN apt-get update && apt-get install -y \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libprotobuf-dev \
        libsnappy-dev \
        protobuf-compiler \
        cmake && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

