#!/bin/bash
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
cd ~/UTN-FRA_SO_Examenes/202406/docker/
docker build -t kborozdnyj/web1-borozdnyj:latest .
docker push kborozdnyj/web1-borozdnyj:latest
./run.sh
