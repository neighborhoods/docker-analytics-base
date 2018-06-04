# !/usr/bin/bash

TAG=$1
IMAGE_NAME=analytics-base
AWS_IMAGE_PREFIX=datascience
AWS_ECR_SERVER=${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com
AWS_TAG=${AWS_ECR_SERVER}/${AWS_IMAGE_PREFIX}/${IMAGE_NAME}:${TAG}

# build and tag the image
docker build -t ${IMAGE_NAME}:${TAG} .
docker tag ${IMAGE_NAME}:${TAG} ${AWS_TAG}

# log in to our ECR registry 
echo $($(aws ecr get-login --no-include-email))

# push the image
docker push ${AWS_TAG}

# logout of ECR registry
docker logout ${AWS_ECR_SERVER}
