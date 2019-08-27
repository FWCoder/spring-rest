mvn clean install
oc delete all -l app=spring-test
oc delete secret spring-test

oc create secret generic spring-test --from-literal=name=DK --output=yaml --dry-run > spring-test.yaml
oc create -f spring-test.yaml
oc process -f spring-test-template.yml | oc apply -f -
oc create route edge spring -test --service=spring-test
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name spring-test -l app=spring-test
oc start-build spring-test --from-dir=.
