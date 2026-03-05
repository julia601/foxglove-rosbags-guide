FROM ros:humble

ARG DEBIAN_FRONTEND=noninteractive
ARG UNAME
ARG UID
ARG GID

# root: install users & packages
RUN groupadd -g ${GID} ${UNAME} && \
    useradd -m -u ${UID} -g ${GID} -s /bin/bash ${UNAME} && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y \
        nano \
        ros-humble-desktop-full \
        ros-humble-rosbag2-storage-mcap \
        python3-pip \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        libgtk-3-0 \
        ros-humble-foxglove-bridge \
        libx11-6 libx11-xcb1 libxcb1 libxkbcommon0 libgl1 libegl1 && \
    pip3 install --no-cache-dir opencv-python rosbags

# create workspace "ros2_ws"
RUN mkdir -p /home/${UNAME}/ros2_ws/src && \
    chown -R ${UID}:${GID} /home/${UNAME}/ros2_ws

# prepare shell configuration for new user
RUN echo "source /opt/ros/humble/setup.bash" >> /home/${UNAME}/.bashrc && \
    echo "export ROS_DOMAIN_ID=0" >> /home/${UNAME}/.bashrc && \
    echo "export RMW_IMPLEMENTATION=rmw_fastrtps_cpp" >> /home/${UNAME}/.bashrc && \
    chown ${UID}:${GID} /home/${UNAME}/.bashrc

# set working directory
WORKDIR /home/${UNAME}/ros2_ws

# change user
USER ${UNAME}

# open bash shell when starting container
CMD ["/bin/bash"]
