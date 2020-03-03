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
--------- | ----------- | -------
`image.repository` | container image repository | `similarweb/statusbay`
`image.tag` | container image tag | `v1.1`
`image.pullPolicy` | container image pull policy | `IfNotPresent`
| **Database** |
`database.type` | `internal` or `external`, internal would start a statefullset with MySQL | `internal`
`database.host` | The hostname of database, redundant if you're using internal database | `127.0.0.1`
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
`database.internal.persistence.persistentVolumeClaim.size` | The size of the volume | `1Gi`
| **redis** |
`redis.type` | `internal` or `external`, internal would start a statefullset with Redis | `internal`
`redis.host` | The hostname of Redis, redundant if you're using internal Redis | `127.0.0.1`
`redis.port` | The port of redis, redundant if you're using internal redis | `6379`
`redis.password` | The password of Redis | ``
`redis.db` | The DB of Redis | `0`
`redis.internal.image.repository` | container image repository | `redis`
`redis.internal.image.tag` | container image tag | `5.0.7`
`redis.internal.image.pullPolicy` | container image pull policy | `IfNotPresent`
`redis.internal.resources` | The [resources] to allocate for container | undefined
`redis.internal.persistence.persistentVolumeClaim.accessMode` | The access mode of the volume | `ReadWriteOnce`
`redis.internal.persistence.persistentVolumeClaim.storageClass` | Specify the `storageClass` used to provision the volume. Or the default StorageClass will be used(the default). Set it to `-` to disable dynamic provisioning | `-`
`redis.internal.persistence.persistentVolumeClaim.size` | The size of the volume | `1Gi`
| **Ingress** |
`ingress.api.annotations` | The annotations used in ingress | `{}`
`ingress.api.host` | The host of Statusbay ingress api | `api.statusbay.domain`
`ingress.ui.annotations` | The annotations used in ingress for the UI | `{}`
`ingress.ui.host` | The host of StatusBay ingress UI | `statusbay.domain`
| **Service** |
`service.api.type` | The type of api service to create  | `ClusterIP`
`service.api.annotations` | The annotations used in api service | `{}`
`service.api.externalPort` | The external port for api server | `80`
`service.ui.type` | The type of UI service to create  | `ClusterIP`
`service.ui.annotations` | The annotations used in UI service | `{}`
`service.ui.externalPort` | The external port for UI server | `80`
| **RBAC** |
`rbac.create` | If true, create & use RBAC resources | `true`
| **Service Account** |
`serviceAccount.create` | Specifies whether a ServiceAccount should be created | `true`
`serviceAccount.name` | The name of the ServiceAccount to use  | ``
| **UI** |
`ui.create` | If true, UI server will be deploy | `true`
`ui.replicas` | The replica count of the UI webserver | `2`
`ui.annotations` | The annotations to be used in the UI deployment | `{}`
`ui.image.repository` | UI container image repository | `similarweb/statusbay-ui`
`ui.image.tag` | UI container image tag | `dev`
`ui.image.pullPolicy` | container image pull policy | `IfNotPresent`
`ui.application.log.level` | The UI application log level | `info`
`ui.application.log.gelf_address` | The address to ship logs to an external system | undefined
`ui.resources` | The [resources] to allocate for the UI containers | undefined
| **API** |
`api.create` | If true, api server will be deploy | `true`
`api.replicas` | The replica count | `2`
`api.annotations` | The annotations used in api deployment | `{}`
`api.application.log.level` | The application log level | `info`
`api.application.log.gelf_address` | The address for ship the log out for external system | undefined
`api.application.metrics.datadog.api_key` | The datadog provider api key | 
`api.application.metrics.datadog.app_key` | The datadog provider app key |  
`api.application.metrics.datadog.cache_expiration` | The metric response cache expiration | undefined
`api.application.metrics.prometheus.address` | The prometheus address | undefined
`api.application.alerts.statuscake.endpoint` | The Statuscake endpoint | undefined
`api.application.alerts.statuscake.username` | The Statuscake username auth | undefined
`api.application.alerts.statuscake.api_key` | The Statuscake api auth | undefined
`api.application.alerts.pingdom.endpoint` | The Pingdom endpoint auth | undefined
`api.application.alerts.pingdom.token` | The Pingdom token auth | undefined
`api.resources` | The [resources] to allocate for container | undefined
| **Watcher** |
`watcher.kubernetes.create` | If true, Kubernetes watcher will be deploy | `true`
`watcher.kubernetes.cluster_name` | The cluster name | `default`
`watcher.kubernetes.annotations` | The annotations used in api deployment | `{}`
`watcher.kubernetes.application.log.level` | The application log level | `info`
`watcher.kubernetes.application.log.gelf_address` | The address for ship the log out for external system | undefined
`watcher.kubernetes.application.ui.base_url` | The Statusbay UI endpoint | `defaults to ingress.ui.host setting through the configmap`
`watcher.kubernetes.application.applies.save_interval` | The interval time to save applies to DB | `2s`
`watcher.kubernetes.application.applies.max_apply_time` | The maximum wacher time to waite until apply finish | `10m`
`watcher.kubernetes.application.applies.check_finish_delay` | The time delay until the wacher check the apply status | `5s`
`watcher.kubernetes.application.applies.collect_data_after_apply_finish` | The time that the watcher continue collect data when apply finish | `10s`
`watcher.kubernetes.resources` | The [resources] to allocate for container | undefined
