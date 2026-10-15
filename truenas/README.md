# TrueNAS service host

This directory is the source of truth for the small, stateful Docker Compose services hosted directly on the TrueNAS machine. TrueNAS owns disks, ZFS datasets, snapshots, and NFS exports. Kubernetes consumes storage and service endpoints from this host; it does **not** run these host-bound workloads.

## Scope

The initial deployment comprises:

| Service | Role | Host-specific requirement |
| --- | --- | --- |
| Z-Wave JS UI | Owns the physical Z-Wave controller for a future Home Assistant deployment. | Stable USB serial-device path. |
| Immich machine learning | Provides GPU-backed ML inference to Immich. | NVIDIA Container Toolkit and a compatible GPU. |
| SeaweedFS | Provides S3-compatible blob storage for cluster workloads. | Persistent filer and volume datasets. |
| Distribution Registry | Private OCI registry for cluster images. | Persistent registry metadata and blob storage. |

Do not add application workloads here merely because this server has large disks. Keep the boundary sharp: host-bound hardware, storage, and cluster dependencies belong on TrueNAS; stateless and family-facing applications belong on Kubernetes.

## Design rules

1. **Git declares; TrueNAS stores state.** Commit Compose files, non-secret configuration, `.env.example`, and runbooks here. Keep actual `.env` files, credentials, generated certificates, databases, and volume data on TrueNAS datasets and out of Git.
2. **Use one Compose project.** A future `truenas/compose.yaml` should define the four services and their SeaweedFS components together, with named networks. One project gives one update transaction, a clear dependency graph, and one rollback point.
3. **Use native ZFS dataset bind mounts.** Compose must mount paths below `/mnt/<pool>/...`; it must not write to the boot pool or container-managed anonymous volumes. Do not have a container mount the TrueNAS NFS export back into its own host.
4. **Expose only deliberate LAN ports.** Services should communicate on an internal Compose network by default. Publish only the Z-Wave UI, an explicitly private Immich ML endpoint, Seaweed's S3 endpoint, and registry endpoint when a client outside the host needs them. Never publish their administrative ports to an untrusted network.
5. **Pin every image immutably.** Use a supported release tag plus a digest, never `latest`. Keep related Immich images on exactly the same release. Renovate should own routine tag and digest updates.
6. **No broad container privilege.** Do not use `privileged: true`. Z-Wave gets only its serial device; ML gets only the NVIDIA GPU runtime/device reservation. Containers run read-only where their upstream image supports it and receive only their own writable dataset mounts.
7. **Restart and health are explicit.** Every long-running service uses `restart: unless-stopped`, an upstream-supported health check where available, resource limits/reservations, and structured logs. `depends_on` may order startup but is not a readiness guarantee.

## Storage layout

Create datasets on the appropriate existing ZFS pools before deployment. Dataset names are illustrative; choose pool names once and reflect them in `.env`.

```text
/mnt/<fast-pool>/apps/homelab/config/zwave-js-ui
/mnt/<fast-pool>/apps/homelab/config/immich-ml
/mnt/<fast-pool>/apps/homelab/config/seaweedfs
/mnt/<fast-pool>/apps/homelab/config/registry
/mnt/<fast-pool>/apps/homelab/secrets
/mnt/<bulk-pool>/apps/homelab/seaweedfs/volumes
/mnt/<bulk-pool>/apps/homelab/registry
```

Use a fast, reliable pool for small mutable configuration and SeaweedFS filer metadata. Put Seaweed volume data on the capacity pool. The registry may use its own ZFS-backed filesystem storage initially, or Seaweed's S3 API once SeaweedFS has been proven and backed up; do not make both storage migrations at once.

Set an owner/group that the Compose services can write as, with restrictive permissions on `secrets/`. Record dataset paths in an untracked `.env`, for example:

```dotenv
FAST_DATASET=/mnt/tank/apps/homelab
BULK_DATASET=/mnt/archive/apps/homelab
TIME_ZONE=America/Chicago
ZIGBEE_OR_ZWAVE_DEVICE=/dev/serial/by-id/<stable-zwave-controller-id>
```

Use `/dev/serial/by-id/...`, never `/dev/ttyUSB0` or `/dev/ttyACM0`; kernel enumeration order is not stable. The variable name above is deliberately generic, but the initial deployment must map it to `/dev/zwave` and document the specific controller model.

Configure ZFS snapshots for every mutable dataset. Snapshots are not sufficient recovery on the same appliance: replicate configuration, SeaweedFS volume data, and registry data to independent storage. Test restoring a registry image and a Seaweed object before treating the backup plan as complete.

## Compose layout

Add deployment files incrementally in this directory:

```text
truenas/
├── README.md
├── compose.yaml                 # all service definitions; no secrets
├── .env.example                 # paths, ports, non-sensitive defaults
├── .gitignore                   # .env, secrets/, local overrides
├── config/
│   ├── seaweedfs/               # filer/S3 settings without credentials
│   └── registry/config.yml      # registry settings without credentials
└── scripts/
    ├── preflight                # verifies paths, devices, GPU, Compose
    └── update                   # fetch, review, pull, recreate, check
```

Prefer a single base `compose.yaml` with Compose profiles for optional hardware-dependent services:

- `zwave` profile: device mapping from `${ZWAVE_DEVICE}` to `/dev/zwave`; persistent application store in `${FAST_DATASET}/config/zwave-js-ui`.
- `gpu` profile: Immich ML only. Declare the NVIDIA GPU via the Compose device reservation/runtime supported by the installed Docker Engine; do not rely on a host-wide default runtime.
- default services: SeaweedFS master, filer, volume server, and S3 gateway; Registry.

Do not set the obsolete top-level Compose `version` field. Use the current Compose Specification. Give every container a service-specific, ZFS-backed bind mount rather than sharing a broad `/mnt` mount.

### SeaweedFS topology

For a single TrueNAS host, use separate master, filer, volume, and S3 gateway processes/containers. Persist the filer metadata and volume data in their respective datasets. The S3 gateway is the only Seaweed endpoint applications should need. Keep master/filer administration ports on the internal network or an admin-only LAN.

SeaweedFS is an object store, not an NFS replacement. Continue exporting a dedicated TrueNAS dataset over NFS for Kubernetes workloads that genuinely require POSIX filesystems. Kubernetes workloads that need blobs should use Seaweed's S3 endpoint, a dedicated bucket, and per-workload credentials.

### Distribution Registry storage

Use `registry:3` configured with an explicit storage backend and a persistent storage root. Start with a filesystem root under `${BULK_DATASET}/registry` to reduce initial failure modes. After Seaweed S3 is operational and restore-tested, the registry can use a dedicated Seaweed bucket through the registry S3 driver.

The registry must have TLS and authentication before clients beyond a controlled private LAN consume it. Treat image deletion and garbage collection as a runbook operation: stop writes, run garbage collection against the same storage root, then restart. Do not enable deletion casually without retention policy and backup coverage.

### Immich ML GPU

Run `immich-machine-learning` using the upstream Immich release that matches the Immich server exactly. Verify GPU visibility with an ML inference request, not merely a container start. The endpoint has no reason to be public; restrict it to the Immich server network/path and firewall it accordingly. If Immich itself will be in Kubernetes, explicitly configure its ML URL and provide private routed connectivity from the cluster to this host.

Keep model-cache data in `${FAST_DATASET}/config/immich-ml` so model downloads survive container replacement. GPU driver and NVIDIA Container Toolkit compatibility are host prerequisites; upgrades to either are maintenance changes, not ordinary image updates.

### Z-Wave JS UI

Mount the stable serial-by-id device through the Compose `devices` field and persist only the application's store directory. Give no other container access to that device. Back up the store before controller firmware updates and before changing the Z-Wave JS UI major version. Future Home Assistant should use the Z-Wave JS server endpoint, not compete for the USB adapter.

## Secrets and access

Store secrets in a restrictive TrueNAS dataset such as `${FAST_DATASET}/secrets`; keep it ignored by Git. Use Compose `env_file` or mounted secret files for:

- Z-Wave JS UI session secret;
- Seaweed S3 access keys and per-client credentials;
- Registry authentication/TLS material and, if used, Seaweed S3 credentials;
- any Immich credentials required by the selected topology.

Commit an `.env.example` with variable names and non-secret sample values only. Avoid putting credentials in Compose `environment`, shell history, or deployment commands. Give Kubernetes a distinct credential per workload/bucket; do not reuse the registry or administrator key.

## Update automation and change policy

Renovate currently enables only its custom `regex` manager, so it will not track images in future Compose files. When `truenas/compose.yaml` is added, extend `renovate.json` rather than replacing its existing manager:

```json
{
  "enabledManagers": ["docker-compose", "regex"],
  "packageRules": [
    {
      "matchManagers": ["docker-compose"],
      "matchFileNames": ["truenas/compose.yaml"],
      "groupName": "TrueNAS Compose image updates",
      "labels": ["renovate", "truenas"],
      "automerge": false
    },
    {
      "matchManagers": ["docker-compose"],
      "matchPackageNames": [
        "ghcr.io/immich-app/immich-server",
        "ghcr.io/immich-app/immich-machine-learning"
      ],
      "groupName": "Immich release",
      "automerge": false
    }
  ]
}
```

Keep image references literal in `compose.yaml` so Renovate can identify them, for example `image: registry:3.0.0@sha256:<digest>`. Do not hide image tags in arbitrary shell scripts. If a required image or version scheme is not recognized, add a narrowly scoped Renovate regex manager for that exact file and image rather than disabling image pinning.

Review and deploy updates in this order:

1. Renovate opens a PR containing image tag/digest changes.
2. Read upstream release notes, especially Immich database/API compatibility and SeaweedFS storage-format notes.
3. Take fresh ZFS snapshots of all affected datasets; confirm backup replication is current.
4. On TrueNAS, run `docker compose --env-file <private-env> pull`, then recreate only the changed services.
5. Check each service's health and a real contract: Z-Wave controller connection, GPU-backed ML inference, Seaweed S3 put/get, and authenticated registry push/pull.
6. If the contract fails, roll back the Git revision and image digest, then restore data only if the upstream migration made rollback unsafe.

Never auto-merge or automatically deploy these updates. The host contains physical-device state and storage dependencies; reviewed, reversible updates are more valuable than unattended freshness.

## Preflight and acceptance checks

Before the first deployment, the future `scripts/preflight` must fail clearly unless all of the following are true:

- Docker Engine and Docker Compose v2 are installed and the selected TrueNAS release supports the deployment method.
- Every configured dataset exists, is mounted, and is writable by the relevant service user.
- The configured Z-Wave `/dev/serial/by-id/...` path exists and is unique.
- `nvidia-smi` works on the host and a minimal NVIDIA container can see the intended GPU when the `gpu` profile is enabled.
- Required published ports are unused and restricted to intended LAN interfaces/firewall rules.
- Required secret files exist but are not tracked by Git.

The first smoke test is complete only after the following observable behavior succeeds:

```text
Z-Wave JS UI: controller is connected and its persistent store survives recreation.
Immich ML: a real inference request is handled by the GPU-enabled service.
SeaweedFS: a non-administrator S3 credential can create, write, read, and list its bucket.
Registry: an authenticated client can push, pull, and verify an image by digest.
```

## Operations boundary

- Manage the Compose project from this repository checkout; do not edit live containers through an appliance UI and expect Git to remain authoritative.
- Use TrueNAS UI/API for pools, datasets, snapshots, replication, network, firewall, and NFS exports. Keep their important settings documented here once finalized.
- Use Kubernetes manifests/GitOps for Kubernetes consumers. They should reference the TrueNAS NFS endpoint or Seaweed S3 endpoint through DNS and secrets, never host-path mounts into this server.
- Record any one-off hardware mapping, non-default port, or recovery procedure in this directory as it is introduced. A deployment that cannot be rebuilt from this repository plus backed-up secret/state datasets is not maintainable.
