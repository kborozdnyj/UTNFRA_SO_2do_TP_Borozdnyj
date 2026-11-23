**lsblk
sudo useradd -m -s /bin/bash -G sudo kiara
sudo passwd kiara
history -a
sudo -v
sudo fdisk /dev/sdc << EOF
n
p
1


t
8e
w
EOF

sudo fdisk /dev/sdd << EOF
n
p
1


t
8e
w
EOF

sudo wipefs -a /dev/sdc1 /dev/sdd1
sudo pvcreate /dev/sdc1 /dev/sdd1
sudo vgcreate vg_datos /dev/sdc1
sudo vgcreate vg_temp /dev/sdd1
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo mkdir -p /var/lib/docker /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work
sudo swapon /dev/mapper/vg_temp-lv_swap
echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_temp-lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab
sudo systemctl restart docker
sudo usermod -a -G docker kiara
cat << 'EOF' > ~/RTA_Examen_20261123/Punto_A.sh
#!/bin/bash
sudo wipefs -a /dev/sdc1 /dev/sdd1
sudo pvcreate /dev/sdc1 /dev/sdd1
sudo vgcreate vg_datos /dev/sdc1
sudo vgcreate vg_temp /dev/sdd1
sudo lvcreate -L 5M vg_datos -n lv_docker
sudo lvcreate -L 1.5G vg_datos -n lv_workareas
sudo lvcreate -L 512M vg_temp -n lv_swap
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_docker
sudo mkfs.ext4 /dev/mapper/vg_datos-lv_workareas
sudo mkswap /dev/mapper/vg_temp-lv_swap
sudo mkdir -p /var/lib/docker /work
sudo mount /dev/mapper/vg_datos-lv_docker /var/lib/docker
sudo mount /dev/mapper/vg_datos-lv_workareas /work
sudo swapon /dev/mapper/vg_temp-lv_swap
echo "/dev/mapper/vg_datos-lv_docker /var/lib/docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_datos-lv_workareas /work ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "/dev/mapper/vg_temp-lv_swap none swap sw 0 0" | sudo tee -a /etc/fstab
sudo systemctl restart docker
EOF

chmod +x ~/RTA_Examen_20261123/Punto_A.sh
sudo tee /usr/local/bin/BorozdnyjAltaUser-Groups.sh << 'EOF'
#!/bin/bash

USUARIO_CLAVE=$1
LISTA=$2

CLAVE=$(sudo grep "^$USUARIO_CLAVE:" /etc/shadow | awk -F ':' '{print $2}')

ANT_IFS=$IFS
IFS=$'\n'

for LINEA in $(cat "$LISTA" | grep -v ^#)
do
    USUARIO=$(echo "$LINEA" | awk -F ',' '{print $1}')
    GRUPO=$(echo "$LINEA" | awk -F ',' '{print $2}')
    DIRECTORIO=$(echo "$LINEA" | awk -F ',' '{print $3}')

    sudo groupadd -f "$GRUPO"
    sudo useradd -m -s /bin/bash -g "$GRUPO" -d "$DIRECTORIO" -p "$CLAVE" "$USUARIO"
done

IFS=$ANT_IFS
EOF

sudo chmod +x /usr/local/bin/BorozdnyjAltaUser-Groups.sh
cp /usr/local/bin/BorozdnyjAltaUser-Groups.sh ~/RTA_Examen_20261123/
/usr/local/bin/BorozdnyjAltaUser-Groups.sh kiara ~/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt
cat << 'EOF' > ~/RTA_Examen_20261123/Punto_B.sh
#!/bin/bash
/usr/local/bin/BorozdnyjAltaUser-Groups.sh kiara ~/UTN-FRA_SO_Examenes/202406/bash_script/Lista_Usuarios.txt
EOF

chmod +x ~/RTA_Examen_20261123/Punto_B.sh
sudo lvs && ls -la /work
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
cd ~/UTN-FRA_SO_Examenes/202406/docker/
cat << 'EOF' > index.html
<div>
<h1> Sistemas Operativos - UTNFRA </h1></br>
<h2> 2do Parcial - Junio 2024 </h2> </br>
<h3> Kiara Borozdnyj</h3>
<h3> División: 111</h3>
</div>
EOF

cat << 'EOF' > dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
EOF

docker login -u kborozdnyj
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
cd ~/UTN-FRA_SO_Examenes/202406/docker/
cat << 'EOF' > index.html
<div>
<h1> Sistemas Operativos - UTNFRA </h1></br>
<h2> 2do Parcial - Junio 2024 </h2> </br>
<h3> Kiara Borozdnyj</h3>
<h3> División: 111</h3>
</div>
EOF

cat << 'EOF' > dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
EOF

docker login -u kborozdnyj
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
cd ~/UTN-FRA_SO_Examenes/202406/docker/
cat << 'EOF' > index.html
<div>
<h1> Sistemas Operativos - UTNFRA </h1></br>
<h2> 2do Parcial - Junio 2024 </h2> </br>
<h3> Kiara Borozdnyj</h3>
<h3> División: 111</h3>
</div>
EOF

cat << 'EOF' > dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
EOF

docker login -u kborozdnyj
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
cd ~/UTN-FRA_SO_Examenes/202406/docker/
cat << 'EOF' > index.html
<div>
<h1> Sistemas Operativos - UTNFRA </h1></br>
<h2> 2do Parcial - Junio 2024 </h2> </br>
<h3> Kiara Borozdnyj</h3>
<h3> División: 111</h3>
</div>
EOF

cat << 'EOF' > dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
EOF

docker login -u kborozdnyj
docker build -t kborozdnyj/web1-borozdnyj:latest .
docker push kborozdnyj/web1-borozdnyj:latest
cat << 'EOF' > run.sh
#!/bin/bash
docker run -d --restart always -p 8080:80 kborozdnyj/web1-borozdnyj:latest
EOF

chmod +x run.sh
./run.sh
cat << 'EOF' > ~/RTA_Examen_20261123/Punto_C.sh
#!/bin/bash
sudo lvextend -l +100%FREE /dev/mapper/vg_datos-lv_docker
sudo resize2fs /dev/mapper/vg_datos-lv_docker
cd ~/UTN-FRA_SO_Examenes/202406/docker/
docker build -t kborozdnyj/web1-borozdnyj:latest .
docker push kborozdnyj/web1-borozdnyj:latest
./run.sh
EOF

chmod +x ~/RTA_Examen_20261123/Punto_C.sh
curl localhost:8080
cd ~/UTN-FRA_SO_Examenes/202406/ansible/
mkdir -p roles/2do_parcial/templates roles/2do_parcial/vars
cat << 'EOF' > roles/2do_parcial/vars/main.yml
---
nombre: Kiara
apellido: Borozdnyj
division: 111
EOF

cat << 'EOF' > roles/2do_parcial/templates/datos_alumno.j2
Nombre: {{ nombre }} Apellido: {{ apellido }}
Division: {{ division }}
EOF

cat << 'EOF' > roles/2do_parcial/templates/datos_equipo.j2
IP: {{ ansible_default_ipv4.address }}
Distribución: {{ ansible_facts.distribution }}
Cantidad de Cores: {{ ansible_processor_vcpus }}
EOF

cat << 'EOF' > roles/2do_parcial/tasks/main.yml
---
- name: "Crear directorios alumno y equipo"
  ansible.builtin.file:
    path: "{{ item }}"
    state: directory
  loop:
    - /tmp/2do_parcial/alumno
    - /tmp/2do_parcial/equipo

- name: "Generar datos_alumno.txt desde template"
  template:
    src: datos_alumno.j2
    dest: /tmp/2do_parcial/alumno/datos_alumno.txt

- name: "Generar datos_equipo.txt desde template"
  template:
    src: datos_equipo.j2
    dest: /tmp/2do_parcial/equipo/datos_equipo.txt

- name: "Configurar sudoers sin password para grupo 2PSupervisores"
  become: yes
  ansible.builtin.copy:
    dest: /etc/sudoers.d/2PSupervisores
    content: "%2PSupervisores ALL=(ALL) NOPASSWD:ALL\n"
    mode: '0440'
    validate: 'visudo -cf %s'
EOF

ansible-playbook -i inventory/hosts playbook.yml -l localhost -K
cat << 'EOF' > ~/RTA_Examen_20261123/Punto_D.sh
#!/bin/bash
cd ~/UTN-FRA_SO_Examenes/202406/ansible/
ansible-playbook -i inventory/hosts playbook.yml -l localhost -K
EOF

chmod +x ~/RTA_Examen_20261123/Punto_D.sh
cat /tmp/2do_parcial/alumno/datos_alumno.txt
cat /tmp/2do_parcial/equipo/datos_equipo.txt
sudo cat /etc/sudoers.d/2PSupervisores
cd ~
git clone https://github.com/kborozdnyj/UTNFRA_SO_2do_TP_Borozdnyj.git
cd UTNFRA_SO_2do_TP_Borozdnyj
cp -r ~/UTN-FRA_SO_Examenes/202406 .
cp -r ~/RTA_Examen_20261123 .
history -a
