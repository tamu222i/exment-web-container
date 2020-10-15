apiVersion: v1
kind: ConfigMap
metadata:
  name: laravel-config
  labels:
    name: laravel-config
data:
  DB_HOST: "mysql.default.svc.cluster.local"
  DB_PORT: "3306"
  DB_DATABASE: "exment-database"
  DB_USERNAME: "exment-user"
  APP_LOCALE: "ja"
  APP_TIMEZONE: "Asia/Tokyo"
  GOOGLE_CLIENT_ID: "498313290060-f3kfn8ru6keqilfr8fapfckldu1ghb8k.apps.googleusercontent.com"
---
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
        lifecycle:
          postStart:
            exec:
              command:
              - sh
              - -c
              - >
                cd /var/www/exment;
#               php artisan key:generate;
#                php artisan passport:keys;
#                php artisan exment:publish;
                php artisan exment:install;

        envFrom:
        - configMapRef:
            name: laravel-config
        env:
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql
              key: password
        - name: GOOGLE_CLIENT_SECRET
          valueFrom:
            secretKeyRef:
              name: google
              key: client_secret
        args: ["/usr/sbin/httpd", "-D", "FOREGROUND"]
        ports:
        - containerPort: 8080