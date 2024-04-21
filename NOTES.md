# Notes

## Helm

### Helm upgrade

```sh
$ kubectl get all
NAME                             READY   STATUS    RESTARTS   AGE
pod/kbot-init-56f6f77f77-vlgr5   1/1     Running   0          70s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kbot-init   1/1     1            1           70s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/kbot-init-56f6f77f77   1         1         1       70s


$ helm upgrade kbot-init ./helm/ --set secret.tokenValue=$(echo $TELE_TOKEN | tr -d '\n' | base64)
Release "kbot-init" has been upgraded. Happy Helming!
NAME: kbot-init
LAST DEPLOYED: Sun Apr 21 16:03:59 2024
NAMESPACE: kbot
STATUS: deployed
REVISION: 2
TEST SUITE: None


$ kubectl get all
NAME                             READY   STATUS    RESTARTS   AGE
pod/kbot-init-7884557677-847xm   1/1     Running   0          53s

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/kbot-init   1/1     1            1           6m14s

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/kbot-init-7884557677   1         1         1       53s
replicaset.apps/kbot-init-56f6f77f77   0         0         0       6m14s


$ helm ls
NAME            NAMESPACE       REVISION        UPDATED                                         STATUS          CHART           APP VERSION
kbot-init       kbot            2               2024-04-21 16:03:59.204850282 +0300 EEST        deployed        kbot-0.1.0      1.16.0
```
