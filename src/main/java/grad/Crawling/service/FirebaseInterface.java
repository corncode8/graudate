package grad.Crawling.service;

import grad.Crawling.domain.Course;
import grad.Crawling.domain.Coursev2;


public interface FirebaseInterface {
    public String insertSubject(Course course, String docname,String college,String department) throws Exception;
    String insertSubjectver2(Coursev2 course, String docname, String college, String department) throws Exception;
    public String CreateDoc(String docname,String college,String department) throws Exception;

    //public String insertSubject(Selsubject subject, String docname) throws Exception;
    //public String updateSubject(Subject subject) throws Exception;
    //public String deleteSubject(String id) throws Exception;
}
