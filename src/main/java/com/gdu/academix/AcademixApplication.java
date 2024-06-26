package com.gdu.academix;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling //스케줄러활성화
public class AcademixApplication {

	public static void main(String[] args) {
		SpringApplication.run(AcademixApplication.class, args);
	}

}
