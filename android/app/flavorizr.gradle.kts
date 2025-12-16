import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("delivery") {
            dimension = "flavor-type"
            applicationId = "com.flutter.deligo_delivery"
            resValue("string", "app_name", "Deligo Delivery") 
    }
}
}
