# Neighborhoods.com Analytics Base Docker Image

## How to build the image

Use the bash script provided and provide a version number.

```
source build_and_push_image.sh 0.0.0
```

## How to use the image

#### Step 1: log into AWS ECR registry

Run `aws ecr get-login --no-include-email`. Its output will be a command
starting with `docker login ...` that you should copy and execute to log in to
the AWS ECR registry for our images.

#### Step 2: pull the image

Run the following (having substrituted the correct version number) to pull the
specified version of the `analytics-base` image to your local machine:

```
VERSION="0.0.0"
REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
IMAGE="${REGISTRY}/datascience/analytics-base"
docker pull ${IMAGE}:${VERSION}
docker tag ${IMAGE}:${VERSION} analytics-base:${VERSION}
```

#### Step 3a: use the image

You can start the container and exec into it with the following command:

```
VERSION="0.0.0"
PORT="7777"
docker run -it -p ${PORT}:8888 analytics-base:${VERSION}
```

From within the container, you can start an accessible Jupyter session via
`jupyter notebook --ip 0.0.0.0 --allow-root`. You can access this Jupyter
session by copying the link it provides, pasting it into your favorite browser
on your machine, and substitute `8888` for the `PORT` you specified.

#### Step 3b: extend the image

You can inherit from and extend this image by starting your Dockerfile with
`FROM analytics-base:${VERSION}`.

