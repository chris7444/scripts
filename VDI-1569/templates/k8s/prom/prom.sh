BINARY=$1
${BINARY} apply -f - <<EOF
---
# Source: prometheus/templates/alertmanager-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "alertmanager"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-alertmanager
data:
  alertmanager.yml: |
    global: {}
    receivers:
    - name: default-receiver
    route:
      group_interval: 5m
      group_wait: 10s
      receiver: default-receiver
      repeat_interval: 3h
---
# Source: prometheus/templates/server-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "server"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-server
data:
  alerts: |
    {}
    
  prometheus.yml: |
    global:
      evaluation_interval: 1m
      scrape_interval: 1m
      scrape_timeout: 10s
      
    rule_files:
    - /etc/config/rules
    - /etc/config/alerts
    scrape_configs:
    - job_name: prometheus
      static_configs:
      - targets:
        - localhost:9090
    - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      job_name: kubernetes-apiservers
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - action: keep
        regex: default;kubernetes;https
        source_labels:
        - __meta_kubernetes_namespace
        - __meta_kubernetes_service_name
        - __meta_kubernetes_endpoint_port_name
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
    - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      job_name: kubernetes-nodes
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - replacement: kubernetes.default.svc:443
        target_label: __address__
      - regex: (.+)
        replacement: /api/v1/nodes/${1}/proxy/metrics
        source_labels:
        - __meta_kubernetes_node_name
        target_label: __metrics_path__
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
    - bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
      job_name: kubernetes-nodes-cadvisor
      kubernetes_sd_configs:
      - role: node
      relabel_configs:
      - action: labelmap
        regex: __meta_kubernetes_node_label_(.+)
      - replacement: kubernetes.default.svc:443
        target_label: __address__
      - regex: (.+)
        replacement: /api/v1/nodes/${1}/proxy/metrics/cadvisor
        source_labels:
        - __meta_kubernetes_node_name
        target_label: __metrics_path__
      scheme: https
      tls_config:
        ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        insecure_skip_verify: true
    - job_name: kubernetes-service-endpoints
      kubernetes_sd_configs:
      - role: endpoints
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scrape
      - action: replace
        regex: (https?)
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_scheme
        target_label: __scheme__
      - action: replace
        regex: (.+)
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_path
        target_label: __metrics_path__
      - action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        source_labels:
        - __address__
        - __meta_kubernetes_service_annotation_prometheus_io_port
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: kubernetes_namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_service_name
        target_label: kubernetes_name
    - honor_labels: true
      job_name: prometheus-pushgateway
      kubernetes_sd_configs:
      - role: service
      relabel_configs:
      - action: keep
        regex: pushgateway
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_probe
    - job_name: kubernetes-services
      kubernetes_sd_configs:
      - role: service
      metrics_path: /probe
      params:
        module:
        - http_2xx
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_service_annotation_prometheus_io_probe
      - source_labels:
        - __address__
        target_label: __param_target
      - replacement: blackbox
        target_label: __address__
      - source_labels:
        - __param_target
        target_label: instance
      - action: labelmap
        regex: __meta_kubernetes_service_label_(.+)
      - source_labels:
        - __meta_kubernetes_namespace
        target_label: kubernetes_namespace
      - source_labels:
        - __meta_kubernetes_service_name
        target_label: kubernetes_name
    - job_name: kubernetes-pods
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: keep
        regex: true
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_scrape
      - action: replace
        regex: (.+)
        source_labels:
        - __meta_kubernetes_pod_annotation_prometheus_io_path
        target_label: __metrics_path__
      - action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        source_labels:
        - __address__
        - __meta_kubernetes_pod_annotation_prometheus_io_port
        target_label: __address__
      - action: labelmap
        regex: __meta_kubernetes_pod_label_(.+)
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: kubernetes_namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: kubernetes_pod_name
    
    alerting:
      alertmanagers:
      - kubernetes_sd_configs:
          - role: pod
        tls_config:
          ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
        bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
        relabel_configs:
        - source_labels: [__meta_kubernetes_namespace]
          regex: default
          action: keep
        - source_labels: [__meta_kubernetes_pod_label_app]
          regex: prometheus
          action: keep
        - source_labels: [__meta_kubernetes_pod_label_component]
          regex: alertmanager
          action: keep
        - source_labels: [__meta_kubernetes_pod_container_port_number]
          regex:
          action: drop
  rules: |
    {}
---
# Source: prometheus/templates/alertmanager-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "alertmanager"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-alertmanager
spec:
  accessModes:
    - ReadWriteOnce
    
  resources:
    requests:
      storage: "2Gi"
---
# Source: prometheus/templates/server-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "server"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-server
spec:
  accessModes:
    - ReadWriteOnce
    
  resources:
    requests:
      storage: "8Gi"
---
# Source: prometheus/templates/alertmanager-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "alertmanager"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-alertmanager
spec:
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 9093
  selector:
    app: prometheus
    component: "alertmanager"
    release: my-prometheus
  type: "ClusterIP"
---
# Source: prometheus/templates/kube-state-metrics-svc.yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/scrape: "true"
    
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "kube-state-metrics"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-kube-state-metrics
spec:
  clusterIP: None
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 8080
  selector:
    app: prometheus
    component: "kube-state-metrics"
    release: my-prometheus
  type: "ClusterIP"
---
# Source: prometheus/templates/node-exporter-service.yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/scrape: "true"
    
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "node-exporter"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-node-exporter
spec:
  clusterIP: None
  ports:
    - name: metrics
      port: 9100
      protocol: TCP
      targetPort: 9100
  selector:
    app: prometheus
    component: "node-exporter"
    release: my-prometheus
  type: "ClusterIP"
---
# Source: prometheus/templates/pushgateway-service.yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    prometheus.io/probe: pushgateway
    
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "pushgateway"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-pushgateway
spec:
  ports:
    - name: http
      port: 9091
      protocol: TCP
      targetPort: 9091
  selector:
    app: prometheus
    component: "pushgateway"
    release: my-prometheus
  type: "ClusterIP"
---
# Source: prometheus/templates/server-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "server"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-server
spec:
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: 9090
  selector:
    app: prometheus
    component: "server"
    release: my-prometheus
  type: "ClusterIP"
---
# Source: prometheus/templates/node-exporter-daemonset.yaml
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "node-exporter"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-node-exporter
spec:
  updateStrategy:
    type: OnDelete
    
  template:
    metadata:
      labels:
        app: prometheus
        component: "node-exporter"
        release: my-prometheus
    spec:
      serviceAccountName: my-prometheus-node-exporter
      containers:
        - name: prometheus-node-exporter
          image: "prom/node-exporter:v0.15.2"
          imagePullPolicy: "IfNotPresent"
          args:
            - --path.procfs=/host/proc
            - --path.sysfs=/host/sys
          ports:
            - name: metrics
              containerPort: 9100
              hostPort: 9100
          resources:
            {}
            
          volumeMounts:
            - name: proc
              mountPath: /host/proc
              readOnly:  true
            - name: sys
              mountPath: /host/sys
              readOnly: true
      hostNetwork: true
      hostPID: true
      volumes:
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
---
# Source: prometheus/templates/alertmanager-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "alertmanager"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-alertmanager
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus
        component: "alertmanager"
        release: my-prometheus
    spec:
      serviceAccountName: my-prometheus-alertmanager
      containers:
        - name: prometheus-alertmanager
          image: "prom/alertmanager:v0.14.0"
          imagePullPolicy: "IfNotPresent"
          env:
          args:
            - --config.file=/etc/config/alertmanager.yml
            - --storage.path=/data
            - --web.external-url=/

          ports:
            - containerPort: 9093
          readinessProbe:
            httpGet:
              path: /#/status
              port: 9093
            initialDelaySeconds: 30
            timeoutSeconds: 30
          resources:
            {}
            
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
            - name: storage-volume
              mountPath: "/data"
              subPath: ""

        - name: prometheus-alertmanager-configmap-reload
          image: "jimmidyson/configmap-reload:v0.1"
          imagePullPolicy: "IfNotPresent"
          args:
            - --volume-dir=/etc/config
            - --webhook-url=http://localhost:9093/-/reload
          resources:
            {}
            
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
              readOnly: true
      volumes:
        - name: config-volume
          configMap:
            name: my-prometheus-alertmanager
        - name: storage-volume
          persistentVolumeClaim:
            claimName: my-prometheus-alertmanager
---
# Source: prometheus/templates/kube-state-metrics-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "kube-state-metrics"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-kube-state-metrics
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus
        component: "kube-state-metrics"
        release: my-prometheus
    spec:
      serviceAccountName: my-prometheus-kube-state-metrics
      containers:
        - name: prometheus-kube-state-metrics
          image: "quay.io/coreos/kube-state-metrics:v1.3.1"
          imagePullPolicy: "IfNotPresent"
          ports:
            - name: metrics
              containerPort: 8080
          resources:
            {}
---
# Source: prometheus/templates/pushgateway-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "pushgateway"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-pushgateway
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus
        component: "pushgateway"
        release: my-prometheus
    spec:
      serviceAccountName: my-prometheus-pushgateway
      containers:
        - name: prometheus-pushgateway
          image: "prom/pushgateway:v0.5.1"
          imagePullPolicy: "IfNotPresent"
          args:
          ports:
            - containerPort: 9091
          readinessProbe:
            httpGet:
              path: /#/status
              port: 9091
            initialDelaySeconds: 10
            timeoutSeconds: 10
          resources:
            {}
---
# Source: prometheus/templates/server-deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    app: prometheus
    chart: prometheus-6.7.4
    component: "server"
    heritage: Tiller
    release: my-prometheus
  name: my-prometheus-server
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: prometheus
        component: "server"
        release: my-prometheus
    spec:
      serviceAccountName: my-prometheus-server
      initContainers:
      - name: "init-chown-data"
        image: "busybox:latest"
        imagePullPolicy: "IfNotPresent"
        resources:
            {}
            
        # 65534 is the nobody user that prometheus uses.
        command: ["chown", "-R", "65534:65534", "/data"]
        volumeMounts:
        - name: storage-volume
          mountPath: /data
          subPath: ""
      containers:
        - name: prometheus-server-configmap-reload
          image: "jimmidyson/configmap-reload:v0.1"
          imagePullPolicy: "IfNotPresent"
          args:
            - --volume-dir=/etc/config
            - --webhook-url=http://localhost:9090/-/reload
          resources:
            {}
            
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
              readOnly: true

        - name: prometheus-server
          image: "prom/prometheus:v2.2.1"
          imagePullPolicy: "IfNotPresent"
          args:
            - --config.file=/etc/config/prometheus.yml
            - --storage.tsdb.path=/data
            - --web.console.libraries=/etc/prometheus/console_libraries
            - --web.console.templates=/etc/prometheus/consoles
            - --web.enable-lifecycle
          ports:
            - containerPort: 9090
          readinessProbe:
            httpGet:
              path: /-/ready
              port: 9090
            initialDelaySeconds: 30
            timeoutSeconds: 30
          livenessProbe:
            httpGet:
              path: /-/healthy
              port: 9090
            initialDelaySeconds: 30
            timeoutSeconds: 30
          resources:
            {}
            
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
            - name: storage-volume
              mountPath: /data
              subPath: ""
      terminationGracePeriodSeconds: 300
      volumes:
        - name: config-volume
          configMap:
            name: my-prometheus-server
        - name: storage-volume
          persistentVolumeClaim:
            claimName: my-prometheus-server
EOF

