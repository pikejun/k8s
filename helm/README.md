# 利用helm管理k8s

### helm的安装
- 下载安装helm命令
```
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz
tar -zxvf helm-v2.13.1-linux-amd64.tar.gz
cp linux-amd64/helm /usr/local/bin/helm
```
- 配置helm
```
# 设置tiller账号
kubectl --namespace kube-system create serviceaccount tiller
# 让tiller拥有控制k8s集群的权限
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# 初始化helm和tiller，注意指定阿里云的镜像 
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.13.1 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts --service-account tiller
```

### 利用helm安装jupyterhub
- 添加jupyterhub链接到helm仓库
```
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
```
- 配置helm_config.yaml用于安装jupyterhub
```proxy:
  secretToken: 97141abb55ea5321867979cb57bb2e6a86a2f4d6bb166fca45aedb07c212c42d
  service:
    type: NodePort
    nodePorts:
      http: 31212
  chp:
    resources:
      requests:
        memory: 0
        cpu: 0

hub:
  cookieSecret: 1470700e01f77171c2c67b12130c25081dfbdf2697af8c2f2bd05621b31100bf
  db:
    type: sqlite-memory
  resources:
    requests:
      memory: 0
      cpu: 0
  services:
    test:
      admin: true
      apiToken: 0cc05feaefeeb29179e924ffc6d3886ffacf0d1a28ab225f5c210436ffc5cfd5


singleuser:
  storage:
    type: none
  memory:
    guarantee: null

prePuller:
  hook:
    enabled: false

scheduling:
  userScheduler:
    enabled: true

debug:
  enabled: true

```

- 根据helm_config.yaml安装jupyterhub
```
helm upgrade --install jhub jupyterhub/jupyterhub \
  --namespace jhub  \
  --version=0.8.2 \
  --values helm_config.yaml
```

- 安装成功之后查看对应namespace的pod是否正常启动
```
[root@r01 helm]# kubectl get pod -n jhub
NAME                              READY   STATUS    RESTARTS   AGE
hub-bdd466cb4-9dnq9               1/1     Running   0          17h
proxy-64db6c956c-b8dqn            1/1     Running   0          17h
user-scheduler-7c949fb6db-666hc   1/1     Running   0          17h
```
- 通过查看proxy所在的节点ip和service中对应的端口在浏览器中登录
```
[root@r01 helm]# kubectl get service -n jhub
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
hub            ClusterIP   10.110.52.87     <none>        8081/TCP                     17h
proxy-api      ClusterIP   10.100.162.160   <none>        8001/TCP                     17h
proxy-public   NodePort    10.103.217.240   <none>        80:31212/TCP,443:32119/TCP   17h
```
