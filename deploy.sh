docker build -t polyhistor/multi-client:latest -t polyhistor/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t polyhistor/multi-server:latest -t polyhistor/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t polyhistor/multi-worker -t polyhistor/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# deplying the latest version for devs utilising local env
docker push polyhistor/multi-client:latest
docker push polyhistor/multi-server:latest
docker push polyhistor/multi-worker:latest

# deploying the git versioned image
docker push polyhistor/multi-client:$SHA
docker push polyhistor/multi-server:$SHA
docker push polyhistor/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployment/server-deployment server=polyhistor/multi-server:$SHA
kubectl set image deployment/client-deployment client=polyhistor/multi-client:$SHA
kubectl set image deployment/worker-deployment worker=polyhistor/multi-worker:$SHA