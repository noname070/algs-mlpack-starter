FROM debian:bullseye-slim

# ставим базу
RUN sed -i 's|http://deb.debian.org/debian|http://ftp.ru.debian.org/debian|g' /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --fix-missing --no-install-recommends \
    build-essential \
    gdb git wget curl cmake \
    openssh-server  \
    libboost-all-dev \
    libblas-dev \
    libstb-dev libcereal-dev \
    libxml2-dev \
    ca-certificates
    
# вижак
RUN curl -L -o vscode.deb https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64 \
    && dpkg -i vscode.deb || apt-get install -y -f

# красоту
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# ssh
RUN mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

WORKDIR /algs

# тепепрь все-все-все для млпака - arma, ensmallen и mlpack. все скачать и сбилдить из исходников

# что бы гит не выеживался
RUN git config --global http.sslverify false 

# арма
# RUN git clone https://gitlab.com/conradsnicta/armadillo-code.git \
    # && cd armadillo-code \
    # && mkdir build && cd build \
    # && cmake .. \
    # && make -j4 \
    # && make install \
    # && ldconfig \
    # && cd ../..

RUN wget http://sourceforge.net/projects/arma/files/armadillo-12.6.3.tar.xz \
    && tar -xvf armadillo-12.6.3.tar.xz \
    && cd armadillo-12.6.3 \
    && mkdir build && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH \
    && cmake -DARMADILLO_INCLUDE_DIR=/usr/local/include \
             -DARMADILLO_LIBRARY=/usr/local/lib/libarmadillo.so .. \
    && ldconfig \
    && cd /algs \ 
    && rm armadillo-12.6.3.tar.xz

# какая то хеддер фигня от млпака
RUN git clone https://github.com/mlpack/ensmallen.git \
    && cd ensmallen \
    && mkdir build && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && ldconfig \
    && cd /algs

# сам млпак
RUN git clone https://github.com/mlpack/mlpack.git \
    && cd mlpack \
    && mkdir build && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && ldconfig \
    && cd /algs

# полетели
EXPOSE 22 8199
CMD ["/usr/sbin/sshd", "-D"]
