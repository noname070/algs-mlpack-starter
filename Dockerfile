FROM debian:bullseye-slim

# ставим базу
RUN sed -i 's|http://deb.debian.org/debian|http://ftp.ru.debian.org/debian|g' /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y --fix-missing --no-install-recommends \
    build-essential \
    libcunit1 libcunit1-doc libcunit1-dev \
    gdb git wget curl cmake \
    openssh-server  \
    libboost-all-dev \
    libblas-dev \
    libstb-dev libcereal-dev \
    libxml2-dev
    
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
RUN git clone https://gitlab.com/conradsnicta/armadillo-code.git \
    && cd armadillo-code \
    && mkdir build && cd build \
    && cmake .. \
    && make -j2 \
    && make install \
    && ldconfig \
    && cd ../..

# какая то хеддер фигня от млпака
RUN git clone https://github.com/mlpack/ensmallen.git \
    && cd ensmallen \
    && mkdir build && cd build \
    && cmake .. \
    && make -j2 \
    && make install \
    && ldconfig \
    && cd ../..

# сам млпак
RUN git clone https://github.com/mlpack/mlpack.git \
    && cd mlpack \
    && mkdir build && cd build \
    && cmake .. \
    && make -j2 \
    && make install \
    && ldconfig \
    && cd ../..

# полетели
EXPOSE 22 8199
CMD ["/usr/sbin/sshd", "-D"]
