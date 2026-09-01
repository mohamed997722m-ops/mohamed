allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}
subprojects {
    fun configureJvmTarget() {
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            val javaCompileTask = project.tasks.findByName("compileJava") as? JavaCompile
                ?: project.tasks.findByName("compileDebugJavaWithJavac") as? JavaCompile
                ?: project.tasks.findByName("compileReleaseJavaWithJavac") as? JavaCompile
            val target = javaCompileTask?.targetCompatibility?.toString()
            if (target != null) {
                if (target.contains("17") || target.contains("21")) {
                    compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                } else if (target.contains("11")) {
                    compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
                } else {
                    compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_1_8)
                }
            }
        }
    }

    if (project.state.executed) {
        configureJvmTarget()
    } else {
        project.afterEvaluate {
            configureJvmTarget()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
