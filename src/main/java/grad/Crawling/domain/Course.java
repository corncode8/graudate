package grad.Crawling.domain;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Data
public class Course {
    private String 이수구분;
    private String 학수번호;
    private String     교과목명;
    private String 교과목영문명;
    private String   학점;
    private String   이론;
    private String   실습;

    public void addCourse(Map<String, Object> Data) {
        this.이수구분 = (String) Data.get("이수구분");
        this.학수번호 = (String) Data.get("학수번호");
        this.교과목명 = (String) Data.get("교과목명");
        this.교과목영문명 = (String) Data.get("교과목 영문명");
        this.학점 = (String) Data.get("학점");
        this.이론 = (String) Data.get("이론");
        this.실습 = (String) Data.get("실습");
    }

    public String get이수구분() {
        return 이수구분;
    }

    public void set이수구분(String 이수구분) {
        this.이수구분 = 이수구분;
    }

    public String get학수번호() {
        return 학수번호;
    }

    public void set학수번호(String 학수번호) {
        this.학수번호 = 학수번호;
    }

    public String get교과목명() {
        return 교과목명;
    }

    public void set교과목명(String 교과목명) {
        this.교과목명 = 교과목명;
    }

    public String get교과목영문명() {
        return 교과목영문명;
    }

    public void set교과목영문명(String 교과목영문명) {
        this.교과목영문명 = 교과목영문명;
    }

    public String get학점() {
        return 학점;
    }

    public void set학점(String 학점) {
        this.학점 = 학점;
    }

    public String get이론() {
        return 이론;
    }

    public void set이론(String 이론) {
        this.이론 = 이론;
    }

    public String get실습() {
        return 실습;
    }

    public void set실습(String 실습) {
        this.실습 = 실습;
    }
}

