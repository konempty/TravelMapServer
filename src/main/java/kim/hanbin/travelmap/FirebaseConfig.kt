package kim.hanbin.travelmap

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import org.springframework.context.annotation.Configuration
import java.io.FileInputStream
import javax.annotation.PostConstruct


@Configuration
open class FirebaseConfig {

    @PostConstruct
    fun initFirebase() {

        val serviceAccount = FileInputStream("/TravelMap/gps-tracker-303405-firebase-adminsdk-2latv-c3a13203fb.json")

        val options = FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
            .build()

        FirebaseApp.initializeApp(options)

    }
}