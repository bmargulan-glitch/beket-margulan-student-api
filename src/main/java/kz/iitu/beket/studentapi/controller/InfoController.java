package kz.iitu.beket.studentapi.controller;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InfoController {

    @Value("${app.version}")
    private String version;

    @GetMapping({"/", "/api/beket-margulan/info"})
    public Map<String, String> info() {
        Map<String, String> info = new LinkedHashMap<>();
        info.put("application", "beket-margulan-student-api");
        info.put("student", "Beket Margulan");
        info.put("group", "it2-2302");
        info.put("studentId", "38109");
        info.put("version", version);
        return info;
    }
}
