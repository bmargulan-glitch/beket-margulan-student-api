package kz.iitu.beket.studentapi;

import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import kz.iitu.beket.studentapi.repository.StudentRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

@SpringBootTest
@AutoConfigureMockMvc
class StudentControllerTest {

    private static final String URL = "/api/beket-margulan/students";
    private static final String MARGULAN = """
            {"firstName":"Margulan","lastName":"Beket",
             "email":"margulan.beket@iitu.edu.kz","groupName":"it2-2302"}
            """;

    @Autowired
    private MockMvc mvc;

    @Autowired
    private StudentRepository repository;

    @BeforeEach
    void clean() {
        repository.deleteAll();
    }

    private long createMargulan() throws Exception {
        MvcResult result = mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content(MARGULAN))
                .andExpect(status().isCreated())
                .andReturn();
        String body = result.getResponse().getContentAsString();
        return Long.parseLong(body.replaceAll(".*\"id\":(\\d+).*", "$1"));
    }

    @Test
    void createsStudentWithMyName() throws Exception {
        mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content(MARGULAN))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.firstName").value("Margulan"))
                .andExpect(jsonPath("$.lastName").value("Beket"));
    }

    @Test
    void returnsAllStudents() throws Exception {
        createMargulan();
        mvc.perform(get(URL)).andExpect(status().isOk()).andExpect(jsonPath("$", hasSize(1)));
    }

    @Test
    void returnsStudentById() throws Exception {
        long id = createMargulan();
        mvc.perform(get(URL + "/" + id))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.email").value("margulan.beket@iitu.edu.kz"));
    }

    @Test
    void updatesStudent() throws Exception {
        long id = createMargulan();
        String updated = MARGULAN.replace("it2-2302", "it2-2302-updated");
        mvc.perform(put(URL + "/" + id).contentType(MediaType.APPLICATION_JSON).content(updated))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.groupName").value("it2-2302-updated"));
    }

    @Test
    void deletesStudent() throws Exception {
        long id = createMargulan();
        mvc.perform(delete(URL + "/" + id)).andExpect(status().isNoContent());
        mvc.perform(get(URL + "/" + id)).andExpect(status().isNotFound());
    }

    @Test
    void returns404ForMissingStudent() throws Exception {
        mvc.perform(get(URL + "/99999"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.message").value("Student with id 99999 not found"));
    }

    @Test
    void rejectsDuplicateEmail() throws Exception {
        createMargulan();
        mvc.perform(post(URL).contentType(MediaType.APPLICATION_JSON).content(MARGULAN))
                .andExpect(status().isConflict());
    }

    @Test
    void infoShowsStudentName() throws Exception {
        mvc.perform(get("/api/beket-margulan/info"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.student").value("Wrong Name"));
    }
}
