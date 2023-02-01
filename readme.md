This lab will consist of HA controlplane, 3 cp nodes + 3 worker nodes.
For now cluster creation is done with k3sup CLI.

Tech stack will consist of following (in chronological order of provisioning)

1. Traefik (included in k3sup)
2. kube-prometheus (https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
3. Grafana add-on's: Loki, Tempo (https://github.com/grafana/helm-charts/tree/main/charts)
3. Cert-manager (https://github.com/cert-manager/cert-manager/tree/master/deploy)
4. Linkerd (https://github.com/linkerd/linkerd2/tree/main/charts)

The demo application running on the cluster will be https://github.com/open-telemetry/opentelemetry-demo