mvn clean install
oc delete all -l app=spring-test
oc delete secret spring-test

oc create secret generic spring-test --from-literal=name=DK --output=yaml --dry-run > spring-test.yaml
oc create -f spring-test.yaml
oc process -f spring-test-template.yml | oc apply -f -
#oc create route edge spring-test-v0 --service=spring-test --hostname=springtest-myproject2.192.168.42.110.nip.io --insecure-policy Allow
oc set env dc spring-test SERVER_SERVLET_CONTEXT_PATH="/v1"
oc create route edge spring-test-v1 --service=spring-test --hostname=springtest-myproject2.192.168.42.110.nip.io --path /v1 --insecure-policy Allow
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name spring-test -l app=spring-test
oc start-build spring-test --from-dir=.
