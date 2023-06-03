package grad.Crawling.crawl;

import grad.Crawling.config.FirestoreConfig;
import grad.Crawling.domain.Coursev2;
import grad.Crawling.service.FirebaseService;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class sophiaCrawl {
    static String docname;

    public static void main(String[] args) {

        FirebaseService firebaseService = new FirebaseService();

        // Firestore 데이터베이스 초기화
        FirestoreConfig firestoreConfig = new FirestoreConfig();
        firestoreConfig.init();

        // 데이터 크롤링
        try {
            Document doc = Jsoup.connect("https://www.gnu.ac.kr/sophia/cm/cntnts/cntntsView.do?mi=3265&cntntsId=2163").get();
            Element table = doc.select("div.tbl_st.scroll_gr table").get(0);
            Elements rows = table.select("tr");
            String collage = "인문대학";
            String department = "철학과";

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
                    Coursev2 coursev2 = new Coursev2();
                    Map<String, Object> Data = new HashMap<>();
                    if (rowData.length == 6) {
                        //System.out.println(Arrays.toString(rowData));
                        docname = rowData[0];
                        firebaseService.CreateDoc(docname, collage, department);

                        Data.put("이수구분", rowData[1]);
                        Data.put("학수번호", rowData[2]);
                        Data.put("교과목명", rowData[3]);
                        Data.put("교과목 영문명", rowData[4]);
                        Data.put("학점", rowData[5]);

                    } else {
                        //System.out.println(Arrays.toString(rowData));
                        Data.put("이수구분", rowData[0]);
                        Data.put("학수번호", rowData[1]);
                        Data.put("교과목명", rowData[2]);
                        Data.put("교과목 영문명", rowData[3]);
                        Data.put("학점", rowData[4]);
                    }
                    coursev2.addCourse(Data);
                    firebaseService.insertSubjectver2(coursev2, docname, collage, department);
                }
            }
            System.out.println("데이터 저장 완료 ");
        } catch (IOException e) {
            System.err.println("데이터 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
