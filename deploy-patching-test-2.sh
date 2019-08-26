mvn clean install

# Clean up
oc delete all -l app=ihg-test
oc delete secret ihg-test
oc delete all -l app=ihg-test-v1
oc delete secret ihg-test-v1
oc delete all -l app=ihg-test-v2
oc delete secret ihg-test-v2

# Create first version
oc create secret generic ihg-test-v1 --from-literal=name=Refdata-v1 --output=yaml --dry-run > ihg-test-v1.yaml
oc create -f ihg-test-v1.yaml
oc process -f ihg-test-template.yml -p APPLICATION_NAME=ihg-test-v1 | oc apply -f -
#oc create route edge ihg-test-v1 --service=ihg-test-v1
oc expose svc/ihg-test-v1 --hostname=ihg-test-myproject.192.168.42.110.nip.io
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name ihg-test-v1 -l app=ihg-test-v1
oc start-build ihg-test-v1 --from-dir=.

# Create second version
oc create secret generic ihg-test-v2 --from-literal=name=Refdata-v2 --output=yaml --dry-run > ihg-test-v2.yaml
oc create -f ihg-test-v2.yaml
oc process -f ihg-test-template.yml -p APPLICATION_NAME=ihg-test-v2 | oc apply -f -
#oc create route edge ihg-test-v2 --service=ihg-test-v2
oc expose svc/ihg-test-v2 --hostname=ihg-test-myproject.192.168.42.110.nip.io --path=/v2
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name ihg-test-v2 -l app=ihg-test-v2
oc start-build ihg-test-v2 --from-dir=.
