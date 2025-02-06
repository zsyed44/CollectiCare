plugins {
	java
	id("org.springframework.boot") version "3.4.2"
	id("io.spring.dependency-management") version "1.1.7"
}

group = "com.example"
version = "0.0.1-SNAPSHOT"

java {
	toolchain {
		languageVersion = JavaLanguageVersion.of(17)
	}
}

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-web")
	developmentOnly("org.springframework.boot:spring-boot-devtools")

	// Update to OrientDB 3.2.21 which has better Java 17 compatibility
	implementation("com.orientechnologies:orientdb-graphdb:3.2.21") {
		exclude(group = "org.codehaus.groovy", module = "groovy")
		exclude(group = "org.codehaus.groovy", module = "groovy-jsr223")
	}

	// Use Groovy 4.x which is designed for Java 17+
	implementation("org.apache.groovy:groovy:4.0.15")
	implementation("org.apache.groovy:groovy-jsr223:4.0.15")

	testImplementation("org.springframework.boot:spring-boot-starter-test")
}


tasks.withType<Test> {
	useJUnitPlatform()
}

configurations.all {
	resolutionStrategy {
		force("org.apache.groovy:groovy:4.0.15")
		force("org.apache.groovy:groovy-jsr223:4.0.15")
	}
}
