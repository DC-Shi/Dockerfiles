FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04

# Use TUNA mirror to speed up.
#RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//https:\/\/mirrors.tuna.tsinghua.edu.cn\/ubuntu\//' /etc/apt/sources.list

### Install steam
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y libglvnd0 mesa-utils \
    libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libc6:i386 \
    sudo steam
# Error1
# glXChooseVisual failedMain.cpp (332) : Assertion Failed: Fatal Error: glXChooseVisual failed
# Main.cpp (332) : Assertion Failed: Fatal Error: glXChooseVisual failed
# Solved by adding 'compat32' capabilities
# Error2
# may report cannot find steamui.so, but using deb install would have such file.


# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-ubuntu-docker-container
# Install locale
RUN echo 'en_US.UTF-8 UTF-8' >>/etc/locale.gen && \
    echo 'zh_CN.UTF-8 UTF-8' >>/etc/locale.gen && \
    apt-get update && apt-get install -y locales ttf-wqy-microhei ttf-wqy-zenhei xfonts-wqy
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
# Add steam executable to PATH
ENV PATH="${PATH}:/usr/games"

# Audio fix
# https://github.com/webanck/docker-wine-steam/issues/12
RUN DEBIAN_FRONTEND="noninteractive" apt-get update && apt-get install -y pulseaudio
RUN sed -i "s/; enable-shm = yes/enable-shm = no/g" /etc/pulse/client.conf

# Add other packages for easier using
RUN apt-get update && apt-get install -y wget vim \
    && rm -rf /var/lib/apt/lists/*

# Change to normal user
#RUN useradd -ms /bin/bash user
ENV DISPLAY :0

# Add user
ARG userID
RUN groupadd -g $userID steam && useradd -u $userID -g $userID -m steam && echo "steam:steam" | chpasswd && usermod -a -G sudo,audio steam
USER steam

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,compute,video,display,compat32
