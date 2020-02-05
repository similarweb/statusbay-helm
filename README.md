# Helm Chart for Statusbay


## Installation

Clone the git repository
```bash
git clone git@github.com:similarweb/statusbay-helm.git && cd statusbay-helm
```

Install the StatusBay helm chart with a release name `my-release`:

helm 2:
```bash
helm install --name my-release .
```
helm 3:
```bash
helm install my-release .
```

## Configuration

The following table lists the configurable parameters of the Statusbay chart.      
Parameter | Description | Default
--- | --- | ---
`image.repository` | container image repository | `eladkaplan1/statusbay`
`image.tag` | container image tag | `v1.1`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
| **Database** |
`database.type` | `internal` or `external`, internal would start a statefullset with MySQL | `internal`
`database.host` | The hostname of database, redundant if you're using internal database | `192.168.0.1`
`database.port` | The port of database, redundant if you're using internal database | `3306`
`database.username` | The username of database | `statusbay`
`database.password` | The password of database | `changeme`
`database.schema` | The schema name of database | `statusbay`
`database.internal.image.repository` | container image repository | `mysql`
`database.internal.image.tag` | container image tag | `5.7`
`database.internal.image.pullPolicy` | container image pull policy | `IfNotPresent`
`database.internal.resources` | The [resources] to allocate for container | undefined
`database.internal.persistence.persistentVolumeClaim.accessMode` | The access mode of the volume | `ReadWriteOnce`
`database.internal.persistence.persistentVolumeClaim.storageClass` | Specify the `storageClass` used to provision the volume. Or the default StorageClass will be used(the default). Set it to `-` to disable dynamic provisioning | `-`
`database.internal.persistence.persistentVolumeClaim.size` | The size of the volume | `5Gi`
| **ingress** |
`ingress.api.annotations` | The annotations used in ingress | `{}`
`ingress.api.host` | The host of Statusbay ingress api | `api.statusbay.domain`
| **service** |
`service.api.type` | The type of api service to create  | `NodePort`
`service.api.annotations` | The annotations used in api service | `{}`
`service.api.externalPort` | The external port for api server | `80`
| **rbac** |
`rbac.create` | If true, create & use RBAC resources | `true`
| **serviceAccount** |
`serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true`
`serviceAccount.name` | The name of the ServiceAccount to use  | ``
| **api** |
`api.create` | If true, api server will be deploy | `true`
`api.replicas` | The replica count | `1`
`api.annotations` | The annotations used in api deployment | `{}`
`api.application.log_level` | The application log level | `info`
`api.application.metrics.datadog.api_key` | The datadog provider api key | 
`api.application.metrics.datadog.app_key` | The datadog provider app key | 
`api.application.metrics.datadog.cache_cleanup_interval` | The interval time for cleanup cache metrics | 
`api.application.metrics.datadog.cache_expiration` | The metric response cache expiration | undefined
`api.application.metrics.prometheus.address` | The prometheus address | undefined
`api.application.alerts.statuscake.endpoint` | The Statuscake endpoint | undefined
`api.application.alerts.statuscake.username` | The Statuscake username auth | undefined
`api.application.alerts.statuscake.api_key` | The Statuscake api auth | undefined
`api.application.alerts.pingdom.endpoint` | The Pingdom endpoint auth | undefined
`api.application.alerts.pingdom.token` | The Pingdom token auth | undefined
`api.resources` | The [resources] to allocate for container | undefined
| **watcher** |
`watcher.kubernetes.create` | If true, Kubernetes watcher will be deploy | `true`
`watcher.kubernetes.annotations` | The annotations used in api deployment | `{}`
`watcher.kubernetes.application.log_level` | The application log level | `info`
`watcher.kubernetes.application.ui.base_url` | The Statusbay UI endpoint | `todo`
`watcher.kubernetes.application.applies.save_interval` | The interval time to save applies to DB | `2s`
`watcher.kubernetes.application.applies.max_apply_time` | The maximum wacher time to waite until apply finish | `10m`
`watcher.kubernetes.application.applies.check_finish_delay` | The time delay until the wacher check the apply status | `5s`
`watcher.kubernetes.application.applies.collect_data_after_apply_finish` | The time that the watcher continue collect data when apply finish | `10s`
`watcher.kubernetes.resources` | The [resources] to allocate for container | undefined
