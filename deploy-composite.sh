#!/bin/bash
set -e

deployComposite() {
  kubectl apply -f crossplane/composite -n crossplane-system
}

deployComposite
