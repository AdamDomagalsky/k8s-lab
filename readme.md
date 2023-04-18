This lab will consist of HA controlplane, 3 cp nodes + 3 worker nodes.
For now cluster creation is done with k3sup CLI.

Tech stack will consist of following (in chronological order of provisioning)

1. Traefik 
2. kube-prometheus-stack 
3. Grafana add-on's: Loki, Tempo
4. Cert-manager 
5. Linkerd 

The demo application running on the cluster will be https://github.com/open-telemetry/opentelemetry-demo



[TODO]

1. Check cert-manager installation, add prometheus and ingress