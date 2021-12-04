package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import com.cosec.backend.models.User;
import com.cosec.backend.payload.response.CaffResponse;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.CommentRepository;
import com.cosec.backend.security.jwt.AuthEntryPointJwt;
import com.cosec.backend.security.jwt.JwtUtils;
import com.cosec.backend.security.services.UserDetailsImpl;
import com.cosec.backend.security.services.UserDetailsServiceImpl;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.bson.types.Binary;
import org.json.JSONArray;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import javax.validation.constraints.Max;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.internal.bytebuddy.matcher.ElementMatchers.is;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(CaffController.class)
@ContextConfiguration
@WebAppConfiguration
class CaffControllerTest {

    @Autowired
    private WebApplicationContext context;

    private MockMvc mvc;

    @BeforeEach
    public void setup() {
        mvc = MockMvcBuilders
                .webAppContextSetup(context)
                .apply(springSecurity())
                .build();
    }

    @MockBean
    CaffRepository caffRepository;

    @MockBean
    CommentRepository commentRepository;

    @MockBean
    UserDetailsServiceImpl userDetailsService;

    @MockBean
    AuthEntryPointJwt authEntryPointJwt;

    @MockBean
    JwtUtils jwtUtils;

    @Test
    void getAll_Success() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        Caff caffTwo = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        caffTwo.setId("2");
        when(caffRepository.findAll()).thenReturn(List.of(caffOne, caffTwo));
        this.mvc.perform(get("/caffs/unauth/all")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"userId\":\"a\",\"name\":\"b\",\"imageUrl\":\"http://localhost:8080/caffs/unauth/image/1\"},{\"id\":\"2\",\"userId\":\"a\",\"name\":\"b\",\"imageUrl\":\"http://localhost:8080/caffs/unauth/image/2\"}]"));
    }

    @Test
    void getAll_DB_IsEmpty() throws Exception {
        when(caffRepository.findAll()).thenReturn(List.of());
        this.mvc.perform(get("/caffs/unauth/all")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff database is empty!\"}"));
    }

    @Test
    void getCaffById_Success() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(true);
        when(caffRepository.findById("1")).thenReturn(Optional.of(caffOne));
        this.mvc.perform(get("/caffs/unauth/1")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"id\":\"1\",\"userId\":\"a\",\"name\":\"b\",\"imageUrl\":\"http://localhost:8080/caffs/unauth/image/1\"}"));
    }

    @Test
    void getCaffById_CaffDoesntExist() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/1")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    @Test
    void downloadCaffById_Success() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary("ADAT".getBytes(StandardCharsets.UTF_8)));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(true);
        when(caffRepository.findById("1")).thenReturn(Optional.of(caffOne));
        this.mvc.perform(get("/caffs//unauth/1/download")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.parseMediaType(MediaType.MULTIPART_MIXED_VALUE)))
                .andExpect(header().string(HttpHeaders.CONTENT_DISPOSITION,"attachment; filename=b\""))
                .andExpect(content().string("ADAT"));
    }

    @Test
    void downloadCaffById_CaffDoesntExist() throws Exception {
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/1")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    @Test
    void searchCaffByName_Success() throws Exception {
        Caff caffOne = new Caff("a","SomeName",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsByName("SomeName")).thenReturn(true);
        when(caffRepository.findByName("SomeName")).thenReturn(List.of(caffOne));
        this.mvc.perform(get("/caffs/unauth/search").param("name", "SomeName")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"userId\":\"a\",\"name\":\"SomeName\",\"imageUrl\":\"http://localhost:8080/caffs/unauth/image/1\"}]"));
    }

    @Test
    void searchCaffByName_CaffnotFound() throws Exception {
        when(caffRepository.existsByName("SomeName")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/search").param("name", "SomeName")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist with this name!\"}"));
    }

    @Test
    void getAllComment_Success() throws Exception {
        Comment comm1 = new Comment("1", "2", "1", "Comment");
        Comment comm2 = new Comment("2", "3", "1", "Other Comment");
        when(caffRepository.existsById("1")).thenReturn(true);
        when(commentRepository.findAllByCaffId("1")).thenReturn(List.of(comm1, comm2));
        this.mvc.perform(get("/caffs/unauth/1/comments")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"userId\":\"2\",\"caffId\":\"1\",\"text\":\"Comment\"},{\"id\":\"2\",\"userId\":\"3\",\"caffId\":\"1\",\"text\":\"Other Comment\"}]"));
    }

    @Test
    void getAllComment_CaffnotFound() throws Exception {
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/1/comments")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    @Test
    void createComment_Success() throws Exception {
        Comment comm1 = new Comment( "2", "1", "Comment");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        ObjectMapper objectMapper = new ObjectMapper();
        when(caffRepository.existsById("1")).thenReturn(true);
        this.mvc.perform(post("/caffs/auth/comments")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(comm1))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"id\":null,\"userId\":\"2\",\"caffId\":\"1\",\"text\":\"Comment\"}"));
    }

    @Test
    void createComment_CaffnotFound() throws Exception {
        Comment comm1 = new Comment( "2", "1", "Comment");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        ObjectMapper objectMapper = new ObjectMapper();
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(post("/caffs/auth/comments")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(comm1))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    @Test
    void createComment_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl(null, null, null, null, null);
        this.mvc.perform(post("/caffs/auth/comments")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    @Test
    void deleteCaffById_Success() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(caffRepository.existsById("1")).thenReturn(true);
        this.mvc.perform(delete("/caffs/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"message\":\"Caff deleted successfully!\"}"));
        verify(caffRepository, times(1)).deleteById("1");
        verify(commentRepository,times(1)).deleteAllByCaffId("1");
    }

    @Test
    void deleteCaffById_CaffnotFound() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(delete("/caffs/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    @Test
    void deleteCaffById_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        this.mvc.perform(delete("/caffs/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    @Test
    void deleteCommentById_Success() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(commentRepository.existsById("1")).thenReturn(true);
        this.mvc.perform(delete("/caffs/admin/comments/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"message\":\"Comment deleted successfully!\"}"));
        verify(commentRepository, times(1)).deleteById("1");
    }

    @Test
    void deleteCommentById_CommentNotFound() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(commentRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(delete("/caffs/admin/comments/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Comment does not exist!\"}"));
        verify(commentRepository, never()).deleteById("1");
    }

    @Test
    void deleteCommentById_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        this.mvc.perform(delete("/caffs/admin/comments/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    @Test
    void getCaffImage_Success() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(true);
        when(caffRepository.findById("1")).thenReturn(Optional.of(caffOne));
        this.mvc.perform(get("/caffs/unauth/image/1")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.parseMediaType(MediaType.IMAGE_GIF_VALUE)))
                .andExpect(header().string(HttpHeaders.CONTENT_DISPOSITION,"attachment; filename=\"" + caffOne.getName() + ".gif\""));
    }

    @Test
    void getCaffImage_CaffNotFound() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/image/1")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
        verify(caffRepository, never()).findById(caffOne.getId());
    }
}