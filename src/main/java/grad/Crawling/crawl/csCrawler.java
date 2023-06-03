package grad.Crawling.crawl;

import grad.Crawling.config.FirestoreConfig;
import grad.Crawling.domain.Course;
import grad.Crawling.service.FirebaseService;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class csCrawler {
    static String docname;

    public static void main(String[] args) {

        FirebaseService firebaseService = new FirebaseService();

        // Firestore 데이터베이스 초기화
        FirestoreConfig firestoreConfig = new FirestoreConfig();
        firestoreConfig.init();

        // 데이터 크롤링
        try {
            Document doc = Jsoup.connect("https://www.gnu.ac.kr/cs/cm/cntnts/cntntsView.do?mi=12857&cntntsId=6081").get();
            Element table = doc.select("div.tbl_st.scroll_gr table").get(1);
            Elements rows = table.select("tr");
            String collage = "자연과학대학";
            String department = "컴퓨터과학과";

            ArrayList<String[]> tableData = new ArrayList<String[]>();

            if (rows != null) {
                for (int i = 1; i < rows.size(); i++) {
                    Element row = rows.get(i);
                    Elements cells = row.select("td");

                    if (cells.size() > 3) { // 첫 번째 행 무시
                        String[] rowData = new String[cells.size() - 1];

                        for (int j = 0; j < cells.size() - 1; j++) {
                            rowData[j] = cells.get(j).text();
                        }

                        tableData.add(rowData);
                    }
                }
                for (String[] rowData : tableData) {
                    Course course = new Course();
                    Map<String, Object> Data = new HashMap<>();
                    if (rowData.length == 8) {
                        //System.out.println(Arrays.toString(rowData));
                        docname = rowData[0];
                        firebaseService.CreateDoc(docname, collage, department);

                        Data.put("이수구분", rowData[1]);
                        Data.put("학수번호", rowData[2]);
                        Data.put("교과목명", rowData[3]);
                        Data.put("교과목 영문명", rowData[4]);
                        Data.put("학점", rowData[5]);
                        Data.put("이론", rowData[6]);
                        Data.put("실습", rowData[7]);

                    } else {
                        //System.out.println(Arrays.toString(rowData));
                        Data.put("이수구분", rowData[0]);
                        Data.put("학수번호", rowData[1]);
                        Data.put("교과목명", rowData[2]);
                        Data.put("교과목 영문명", rowData[3]);
                        Data.put("학점", rowData[4]);
                        Data.put("이론", rowData[5]);
                        Data.put("실습", rowData[6]);
                    }
                    course.addCourse(Data);
                    firebaseService.insertSubject(course, docname, collage, department);
                }
            }
            System.out.println("데이터 저장 완료 ");
        } catch (IOException e) {
            System.err.println("데이터 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}