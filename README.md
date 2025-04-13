Despliegue de Sitio Web Estático en Kubernetes con Minikube

Este proyecto consiste en el despliegue de un sitio web estático utilizando **Kubernetes** sobre **Minikube**, utilizando un `hostPath` para acceder al contenido local y servirlo desde un contenedor **Nginx**. Se emplea un `initContainer` para copiar los archivos desde el volumen al contenedor principal.
El contenido de la página web (HTML, CSS e imagenes) se encuentra fuera del repositorio, en una carpeta local montada en el entorno de Minikube.

Requisitos Previos:
Esto va a depender del hardware de cada uno, pero en caso de usar WSL, debe tener instalado en su maquina:
- Docker Engine: (https://docs.docker.com/engine/install/)
- Minikube: (https://minikube.sigs.k8s.io/docs/start/)
- Kubectl: (https://kubernetes.io/docs/tasks/tools/install-kubectl/

Pasos para Ejecutar el Proyecto

1. Clonar el Repositorio

bash
git clone https://github.com/TU_USUARIO/NOMBRE_REPO.git
cd NOMBRE_REPO/k8s-manifiestos

2. minikube start --driver=docker \
  --mount \
  --mount-string="/home/usuario/actividad-k8s/k8s-paginaweb:/mnt/data/k8s-paginaweb"

Autor
Astudillo, Mauro
Estudiante del ITU UNCuyo
Carrera: Desarrollo de Software
Materia: Computacion en la Nube
12 de abril de 2025
