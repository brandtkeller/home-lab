# KNative Test Cluster

Purpose is to test KNative integrated with istio/certmanager/cloudflared tunnel for purposes of a possible "serverless" blog infrastructure. 

## Traffic Flow

I want to remove the friction of an cluster ingress gateway for routing traffic externally into the cluster.

Ideally cloudflared tunnel would be the sole entrypoint.

Current thought:

Cloudlfare DNS -> cloudflared-tunnel -> knative-local-gateway -> service

## Istio

Integrate cert-manager with the knative ingress gateway. Look at hosts field to supply a separation between `brandtkeller.com` and maybe a wildcard `*.brandtkeller.com`.

## mTLS

Investigate: Will mTLS strict enforce entry at cloudflare -> 