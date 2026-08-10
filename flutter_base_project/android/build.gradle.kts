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

// Một số plugin cũ (vd isar_flutter_libs) chỉ khai báo package qua
// AndroidManifest.xml, không có `namespace` trong build.gradle — AGP 9
// không còn tự suy ra namespace từ manifest nên build sẽ fail. Tự set lại
// namespace từ manifest cho các module còn thiếu để không phải patch pub-cache.
// Phải đăng ký TRƯỚC evaluationDependsOn(":app") vì lệnh đó buộc Gradle
// evaluate ngay các project — đăng ký afterEvaluate sau đó sẽ bị lỗi
// "project is already evaluated".
subprojects {
    afterEvaluate {
        val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        if (android != null && android.namespace == null) {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val packageName = Regex("package=\"([^\"]+)\"")
                    .find(manifestFile.readText())
                    ?.groupValues
                    ?.get(1)
                if (packageName != null) {
                    android.namespace = packageName
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
