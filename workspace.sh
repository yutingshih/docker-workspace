#!/bin/bash

set -u -e

cd $(dirname $0)

IMAGE_NAME=base
CONTAINER_NAME=workspace
USER_NAME=user

build-image() {
    [[ $(docker images | grep $IMAGE_NAME) ]] || \
    docker build \
        -t $IMAGE_NAME \
        --build-arg="USERNAME=$USER_NAME" .
}

run-container() {
    docker run -it --rm \
        --name $CONTAINER_NAME \
        --hostname $CONTAINER_NAME \
        -v $(pwd)/projects:/workspace \
        $IMAGE_NAME
}

remove-container() {
    docker rm -f $CONTAINER_NAME
}

remove-image() {
    docker rmi -f $IMAGE_NAME
}

usage() {
    source scripts/color.sh
    echo -e "
$(title Usage:)
    $(command $0 '<COMMAND>')

$(title Commands:)
    $(command help) \t Print this help message
    $(command start), $(command run)   Build the image if not exist and run the container. Note that the container will be deleted after exit it.
    $(command remove), $(command rm) \t Remove the image
"
}

case ${1:-''} in
    start | run)
        build-image
        run-container
        ;;
    remove | rm)
        remove-image
        ;;
    *)
        usage
        ;;
esac
