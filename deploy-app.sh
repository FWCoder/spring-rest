mvn clean install
oc delete all --all=true

oc create secret generic spring-test --from-literal=name=DK --output=yaml --dry-run > spring-test.yaml
oc create -f spring-test.yaml
oc process -f spring-test-template.yml | oc apply -f -
oc set env dc spring-test SERVER_SERVLET_CONTEXT_PATH="/v1"
oc create route edge spring-test --service=spring-test --hostname=springtest-myproject2.192.168.42.110.nip.io --path /v1 --insecure-policy Allow
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name spring-test -l app=spring-test
oc start-build spring-test --from-dir=.

while :
do 
 echo "waiting for pod to be complete"
 pod_status=$(oc get pods -l app=spring-test -o=jsonpath='{.items[*].status.containerStatuses[0].ready}')
 if [ "$pod_status" == "true" ]
 then
  break;
 fi
done
