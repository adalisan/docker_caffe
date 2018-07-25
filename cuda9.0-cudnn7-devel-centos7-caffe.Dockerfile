FROM nvidia/cuda:9.0-cudnn7-devel-centos7

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

ENV CONDA_DIR /opt/conda
RUN  mkdir -p $CONDA_DIR
RUN  yum   check-update  ||  yum groups mark install "Development Tools" && \
  yum groups mark convert   "Development Tools" && \
  yum  -y  groupinstall "Development Tools" && \
  yum -y install \
      bc \
      cmake \
      curl  \
      yum-utils  && yum clean all
RUN yum --quiet -y install libpng-devel  freetype-devel curl git unzip vim nano wget && yum clean all
RUN wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rpm -ivh epel-release-latest-7.noarch.rpm
RUN yum   --quiet  -y install \
    bc \
    curl \
    g++ \
    gfortran \
    git  \
    pkg-config \
    software-properties-common && yum clean all
RUN   yum  --quiet  -y install \
    qt5-qtbase \
    zlib1g-dev \
    openjpeg-devel \
    libjpeg-turbo-devel \
    libpng-devel \
    libtiff-devel \
    jasper-devel \
    OpenEXR-devel \
    libdc1394-22-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtheora-devel \
    libvorbis-devel \
    libxvidcore-dev \
    libx264-dev \
    yasm \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libv4l-devel \
    libxine2-dev \
    tbb-devel \
    eigen3-devel \
    doxygen \
    ffmpeg \
    ffmpeg-devel && yum clean all
RUN  yum  -y install protobuf-devel leveldb-devel openblas-devel \
      snappy-devel opencv-devel boost-devel hdf5-devel gflags-devel \
      glog-devel lmdb-devel libpng-devel  freetype-devel && yum clean all
RUN yum --quiet -y install  python-devel python-pip && yum clean all &&  \
    pip install --quiet --upgrade pip  && \
    pip install --quiet  nltk scikit-learn "pandas<0.22" && \
    pip install --quiet  opencv-python 

ENV PATH ${CONDA_DIR}/bin:${PATH}
