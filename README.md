 # 🐘 PostgreSQL PVC Migrator

 A purpose-built Docker image for migrating PostgreSQL data between PersistentVolumeClaims (PVCs) in Azure Kubernetes Service (AKS). This image includes `rsync` and validation utilities to ensure safe data transfer and verification when upgrading to a new storage class (e.g., zone-redundant storage).

---

## 📦 What’s Included

- `rsync`: For efficient file transfer
- `bash`, `coreutils`, `findutils`: For validation and scripting
- Prebuilt validation script (`validate-copy.sh`)


``` YAML
apiVersion: v1
kind: Pod
metadata:
  name: pg-data-migrator
  namespace: your namespace
spec:
  containers:
  - name: migrator
    image: ghcr.io/matopst/migration-pod:latest
    command: ["/usr/local/bin/validate-copy.sh"]
    volumeMounts:
    - mountPath: /mnt/old
      name: old-data
    - mountPath: /mnt/new
      name: new-data
    resources:
      limits:
        memory: "1000Mi"
      requests:
        cpu: "100m"
        memory: "150Mi"
    securityContext:
      allowPrivilegeEscalation: true
      runAsUser: 0
      runAsGroup: 0
      readOnlyRootFilesystem: false
      capabilities:
        add: ["DAC_OVERRIDE", "SETUID", "SETGID"]
      seccompProfile:
        type: RuntimeDefault
  restartPolicy: Never
  volumes:
  - name: old-data
    persistentVolumeClaim:
      claimName: your-claim-name
  - name: new-data
    persistentVolumeClaim:
      claimName: new-claim-name
``` 

Exec within the shell with: 

kubectl exec -it -n your-namespace pg-data-migrator -- sh

Expected output:
🔍 Starting PostgreSQL data migration validation...

📦 Step 1: Directory size comparison
2.4G    /mnt/old
2.4G    /mnt/new

📄 Step 2: File count comparison
Old: 5532 files
New: 5532 files
✅ File count matches

🧪 Step 3: rsync dry run for content differences
✅ No differences found via rsync dry-run

✅ Validation complete. Review output above before switching PVCs.