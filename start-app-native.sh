export TMP=$JAVA_TOOL_OPTIONS
export JAVA_TOOL_OPTIONS="-Dperson.name=supertest"
java -jar target/shift-rest-1.0.0-SNAPSHOT.jar --spring.config.location=classpath:file:./application-native.properties
#java -jar target/shift-rest-1.0.0-SNAPSHOT.jar
export JAVA_TOOL_OPTIONS=$TMP
