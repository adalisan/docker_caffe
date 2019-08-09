FROM jupyter/datascience-notebook
LABEL maintainer="Sancar Adali <sadali@bbn.com>"

ENV DEBIAN_FRONTEND noninteractive
USER $NB_UID

# Install Python 3 packages
         
RUN conda config --add channels defaults && \
    conda config --add channels conda-forge && \
    conda config --add channels bioconda 
USER root
RUN apt-get update && apt-get install -y probcons ncbi-blast+ && rm -rf /var/lib/apt/lists/*
#fdist


ADD MSA.tar.gz /
#msaprobs
#RUN wget "http://sourceforge.net/projects/msaprobs/files/latest/download?source=files" -O MSA.tar.gz \
#         && tar zxf MSA.tar.gz
#WORKDIR /
#RUN tar zxf MSA.tar.gz
WORKDIR /MSAProbs-0.9.7/MSAProbs
RUN ls -alt && make \
       && cp msaprobs /usr/bin
WORKDIR /

#fastsimcoal
RUN wget http://cmpg.unibe.ch/software/fastsimcoal2/downloads/fsc26_linux64.zip -O  fsc26_linux64.zip \
         && unzip fsc26_linux64.zip \
         && chmod a+x fsc26_linux64/fsc26 \
         && cp fsc26_linux64/fsc26 /usr/bin/ \
         && rm -rf fsc_*

#DSSP
RUN wget ftp://ftp.cmbi.ru.nl/pub/software/dssp/dssp-2.0.4-linux-amd64 \
         && mv dssp-2.0.4-linux-amd64 /usr/bin/dssp \
         && chmod a+x /usr/bin/dssp


#XXmotif
WORKDIR /usr/local/bin
RUN wget "http://xxmotif.genzentrum.lmu.de/index.php?id=download&version=64" -O xx.tar.gz \
         && tar zxf xx.tar.gz \
         && rm xx.tar.gz

RUN apt-get install -y clustalw fasttree bwa emboss emboss-doc libclustalo-dev phylip mafft muscle samtools libbam-dev phyml paml bwa raxml && rm -rf /var/lib/apt/lists/*
USER $NB_UID
WORKDIR /home/$NB_USER
#ADD fix-permissions /home/$NB_USER/
#RUN chmod a+x fix-permissions
RUN conda install --yes qt pyqt && \
    conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


RUN conda install --quiet --yes  \
 # -c biobuilds -c mpi4py
 -c conda-forge \
#    'clustalw=*' \
#    'fasttree' \
    'reportlab' \
#    't-coffee' \
#    'bwa' \
    #'wisecondorx' \
         'blast' \
#         'emboss' \
#         'clustalo' \
#         'phylip' \
#         'mafft' \
#         'muscle' \
#         'samtools' \
#         'phyml' \
#         'raxml' \
#         'paml' \
    'biopython' \
    'genepop' && \
#    conda remove --quiet --yes --force qt pyqt && \
    conda clean -tipsy && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER



# RUN cd /tmp && \
#     wget http://probcons.stanford.edu/probcons_v1_12.tar.gz && \
#     tar -xvzf probcons_v1_12.tar.gz && \
#     cd probcons_v1_12/probcons && \
#     make CFLAGS=" -march=x86-64 -mtune=generic -O2 -pipe"  all && \
#     make install && \
#     cd && \
#     rm -rf /tmp/probcons_v1_12 && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER



#Manual software
#RUN echo "export DIALIGN2_DIR=/tmp" >> .bashrc

# #reportlab fonts
# RUN wget http://www.reportlab.com/ftp/fonts/pfbfer.zip
# WORKDIR cd $CONDA_DIR/dist-packages/reportlab
# RUN  mkdir fonts
# WORKDIR cd $CONDA_DIR/dist-packages/reportlab/fonts
# RUN unzip /pfbfer.zip \
#           && mkdir -p $CONDA_DIR/dist-packages/reportlab/fonts
# WORKDIR $CONDA_DIR//dist-packages/reportlab/fonts
# RUN unzip /pfbfer.zip
# WORKDIR /
# RUN rm pfbfer.zip

#USER $NB_UID

#RUN conda install --quiet --yes \
#    'biopython' \
#    'genepop' \
#     && \
#    conda remove --quiet --yes --force qt pyqt && \
#    conda clean -tipsy && \
#    npm cache clean --force && \
#    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
#    rm -rf /home/$NB_USER/.cache/yarn && \
#    rm -rf /home/$NB_USER/.node-gyp && \
#    fix-permissions $CONDA_DIR && \
#    fix-permissions /home/$NB_USER

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions /home/$NB_USER

# Install Tensorflow
RUN conda install --quiet --yes \
    'tensorflow=1.6*' \
    'keras=2.2*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

#set default python version to 3.5
RUN touch ~/.bash_aliases \
      && echo alias python=\'python3.6\' > ~/.bash_aliases

WORKDIR /home/$NB_USER
