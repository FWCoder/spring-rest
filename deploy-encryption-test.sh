mvn clean install
oc delete all -l app=ihg-test
oc delete secret ihg-test

oc create secret generic ihg-test --from-literal=name=DK --output=yaml --dry-run > ihg-test.yaml
oc create -f ihg-test.yaml
oc process -f ihg-test-template.yml | oc apply -f -
oc create route edge ihg-test --service=ihg-test
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name ihg-test -l app=ihg-test
oc start-build ihg-test --from-dir=.
