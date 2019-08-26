mvn clean install
oc delete all -l app=ihg-test
oc delete secret ihg-test

oc create secret generic ihg-folder-test --from-file=./test_folder/ --output=yaml --dry-run > ihg-folder-test.yaml
oc create -f ihg-folder-test.yaml
oc process -f ihg-test-template.yml | oc apply -f -
oc create route edge ihg-test --service=ihg-test
oc new-build --strategy docker --binary --docker-image openjdk:8-jdk-alpine --name ihg-test -l app=ihg-test
oc start-build ihg-test --from-dir=.
rm ihg-folder-test.yaml
