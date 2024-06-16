#!/bin/bash

# Variables
ISTIO_VERSION="1.10.0"
PROJECT_ID=$(gcloud config get-value project)
CLUSTER_NAME="gke-cluster"
CLUSTER_LOCATION="your-cluster-location"

# Connect to the cluster
gcloud container clusters get-credentials $CLUSTER_NAME --region $CLUSTER_LOCATION --project $PROJECT_ID

# Download Istio
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
cd istio-$ISTIO_VERSION

# Install Istio base and demo profile
kubectl create namespace istio-system
kubectl apply -f install/kubernetes/istio-base/files
kubectl apply -f install/kubernetes/istio-demo.yaml
