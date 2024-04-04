CURRENT_INSTANCE=$(docker ps -a -q --filter ancestor="$IMAGE_NAME" --format="{{.ID}}")

if [ "$CURRENT_INSTANCE" ]
then
    docker rm $(docker stop $CURRENT_INSTANCE)
fi

docker pull $IMAGE_NAME

CONTAINER_EXISTS=$(docker ps -a | grep $CONTAINER_NAME)  # Use CONTAINER_NAME variable
if [ "$CONTAINER_EXISTS" ]
then
    docker rm $CONTAINER_NAME  # Use CONTAINER_NAME variable
fi

docker create -p 8443:8443 --name $CONTAINER_NAME $IMAGE_NAME  # Use CONTAINER_NAME variable

echo $PRIVATE_KEY > privatekey.pem

echo $SERVER > server.crt

docker cp ./privatekey.pem $CONTAINER_NAME:/privatekey.pem  # Use CONTAINER_NAME variable

docker cp ./server.crt $CONTAINER_NAME:/server.crt  # Use CONTAINER_NAME variable

docker start $CONTAINER_NAME  # Use CONTAINER_NAME variable