#!/bin/sh
set -e

log() {
  echo ""
  echo "##################################"
  echo "-------> $1"
  echo "##################################"
}

setup() {
  export DOCKER_REGISTRY_ADDRESS="127.0.0.1:5000"
  export DOCKER_REGISTRY_USER="testuser"
  export DOCKER_REGISTRY_PASS="testpwd"
  export DOCKER_PRIVATE_IMAGE="127.0.0.1:5000/my-private-service:v1"
  sh scripts/testing/setup_private_registry.sh
}

run() {
  # Run the acc test suite
  make testacc
  # for a single test
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_basic$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_full$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateHealthcheck$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateIncreaseReplicas$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateDecreaseReplicas$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateImage$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateConfig$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateConfigAndSecret$
  #TF_LOG=INFO TF_ACC=1 go test -v -timeout 120s github.com/terraform-providers/terraform-provider-docker/docker -run ^TestAccDockerService_updateMultipleConfigs$
}

cleanup() {
  docker stop private_registry
  unset DOCKER_REGISTRY_ADDRESS DOCKER_REGISTRY_USER DOCKER_REGISTRY_PASS DOCKER_PRIVATE_IMAGE
  rm -f scripts/testing/auth/htpasswd
  rm -f scripts/testing/certs/registry_auth.*
}

## main
log "setup" && setup 
log "run" && run
log "cleanup" && cleanup