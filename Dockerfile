# Utilizar la imagen base oficial de Kali Linux
FROM kalilinux/kali-rolling:latest
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."
LABEL warning="WARNING: needs to be saved as LF end of line file"

# Instalar paquetes necesarios
ARG KALI_METAPACKAGE=default
ARG KALI_DESKTOP=xfce
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install kali-linux-${KALI_METAPACKAGE} kali-desktop-${KALI_DESKTOP} dbus dbus-x11 novnc net-tools nano xfce4 xfce4-goodies x11vnc websockify supervisor && \
    apt-get clean && \
    apt-get autoremove -y

# Configurar entorno de VNC
ENV USER root
ENV VNCEXPOSE 1
ENV VNCPORT 5900
ENV VNCPWD 1234
ENV VNCDISPLAY 1280x720
ENV VNCDEPTH 16
ENV NOVNCPORT 8080
ENV TZ=America/Puerto Rico

# Crear usuario xar
RUN useradd -rm -d /home/xar -s /bin/zsh -g root -G sudo -u 1001 xar && \
    echo 'xar:1234' | chpasswd && \
    mkdir -p /home/xar/Desktop && \
    echo "To enable copy/paste run: autocutsel -fork" >> /home/xar/Desktop/README.txt

# Copiar scripts y archivos de configuración
COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN chmod +x /entrypoint.sh

# Exponer puertos
EXPOSE 5900 8080

# Comando de inicio
ENTRYPOINT ["/entrypoint.sh"]
