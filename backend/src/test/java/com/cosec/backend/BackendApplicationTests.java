package com.cosec.backend;

import com.cosec.backend.controllers.CaffController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class BackendApplicationTests {

    @Autowired
    private CaffController caffController;

    @Test
    void contextLoads() {
        assertThat(caffController).isNotNull();
    }

}
