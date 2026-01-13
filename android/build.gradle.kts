allprojects {
    repositories {
        google()
        mavenCentral()
    }
    subprojects {
        project.configurations.all {
            resolutionStrategy.eachDependency {
                if (requested.group == "com.github.bumptech.glide" && requested.name.contains("glide")) {
                    useVersion("4.15.1")
                }
            }
        }
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

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
