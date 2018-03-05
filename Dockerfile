FROM ubuntu:xenial
MAINTAINER Tim Cera <tim@cerazone.net>

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
# ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng
#
ENV DEBIAN_FRONTEND noninteractive
RUN sed -i "s/archive.ubuntu./mirrors.aliyun./g" /etc/apt/sources.list 
RUN echo "deb http://qgis.org/debian xenial main\n" >> /etc/apt/sources.list
# RUN echo "deb     http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main\n" >> /etc/apt/sources.list
# RUN  apt-get update && apt-get install -qqy software-properties-common --no-install-recommends && \
 # apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable && \
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4 &&\
 apt-key adv --keyserver keyserver.ubuntu.com --recv-key 089EBE08314DF160 && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-key CAEB3DC3BDF7FB45 && \
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 314DF160
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 073D307A618E5811

RUN apt-get -y update && \
    apt-get -y install qgis python-qgis qgis-plugin-grass grass grass-doc grass-gui \ 
    locales xfonts-utils fontconfig && apt-get clean

# Install some extra python libraries 
ADD python-mod.sh /python-mod.sh
RUN chmod 0755 /python-mod.sh
RUN /python-mod.sh

# install chinese fonts  
ADD win_fonts /tmp/win_fonts
WORKDIR /tmp/win_fonts
RUN cp *.ttc /usr/share/fonts && cp *.ttf /usr/share/fonts && \
         mkfontscale && mkfontdir && fc-cache

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8


# Called when the Docker image is started in the container
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
