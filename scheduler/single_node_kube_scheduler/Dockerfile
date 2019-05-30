# build single node kube scheduler docker-image
# copy k8s v1.13.3 source code and replace the pkg/scheduler/core/generic_scheduler.go with my scheduler

FROM golang:1.11

RUN git clone  https://github.com/kubernetes/kubernetes.git
RUN apt-get update && apt-get install -y rsync
ADD generic_scheduler.go /
RUN cd kubernetes && git checkout -b v1.13.3 v1.13.3 && \ 
	cp /generic_scheduler.go pkg/scheduler/core/generic_scheduler.go && \
	make all && \
	cp _output/bin/kube-scheduler /kube-scheduler

FROM centos:latest
COPY --from=0 /kube-scheduler /usr/local/bin/kube-scheduler
