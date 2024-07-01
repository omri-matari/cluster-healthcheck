#!/bin/bash
print_no_errors() {
  if [ $? -ne 0 ]
  then
    echo -e "No errors"
  fi
}
echo -e "***Nodes status***"
kubectl get nodes -o wide
echo -e "\n"

echo -e "***Display Runai pods with issues***"
kubectl get pods -n runai -o wide --no-headers | grep -v "Running\|Completed"
print_no_errors
echo -e "\n"

echo -e "***Display Runai reservation pods with issues***"
kubectl get pods -n runai-reservation -o wide --no-headers | grep -v "Running\|Completed"
print_no_errors
echo -e "\n"

echo -e "***Display monitoring pods with issues***"
kubectl get pods -n monitoring -o wide --no-headers | grep -v "Running\|Completed"
print_no_errors
echo -e "\n"

echo -e "***Display kube-system pods with issues***"
kubectl get pods -n kube-system -o wide --no-headers | grep -v "Running\|Completed"
print_no_errors
echo -e "\n"

echo -e "***Display GPU operator pods with issues***"
kubectl get pods -n gpu-operator -o wide --no-headers | grep -v "Running\|Completed"
print_no_errors
echo -e "\n"

echo -e "***Check for errors in ReplicaSets***"
kubectl describe rs | grep Error
print_no_errors
echo -e "\n"

echo -e "***Display nginx-ingress pods with issues***"
kubectl get pods -n nginx-ingress -o wide --no-headers | grep -v "Running\|Completed"
print_no_errors
echo -e "\n"

echo -e "***Display nginx-ingress svc information***"
kubectl get svc -n nginx-ingress
echo -e "\n"

echo -e "***Runai cluster version***"
helm list -n runai
helm list -n runai -f runai-cluster
echo -e "\n"

echo -e "***Display errors in kubelet for the last week***"
journalctl -u kubelet.service --since "1 week ago" -p err

echo -e "***Connectivity check to Runai control-plane***"

curl https://app.run.ai/_healthy
###Info on each node###
echo -e "\n"
echo -e "***Root and data disk utilization***"
df -h /
df -h | grep data
###echo -e "\n"
###echo -e "***Disk speed***"
###hdparm -Tt /dev/sda