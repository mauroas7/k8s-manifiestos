        DESPLIEGUE DE SITIO WEB ESTÁTICO EN KUBERNETES CON MINIKUBE

Este proyecto consiste en el despliegue de un sitio web estático utilizando Kubernetes sobre Minikube, utilizando un `hostPath` para acceder al contenido local y servirlo desde un contenedor Nginx.
El contenido de la página web (HTML, CSS e imagenes) se encuentra fuera del repositorio, en una carpeta local montada en el entorno de Minikube.

Requisitos previos:
Esto va a depender del hardware de cada uno. Este instructivo está diseñado para entornos Linux, por lo tanto se recomienda utilizar WSL.
Para continuar debe tener instalado en su maquina:
- Docker Engine: (https://docs.docker.com/engine/install/)
- Minikube: (https://minikube.sigs.k8s.io/docs/start/)
- Kubectl: (https://kubernetes.io/docs/tasks/tools/install-kubectl/

Pasos para ejecutar el proyecto

🚀 1. Preparar entorno de trabajo.

- Se creó una carpeta principal: `actividad-k8s`
- Se organizaron dos subdirectorios:
  - `k8s-paginaweb`: va a contener los archivos del sitio (index.html, style.css, assets)
  - `k8s-manifiestos`: va a contener los manifiestos YAML divididos en carpetas (pvc, deployment, service)

🚀 2. Iniciar minikube con volumen montado.

Para que el contenido del sitio web esté disponible dentro del contenedor Nginx, es necesario que Minikube acceda a la carpeta local donde están los archivos (index.html, style.css, etc.).
Esto se logra utilizando el parámetro --mount al iniciar Minikube.

¿Qué dirección debo usar en --mount-string?

El formato es:
       
        --mount-string="RUTA_LOCAL_ABSOLUTA:RUTA_DENTRO_MINIKUBE"

Por ejemplo, si tus archivos están en:
       
        /home/nombre/actividad-k8s/k8s-paginaweb

y tu hostPath dentro del PersistentVolume apunta a:
       
        hostPath:
          path: "/mnt/data/k8s-paginaweb"

Entonces el comando completo será:

        minikube start --driver=docker --mount-string="/home/nombre/actividad-k8s/k8s-paginaweb:/mnt/data/k8s-paginaweb"

🚀 3. Crear los manifiestos.
   Esta es la parte mas tediosa, pero se deben crear los archivos .yaml necesarios para el desarrollo del proyecto. Algunos de estos van a ser:

        deployment/web-deployment.yaml
        pvc/static-content-pv.yaml
        pvc/static-content-pvc.yaml
        service/web-service.yaml
Estructura final del proyecto deberia ser similar a esto:

              actividad-k8s/
              ├── k8s-paginaweb/          # Archivos estáticos
              └── k8s-manifiestos/
                  ├── pvc/
                  ├── deployment/
                  └── service/

🚀 4. Aplicación de manifiestos.
   En la terminal se deben colocar los siguientes comandos:

            kubectl apply -f pvc/static-content-pv.yaml
            kubectl apply -f pvc/static-content-pvc.yaml
            kubectl apply -f deployment/web-deployment.yaml
            kubectl apply -f service/web-service.yaml

🚀 5. Verificación de contenido dentro del contenedor

            kubectl exec -it POD_NAME -- /bin/bash
            cd /usr/share/nginx/html
            ls -l
Si se observan los archivos index.html, style.css, assets, quiere decir que está todo correcto.

🚀 6. Visualización del sitio.
   En la terminal se debe colocar el siguiente comando:

            minikube service static-web-service

Aca va a depender del entorno que hayas utilizado para trabajar. En algunos casos se va a abrir automaticameante una ventana en el navegador-web, o en otro caso se debe colocar la ip del puerto que es mostrado en la terminal.
Por ejemplo: http://127.0.0.1:PORT

Si la pagina se muestra sin problemas, el sitio se creó correctamente. 🎉

Autor:
Astudillo Mauro
ITU UNCuyo, Desarrollo de Software
Computacion en la Nube
12 de abril de 2025
