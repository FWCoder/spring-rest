mvn clean install

# Clean up
oc delete all -l app=spring-test
oc delete secret spring-test
oc delete all -l app=spring-test-v1
oc delete secret spring-test-v1
oc delete all -l app=spring-test-v2
oc delete secret spring-test-v2

# Create first version
oc create secret generic spring-test-v1 --from-literal=name=Refdata-v1 --output=yaml --dry-run > spring-test-v1.yaml
oc create -f spring-test-v1.yaml
oc process -f spring-test-template.yml -p APPLICATION_NAME=spring-test-v1 | oc apply -f -
oc create route edge spring-test-v1 --service=spring-test-v1
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name spring-test-v1 -l app=spring-test-v1
oc start-build spring-test-v1 --from-dir=.

# Create second version
oc create secret generic spring-test-v2 --from-literal=name=Refdata-v2 --output=yaml --dry-run > spring-test-v2.yaml
oc create -f spring-test-v2.yaml
oc process -f spring-test-template.yml -p APPLICATION_NAME=spring-test-v2 | oc apply -f -
oc create route edge spring-test-v2 --service=spring-test-v2
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name spring-test-v2 -l app=spring-test-v2
oc start-build spring-test-v2 --from-dir=.
