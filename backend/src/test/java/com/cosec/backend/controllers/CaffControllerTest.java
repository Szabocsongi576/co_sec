package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.CommentRepository;
import com.cosec.backend.security.jwt.AuthEntryPointJwt;
import com.cosec.backend.security.jwt.JwtUtils;
import com.cosec.backend.security.services.UserDetailsImpl;
import com.cosec.backend.security.services.UserDetailsServiceImpl;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.bson.types.Binary;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
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

    /**
     * Description:
     *      Checking if getting all the Caffs from the db returns correct response.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return the list of Caff's.
     * Request:
     *      GET(/caffs/unauth/all)
     * Input:
     *      -
     * Expected output:
     *      List of Caffs, which have been wrapped with CaffResponse.
     */
    @Test
    void getAll_Success() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        Caff caffTwo = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        caffTwo.setId("2");
        when(caffRepository.findAll()).thenReturn(List.of(caffOne, caffTwo));
        this.mvc.perform(get("/caffs/unauth/all")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"userId\":\"a\",\"name\":\"b\",\"imageUrl\":\"/caffs/unauth/image/1\"},{\"id\":\"2\",\"userId\":\"a\",\"name\":\"b\",\"imageUrl\":\"/caffs/unauth/image/2\"}]"));
    }

    /**
     * Description:
     *      Checking if getting from empty db returns the correct error.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return the list of Caff's. Which is 0.
     * Request:
     *      GET(/caffs/unauth/all)
     * Input:
     *      -
     * Expected output:
     *      Bad request, with message: Caff database is empty!
     */
    @Test
    void getAll_DB_IsEmpty() throws Exception {
        when(caffRepository.findAll()).thenReturn(List.of());
        this.mvc.perform(get("/caffs/unauth/all")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff database is empty!\"}"));
    }

    /**
     * Description:
     *      Checking if getting a Caff by its ID returns the Caff.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for checking existence of the Caff.
     *      Upon searching for the caff, it should return the Caff as an optional value.
     * Request:
     *      GET(/caffs/unauth/1)
     * Input:
     *      Path Parameter ID (1)
     * Expected output:
     *      Caff object wrapped in CaffResponse class.
     */
    @Test
    void getCaffById_Success() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(true);
        when(caffRepository.findById("1")).thenReturn(Optional.of(caffOne));
        this.mvc.perform(get("/caffs/unauth/1")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"id\":\"1\",\"userId\":\"a\",\"name\":\"b\",\"imageUrl\":\"/caffs/unauth/image/1\"}"));
    }

    /**
     * Description:
     *      Checking if getting a Caff by its ID, when Caff with specified ID doesnt exist.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding the caff.
     * Request:
     *      GET(/caffs/unauth/1)
     * Input:
     *      Path Parameter ID (1)
     * Expected output:
     *      Bad request, with message: Caff does not exist!
     */
    @Test
    void getCaffById_CaffDoesntExist() throws Exception {
        Caff caffOne = new Caff("a","b",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/1")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    /**
     * Description:
     *      Checking if downloading a Caff by its ID, returns the file.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for finding the caff.
     *      Upon findById it should return the Caff wrapped as Optional.
     * Request:
     *      GET(/caffs/unauth/1/download)
     * Input:
     *      Path Parameter ID (1)
     * Expected output:
     *      The File returned in the response as a Multipart File (Signaled in header).
     */
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

    /**
     * Description:
     *      Checking if downloading a Caff by its ID, returns an error, when the Caff doesnt exist.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding the caff.
     * Request:
     *      GET(/caffs/unauth/1/download)
     * Input:
     *      Path Parameter ID (1)
     * Expected output:
     *      Bad request, with message: Caff does not exist!
     */
    @Test
    void downloadCaffById_CaffDoesntExist() throws Exception {
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/1")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    /**
     * Description:
     *      Checking if searching for a Caffs by its Name, returns the correct Caffs.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for finding any caffs.
     *      Upon findByName it should return the List of Caffs.
     * Request:
     *      GET(/caffs/unauth/search)
     * Input:
     *      Request Parameter name (SomeName)
     * Expected output:
     *      A List of Caffs/Caff with the matching name wrapped in CaffResponse Objects.
     */
    @Test
    void searchCaffByName_Success() throws Exception {
        Caff caffOne = new Caff("a","SomeName",new Binary(new byte[0]));
        caffOne.setId("1");
        when(caffRepository.existsByName("SomeName")).thenReturn(true);
        when(caffRepository.findByName("SomeName")).thenReturn(List.of(caffOne));
        this.mvc.perform(get("/caffs/unauth/search").param("name", "SomeName")).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"userId\":\"a\",\"name\":\"SomeName\",\"imageUrl\":\"/caffs/unauth/image/1\"}]"));
    }

    /**
     * Description:
     *      Checking if searching for a Caffs by its Name, returns the correct error if the name doesnt exist.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding any caffs.
     * Request:
     *      GET(/caffs/unauth/search)
     * Input:
     *      Request Parameter name (SomeName)
     * Expected output:
     *      Bad request, with message: Caff does not exist with this name!
     */
    @Test
    void searchCaffByName_CaffnotFound() throws Exception {
        when(caffRepository.existsByName("SomeName")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/search").param("name", "SomeName")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist with this name!\"}"));
    }

    /**
     * Description:
     *      Checking if getting all the Comments for a given Caff returns the Comments.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for finding the caff with the specified id.
     *      CommentRepository is mocked, it should return the List of Comments for the given Caff.
     * Request:
     *      GET(/caffs/unauth/1/comments)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      List of Comments, that belong to the specified Caff. (CaffId = 1)
     */
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

    /**
     * Description:
     *      Checking if getting all the Comments for a given Caff returns error, if the Caff doesnt exist
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding the caff with the specified id.
     * Request:
     *      GET(/caffs/unauth/1/comments)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Bad request, with message: Caff does not exist !
     */
    @Test
    void getAllComment_CaffnotFound() throws Exception {
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/caffs/unauth/1/comments")).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }

    /**
     * Description:
     *      Checking if creating a comment for a Caff gets saved in the Database.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for finding the caff with the specified id.
     *      User must be logged in.
     * Request:
     *      POST(/caffs/auth/comments)
     * Input:
     *      Request Body Comment (comm1)
     * Expected output:
     *      The created comment returned.
     */
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

    /**
     * Description:
     *      Checking if creating a comment for a Caff returns the correct error if the Caff doesnt exist.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding the caff with the specified id.
     *      User must be logged in.
     * Request:
     *      POST(/caffs/auth/comments)
     * Input:
     *      Request Body Comment (comm1)
     * Expected output:
     *      Bad request, with message: Caff does not exist !
     */
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

    /**
     * Description:
     *      Checking if unauthorized user is unable to create a comment.
     * Mock Restrictions:
     *      -
     * Request:
     *      GET(/caffs/auth/comments)
     * Input:
     *      -
     * Expected output:
     *      Forbidden Response Value.
     */
    @Test
    void createComment_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl(null, null, null, null, null);
        this.mvc.perform(post("/caffs/auth/comments")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    /**
     * Description:
     *      Checking if deleting a Caff has the correct effect on the Database, and returns the correct response.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for finding the caff with the specified id.
     *      User must be logged in. User must have ADMIN role.
     * Request:
     *      DELETE(/caffs/admin/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Ok, with message: Caff deleted successfully!
     *      CaffRepository.deleteById Called only once with argument "1"
     *      CommentRepository.deleteAllByCaffId Called only once with argument "1"
     */
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

    /**
     * Description:
     *      Checking if deleting a Caff returns the correct error if the Caff doesnt exist.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding the caff with the specified id.
     *      User must be logged in. User must have ADMIN role.
     * Request:
     *      DELETE(/caffs/admin/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Bad request, with message: Caff does not exist !
     */
    @Test
    void deleteCaffById_CaffnotFound() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(caffRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(delete("/caffs/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Caff does not exist!\"}"));
    }
    /**
     * Description:
     *      Checking if deleting a Caff returns the correct error if the User is not authorized.
     * Mock Restrictions:
     *      -
     * Request:
     *      DELETE(/caffs/admin/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Forbidden Response Value.
     */
    @Test
    void deleteCaffById_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        this.mvc.perform(delete("/caffs/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    /**
     * Description:
     *      Checking if deleting a Comment has the correct effect on the Database, and returns the correct response.
     * Mock Restrictions:
     *      CommentRepository is mocked, it should return true for finding the comment.
     *      User must be logged in. User must have ADMIN role.
     * Request:
     *      DELETE(/caffs/admin/coments/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Ok, with message: Comment deleted successfully!
     *      commentRepository.deleteById Called only once with argument "1"
     */
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

    /**
     * Description:
     *      Checking if deleting a Comment by Id returns the correct error, if the comment doesnt exist.
     * Mock Restrictions:
     *      CommentRepository is mocked, it should return false for finding the comment.
     *      User must be logged in. User must have ADMIN role.
     * Request:
     *      DELETE(/caffs/admin/coments/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Bad request, with message: Comment does not exist!
     *      commentRepository.deleteById never called with argument "1"
     */
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

    /**
     * Description:
     *      Checking if deleting a Comment by Id returns the correct error, if the user is not authorized.
     * Mock Restrictions:
     *      -
     * Request:
     *      DELETE(/caffs/admin/coments/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Forbidden Response Value.
     */
    @Test
    void deleteCommentById_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        this.mvc.perform(delete("/caffs/admin/comments/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    /**
     * Description:
     *      Checking if getting the parsed image of the given caff returns the image.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return true for finding the caff with the specified id.
     *      Upon finding it, it should return the caff wrapped as Optional.
     * Request:
     *      GET(/caffs/unauth/image/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Image in the response, indicated in the headers.
     */
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

    /**
     * Description:
     *      Checking if getting the parsed image of the given caff returns the correct error, if the caff with the id doesnt exist.
     * Mock Restrictions:
     *      CaffRepository is mocked, it should return false for finding the caff with the specified id.
     * Request:
     *      GET(/caffs/unauth/image/1)
     * Input:
     *      Path parameter ID (1)
     * Expected output:
     *      Bad request, with message: Caff does not exist!
     *      caffRepository.findById never called with argument "1"
     */
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