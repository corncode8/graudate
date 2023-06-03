package grad.Crawling.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.context.annotation.Configuration;


import javax.annotation.PostConstruct;
import java.io.FileInputStream;
import java.io.InputStream;

@Configuration
public class FirestoreConfig {
    @PostConstruct
    public void init(){
        try{
            InputStream serviceAccount =
                    new FileInputStream("src/main/resources/gnu-graduate-p1-firebase.json");
            GoogleCredentials credentials = GoogleCredentials.fromStream(serviceAccount);
            FirebaseOptions options = new FirebaseOptions.Builder()
                    .setCredentials(credentials)
                    .build();
            FirebaseApp.initializeApp(options);
            Firestore db = FirestoreClient.getFirestore();
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}