package kz.iitu.beket.studentapi;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class StudentApiApplication {

    private static final Logger log = LoggerFactory.getLogger(StudentApiApplication.class);

    public static void main(String[] args) {
        SpringApplication.run(StudentApiApplication.class, args);
    }

    @Bean
    CommandLineRunner startupBanner() {
        return args -> log.info("Student API by Beket Margulan (it2-2302, ID 38109) started");
    }
}
