#!/bin/bash

###################
# WARNING: needs to be saved as LF end of line file
###################

# Configurar contraseña para VNC
mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Configurar contraseña para VNC como usuario xar
su xar -c "mkdir -p /home/xar/.vnc/ && \
  echo $VNCPWD | vncpasswd -f > /home/xar/.vnc/passwd && \
  chmod 600 /home/xar/.vnc/passwd"

# Iniciar servidor VNC como usuario xar
su xar -c "vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH > /dev/null 2>&1 &"

# Iniciar servidor noVNC como usuario xar
su xar -c "/usr/share/novnc/utils/launch.sh --listen $NOVNCPORT --vnc localhost:$VNCPORT > /dev/null 2>&1 &"

# Crear script xstartup
cat << 'EOF' > /home/xar/.vnc/xstartup
#!/bin/sh
autocutsel -fork
xrdb "$HOME/.Xresources"
xsetroot -solid grey
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
# Fix to make GNOME work
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession
EOF

chmod +x /home/xar/.vnc/xstartup

echo "Launch your web browser and open http://localhost:$NOVNCPORT/vnc.html"

# Iniciar shell
/bin/zsh && su - xar
