#!/bin/bash

# Script de despliegue automático
# Despliegue de un sitio estático en Kubernetes sobre Minikube (Linux)
# Autor: Astudillo, Mauro. Computación en la Nube - ITU UNCuyo

# Validar ruta de ejecución
EXPECTED_DIR_NAME="actividad-script"
CURRENT_DIR_NAME=$(basename "$PWD")

if [ "$CURRENT_DIR_NAME" != "$EXPECTED_DIR_NAME" ]; then
  echo "Este script debe ejecutarse desde la carpeta '$EXPECTED_DIR_NAME'."
  echo "Estás en: $PWD"
  exit 1
fi

echo "Ejecutando desde la carpeta correcta: $PWD"

# Variables
ROOT_DIR="$PWD/actividad-k8s"
WEB_DIR="$ROOT_DIR/k8s-paginaweb"
MANIFESTS_DIR="$ROOT_DIR/k8s-manifiestos"
MOUNT_PATH="/mnt/data/k8s-paginaweb"

# Crear estructura de carpetas
mkdir -p "$WEB_DIR/assets"
mkdir -p "$MANIFESTS_DIR/pvc" "$MANIFESTS_DIR/deployment" "$MANIFESTS_DIR/service"

echo "Carpetas creadas en: $ROOT_DIR"

# Crear archivos HTML y CSS
cat <<'EOF' > "$WEB_DIR/index.html"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>ACTIVIDAD KUBERNETES</title>
    <link href="style.css" rel="stylesheet" type="text/css">
</head>
<body>
    <header>
        <div class="row">
            <div class="logo">
                <img src="assets/itu-logo.jpg" alt="oe_logo">
            </div>
            <ul class="main-nav">
                <li class="active"><a href="#inicio">INICIO</a></li>
                <li><a href="#que-es">¿QUÉ ES KUBERNETES?</a></li>
                <li><a href="#servicios">SERVICIOS</a></li>
                <li><a href="#arquitectura">ARQUITECTURA</a></li>
                <li><a href="#ejemplos">EJEMPLOS</a></li>                
            </ul>
        </div>
        <div class="hero" id="inicio">
            <h1>KUBERNETES</h1>
            <div class="button">
                <a href="https://www.youtube.com/results?search_query=kubernetes" target="_blank" class="btn btn-one">Ver Video</a>
                <a href="#que-es" class="btn btn-two">Explorar más</a>
            </div>
        </div>
    </header>

    <section class="kubernetes grid-container" id="que-es">
        <div>
            <img src="assets/k8s-queson.png" alt="¿Qué es Kubernetes?">
        </div>
    </section>

    <section class="service grid-container" id="servicios">
        <div>
            <img src="assets/k8s-servicios.png" alt="Servicios de Kubernetes">
        </div>
    </section>

    <section class="arquitectura grid-container" id="arquitectura">
        <div>
            <img src="assets/k8s-arquitectura.png" alt="Arquitectura de Kubernetes">
        </div>
    </section>

    <section class="ejemplos grid-container" id="ejemplos">
        <div>
            <img src="assets/k8s-ejemplos.png" alt="Ejemplos de Kubernetes">
        </div>
    </section>
</body>
</html>
EOF

cat <<'EOF' > "$WEB_DIR/style.css"
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: monospace;
}

header {
	background-image: url(assets/kubernetes.png);
	height: 100vh;
	background-size: cover;
	background-position: center;
	position: relative;
}

.main-nav {
	float: right;
	list-style: none;
	margin-top: 55px;
}

.main-nav li {
	display: inline-block;
}

.main-nav li a {
	color: white;
	text-decoration: none;
	padding: 5px 20px;
	font-family: "Roboto", sans-serif;
	font-size: 15px;
}

.main-nav li.active a,
.main-nav li a:hover {
	border-bottom: 1px solid white;
}

.logo {
	width: 400px;
	float: left;
	margin-top: 15px;
}

.logo img {
	width: 100%;
	display: block;
}

.row {
	max-width: 1200px;
	margin: auto;
}

.hero {
	position: absolute;
	top: 100px;
	width: 100%;
}

h1 {
	font-family: "Roboto", sans-serif;
	color: white;
	text-transform: uppercase;
	font-size: 60px;
	text-align: right;
	margin-top: 300px;
	margin-right: 100px;
}

.button {
	text-align: center;
	margin-top: 50px;
}

.btn {
	font-family: "Roboto", sans-serif;
	border: 1px solid white;
	padding: 10px 30px;
	color: white;
	margin-right: 5px;
	font-size: 13px;
	text-transform: uppercase;
	text-decoration: none;
}

.btn-one {
	background-color: darkorange;
}

.btn-two:hover {
	background-color: darkorange;
	transition: all 0.2s ease-in;
}

.grid-container {
	display: grid;
	grid-template-columns: 1fr;
	padding: 10px;
	text-align: center;
}

.grid-container img {
    width: 60%;
    max-width: 800px;
    height: auto;
    display: block;
    margin: 40px auto;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
}

.service,
.contact,
.faq {
	background-size: cover;
	background-position: center;
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
	-webkit-appearance: none;
	margin: 0;
}

.subject {
	height: 150px;
	color: black;
	resize: vertical;
}
EOF

echo "Archivos HTML y CSS creados en: $WEB_DIR"

# Iniciar Minikube con volumen montado
echo "Iniciando Minikube con montaje del directorio local..."
minikube start --driver=docker --mount-string="$WEB_DIR:$MOUNT_PATH" --mount &

# Esperar a que Minikube esté listo
echo "Esperando a que Minikube esté listo..."
sleep 20

# Crear manifiestos YAML

cat <<EOF > "$MANIFESTS_DIR/pvc/static-content-pv.yaml"
apiVersion: v1
kind: PersistentVolume
metadata:
  name: static-content-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadOnlyMany
  hostPath:
    path: "$MOUNT_PATH"
EOF

cat <<EOF > "$MANIFESTS_DIR/pvc/static-content-pvc.yaml"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: static-content-pvc
spec:
  accessModes:
    - ReadOnlyMany
  resources:
    requests:
      storage: 1Gi
EOF

cat <<EOF > "$MANIFESTS_DIR/deployment/web-deployment.yaml"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: static-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: static-web
  template:
    metadata:
      labels:
        app: static-web
    spec:
      containers:
        - name: nginx
          image: nginx
          volumeMounts:
            - name: html-volume
              mountPath: /usr/share/nginx/html
      volumes:
        - name: html-volume
          persistentVolumeClaim:
            claimName: static-content-pvc
EOF

cat <<EOF > "$MANIFESTS_DIR/service/web-service.yaml"
apiVersion: v1
kind: Service
metadata:
  name: static-web-service
spec:
  type: NodePort
  selector:
    app: static-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF

echo "Manifiestos creados en: $MANIFESTS_DIR"

# Aplicar manifiestos
echo "Aplicando manifiestos de Kubernetes..."
kubectl apply -f "$MANIFESTS_DIR/pvc/static-content-pv.yaml"
kubectl apply -f "$MANIFESTS_DIR/pvc/static-content-pvc.yaml"
kubectl apply -f "$MANIFESTS_DIR/deployment/web-deployment.yaml"
kubectl apply -f "$MANIFESTS_DIR/service/web-service.yaml"

# Verificar estado del pod
echo "Verificando estado del pod..."
sleep 10
kubectl get pods

# Verificar archivos montados
POD_NAME=$(kubectl get pods -l app=static-web -o jsonpath="{.items[0].metadata.name}")
echo "Contenido dentro del contenedor:"
kubectl exec -it "$POD_NAME" -- ls /usr/share/nginx/html

# Abrir el sitio web en navegador
echo "Abriendo sitio web en navegador..."
minikube service static-web-service &

echo "Despliegue finalizado correctamente."
