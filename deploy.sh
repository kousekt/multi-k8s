# SHA is for the hit
docker build -t tkousek/multi-client:latest -t tkousek/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t tkousek/multi-server:latest -t tkousek/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t tkousek/multi-worker:latest -t tkousek/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push tkousek/multi-client:latest
docker push tkousek/multi-server:latest
docker push tkousek/multi-worker:latest

docker push tkousek/multi-client:$SHA
docker push tkousek/multi-server:$SHA
docker push tkousek/multi-worker:$SHA
# apply all the config files in that directory
kubectl apply -f k8s

# https://www.udemy.com/docker-and-kubernetes-the-complete-guide/learn/v4/t/lecture/11628252?start=0
#   look at 7:05 in the video for an explanation
kubectl set image deployments/server-deployment server=tkousek/multi-server:$SHA
kubectl set image deployments/client-deployment client=tkousek/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=tkousek/multi-worker:$SHA

