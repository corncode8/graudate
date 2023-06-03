package grad.Crawling.service;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.WriteResult;
import com.google.firebase.cloud.FirestoreClient;
import grad.Crawling.domain.Course;
import grad.Crawling.domain.Coursev2;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;

@Service
public class FirebaseService implements FirebaseInterface {
    public static final String sample = "sample";
    LocalDate now = LocalDate.now();
    int nowyear = now.getYear();
    String year = String.valueOf(nowyear);

    @Override
    public String CreateDoc(String docname,String college,String department){
        Firestore firestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> apiFuture = firestore.collection("대학").document("경상대학교2").collection("단과대학")
                .document(college).collection("학과").document(department).collection("년도")
                .document(year).collection("학기").document(docname).set(new HashMap<>());


        try {
            return apiFuture.get().getUpdateTime().toString();
        } catch (InterruptedException | ExecutionException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public String insertSubject(Course course, String docname,String college,String department){

        Firestore firestore = FirestoreClient.getFirestore();
        Map<String, Object> courseData = new HashMap<>();

        courseData.put("이수구분", course.get이수구분());
        courseData.put("학수번호", course.get학수번호());
        courseData.put("교과목명", course.get교과목명());
        courseData.put("교과목 영문명", course.get교과목영문명());
        courseData.put("학점", course.get학점());
        courseData.put("이론", course.get이론());
        courseData.put("실습", course.get실습());

        ApiFuture<WriteResult> apiFuture = firestore.collection("대학").document("경상대학교2").collection("단과대학")
                .document(college).collection("학과").document(department).collection("년도")
                .document(year).collection("학기")
                .document(docname).update(course.get교과목명(), courseData);
        try {
            return apiFuture.get().getUpdateTime().toString();
        } catch (InterruptedException | ExecutionException e) {
            throw new RuntimeException(e);
        }
    }


    @Override
    public String insertSubjectver2(Coursev2 course, String docname, String college, String department){

        Firestore firestore = FirestoreClient.getFirestore();
        Map<String, Object> courseData = new HashMap<>();

        courseData.put("이수구분", course.get이수구분());
        courseData.put("학수번호", course.get학수번호());
        courseData.put("교과목명", course.get교과목명());
        courseData.put("교과목 영문명", course.get교과목영문명());
        courseData.put("학점", course.get학점());

        ApiFuture<WriteResult> apiFuture = firestore.collection("대학").document("경상대학교2").collection("단과대학")
                .document(college).collection("학과").document(department).collection("년도")
                .document(year).collection("학기")
                .document(docname).update(course.get교과목명(), courseData);
        try {
            return apiFuture.get().getUpdateTime().toString();
        } catch (InterruptedException | ExecutionException e) {
            throw new RuntimeException(e);
        }
    }



//    @Override
//    public String updateSubject(Subject subject) throws Exception {
//        Firestore firestore = FirestoreClient.getFirestore();
//        ApiFuture<WriteResult> apiFuture = "업데이트 하고자 하는 경로"
//        return apiFuture.get().getUpdateTime().toString();
//    }
//    @Override
//    public String deleteSubject(String id) throws Exception {
//        Firestore firestore = FirestoreClient.getFirestore();
//        ApiFuture<WriteResult> apiFuture
//                = firestore.collection().document(id).delete();
//        return "Document id : " + id + "delete";
//
//    }
}
