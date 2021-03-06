FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04
MAINTAINER Rob Ludwick

RUN  apt-get update \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common \
  && apt-get install -y x11vnc \
  && apt-get install -y ratpoison

# Install Java 8
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS
RUN wget http://cdn.quantconnect.com/interactive/ibgateway-latest-standalone-linux-x64-v968.2d.sh
RUN chmod a+x ibgateway-latest-standalone-linux-x64-v968.2d.sh

# Setup  IBController
RUN mkdir -p /opt/IBController/
WORKDIR /opt/IBController/
RUN wget -q https://github.com/ib-controller/ib-controller/releases/download/3.4.0/IBController-3.4.0.zip
RUN unzip ./IBController-3.4.0.zip
RUN chmod -R u+x *.sh && chmod -R u+x Scripts/*.sh


WORKDIR /

# Install TWS
RUN yes n | /opt/TWS/ibgateway-latest-standalone-linux-x64-v968.2d.sh

# Remove temp files
RUN rm -rf /opt/TWS/*.sh
RUN rm -f /opt/IBController/*.zip

# Launch a virtual screen
RUN Xvfb :0 -screen 0 1024x768x24 2>&1 >/dev/null &
RUN export DISPLAY=:0


# XNVC
COPY vnc_init /etc/init.d/x11vnc
RUN chmod u+x /etc/init.d/x11vnc

# Install Ratpoison 
RUN apt-get install -y ratpoison

ADD runscript.sh runscript.sh
CMD bash runscript.sh
