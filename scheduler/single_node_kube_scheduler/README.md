# k8s 自定义调度器
### 示例步骤:
##### 1.修改原始的调度器算法(也可以自己实现自定义调度算法）
generic_scheduler.go 文件中的 scheduler方法所示
##### 2.构建自定义调度器docker镜像
Dockerfile 文件所示
```
# 构建当前文件夹中的Dockerfile文件
docker build -t single_node_kube_scheduler .
# 将镜像打标签上传到私有docker镜像中
docker tag single_node_kube_scheduler hub.k8s:5000/single_node_kube_scheduler
docker login -u fast -p fast hub.k8s:5000 
docker push hub.k8s:5000/single_node_kube_scheduler:latest
``` 
##### 3.在k8s中启动自定义调度器
ingle_node_kube_scheduler.yaml文件所示
```
kubectl create -f single_node_kube_scheduler.yaml
```
##### 4.测试：在k8s中启动job任务并指定使用自定义调度器进行pod节点调度
hell-world-job.yaml文件所示
```
kubectl create -f hello-world-job.yaml
```
