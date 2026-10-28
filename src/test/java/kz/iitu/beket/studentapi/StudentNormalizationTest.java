package kz.iitu.beket.studentapi;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class StudentNormalizationTest {

    @Autowired
    private MockMvc mvc;

    @Test
    void createTrimsNamesAndLowercasesEmail() throws Exception {
        String body = """
                {"firstName":"  Margulan ","lastName":" Beket ",
                 "email":"Margulan.NORMALIZE@IITU.edu.kz","groupName":"it2-2302"}
                """;
        mvc.perform(post("/api/beket-margulan/students").contentType(MediaType.APPLICATION_JSON).content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.firstName").value("Margulan"))
                .andExpect(jsonPath("$.email").value("margulan.normalize@iitu.edu.kz"));
    }
}
