FROM ubuntu:xenial
MAINTAINER Tim Cera <tim@cerazone.net>

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN echo "deb     http://qgis.org/ubuntugis xenial main\n" >> /etc/apt/sources.list
RUN echo "deb     http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu xenial main\n" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 089EBE08314DF160
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key 073D307A618E5811

RUN    apt-get -y update
RUN    apt-get -y install qgis python-qgis qgis-plugin-grass grass grass-doc grass-gui
RUN    apt-get -y install python-requests python-numpy python-pandas python-scipy python-matplotlib

# Install some extra python libraries 
ADD python-mod.sh /python-mod.sh
RUN chmod 0755 /python-mod.sh
RUN /python-mod.sh

RUN    apt-get clean \
    && apt-get purge

# Called when the Docker image is started in the container
ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD /start.sh
