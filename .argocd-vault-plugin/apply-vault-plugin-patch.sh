#!/bin/bash

ARGOCD_VERSION="v2.12.0"

# CM
kubectl -n argocd replace -f cmp-plugin-cm.yaml --force

# ROLE
kubectl -n argocd patch --patch-file argocd-repo-server-role-patch.yaml role/argocd-repo-server

# PATCH DEPLOYMENT
## BACKUP
if [ ! -f "argocd-repo-server-deployment-backup.yaml" ]; then
    echo "Backing up repo server deployment"
    kubectl -n argocd get deploy argocd-repo-server -o yaml > argocd-repo-server-deployment-backup.yaml
fi

## PATCH
sed "s|quay.io/argoproj/argocd:.*|quay.io/argoproj/argocd:${ARGOCD_VERSION}|g" -i argocd-repo-server-patch.yaml
kubectl -n argocd patch --patch-file argocd-repo-server-patch.yaml deploy/argocd-repo-server
