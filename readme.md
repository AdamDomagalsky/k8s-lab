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



etcdctl --key=/etc/kubernetes/pki/etcd/peer.key --cert=/etc/kubernetes/pki/etcd/peer.crt --cacert=/etc/kubernetes/pki/etcd/ca.crt --endpoints=https://127.0.0.1:2379 member list

{"level":"warn","ts":"2023-05-30T19:25:29.753Z","caller":"rafthttp/probing_status.go:68","msg":"prober detected unhealthy status","round-tripper-name":"ROUND_TRIPPER_RAFT_MESSAGE","remote-peer-id":"9f1d380f3209b2bd","rtt":"0s","error":"x509: certificate is valid for 192.168.192.132, 127.0.0.1, ::1, not 192.168.20.12"}

zresetowałeś cp nody do stanu zero,
teraz trzeba je odtworzyć korzystając z https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/

drugi node po dołączeniu do initial noda musi miec w kubeapi i etcd podane adresy z sieci 192.168.20.0/32