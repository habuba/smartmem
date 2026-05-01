## Java toolchain
- JDK: 17+ (pin in `.tool-versions` / `.sdkmanrc`)
- Build: Maven or Gradle
- Format: `spotless`
- Test: JUnit 5 + AssertJ
- LSP: `jdtls` (eclipse.jdt.ls)

## Commands
- Build: `./mvnw verify`  _or_  `./gradlew build`
- Test: `./mvnw test`  _or_  `./gradlew test`
- Format: `./mvnw spotless:apply`
