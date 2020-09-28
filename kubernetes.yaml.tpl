apiVersion: apps/v1
kind: Deployment
metadata:
  name: exment-web
  labels:
    app: exment-web
spec:
  replicas: 1
  selector:
    matchLabels:
      app: exment-web
  template:
    metadata:
      labels:
        app: exment-web
    spec:
      containers:
      - name: exment-web
        image: docker.io/tamu222i/exment-web:COMMIT_SHA
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: exment-web
  labels:
    app: exment-web
spec:
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: exment-web
  type: NodePort
  selector:
    app: exment-web
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: exment-web
  annotations:
    kubernetes.io/ingress.class: "nginx"
    kubernetes.io/tls-acme: "true"
spec:
  tls:
  - secretName: kubernetes-ingress-tls
    hosts:
      - exment-web.tamu222i.com
  rules:
  - host: exment-web.tamu222i.com
    http:
      paths:
      - path: /
        backend:
          serviceName: exment-web
          servicePort: 80
      - path: /*
        backend:
          serviceName: exment-web
          servicePort: 80