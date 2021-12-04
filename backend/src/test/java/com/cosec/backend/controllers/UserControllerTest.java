package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Role;
import com.cosec.backend.models.RoleType;
import com.cosec.backend.models.User;
import com.cosec.backend.payload.request.Login;
import com.cosec.backend.payload.request.Registration;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.RoleRepository;
import com.cosec.backend.repository.UserRepository;
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
import org.springframework.boot.web.servlet.server.Encoding;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;


@WebMvcTest(UserController.class)
@ContextConfiguration
@WebAppConfiguration
class UserControllerTest {

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
    AuthenticationManager authenticationManager;

    @MockBean
    UserRepository userRepository;

    @MockBean
    RoleRepository roleRepository;

    @MockBean
    PasswordEncoder encoder;

    @MockBean
    JwtUtils jwtUtils;

    @MockBean
    CaffRepository caffRepository;

    @MockBean
    UserDetailsServiceImpl userDetailsService;

    @MockBean
    AuthEntryPointJwt authEntryPointJwt;

    @Test
    void getAll_Success() throws Exception {
        User userOne = new User("userOne", "e@mail.com", "verySecure");
        userOne.setRoles(new HashSet<Role>(Arrays.asList(new Role(RoleType.ROLE_USER))));
        userOne.setId("1");
        User userTwo = new User("userTwo", "admin@mail.com", "canttouchthis");
        userTwo.setRoles(new HashSet<Role>(Arrays.asList(new Role(RoleType.ROLE_ADMIN))));
        userTwo.setId("2");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(userRepository.findAll()).thenReturn(List.of(userOne, userTwo));
        this.mvc.perform(get("/users/admin/all")
                        .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"username\":\"userOne\",\"email\":\"e@mail.com\",\"password\":\"verySecure\",\"roles\":[{\"id\":null,\"name\":\"ROLE_USER\"}]},{\"id\":\"2\",\"username\":\"userTwo\",\"email\":\"admin@mail.com\",\"password\":\"canttouchthis\",\"roles\":[{\"id\":null,\"name\":\"ROLE_ADMIN\"}]}]"));
    }

    @Test
    void getAll_EmptyDB() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(userRepository.findAll()).thenReturn(List.of());
        this.mvc.perform(get("/users/admin/all")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: User database is empty!\"}"));
    }

    @Test
    void getAll_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        this.mvc.perform(get("/users/admin/all")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
   }

    @Test
    void getUserById_Success() throws Exception {
        User userOne = new User("userOne", "e@mail.com", "verySecure");
        userOne.setRoles(new HashSet<Role>(Arrays.asList(new Role(RoleType.ROLE_USER))));
        userOne.setId("1");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(userRepository.existsById("1")).thenReturn(true);
        when(userRepository.findById("1")).thenReturn(Optional.of(userOne));
        this.mvc.perform(get("/users/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"id\":\"1\",\"username\":\"userOne\",\"email\":\"e@mail.com\",\"password\":\"verySecure\",\"roles\":[{\"id\":null,\"name\":\"ROLE_USER\"}]}"));

    }

    @Test
    void getUserById_UserNotFound() throws Exception {
        User userOne = new User("userOne", "e@mail.com", "verySecure");
        userOne.setRoles(new HashSet<Role>(Arrays.asList(new Role(RoleType.ROLE_USER))));
        userOne.setId("1");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(userRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/users/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: User does not exist!\"}"));
        verify(userRepository, never()).findById("1");
    }

    @Test
    void getUserById_Unauthorized() throws Exception {
        User userOne = new User("userOne", "e@mail.com", "verySecure");
        userOne.setRoles(new HashSet<Role>(Arrays.asList(new Role(RoleType.ROLE_USER))));
        userOne.setId("1");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        this.mvc.perform(get("/users/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
        verify(userRepository, never()).existsById("1");
        verify(userRepository, never()).findById("1");
    }

    @Test
    void getCaffsByUserId_Success() throws Exception {
        Caff caffOne = new Caff("1","b",new Binary(new byte[0]));
        Caff caffTwo = new Caff("1","b",new Binary(new byte[0]));
        caffOne.setId("1");
        caffTwo.setId("2");
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        when(userRepository.existsById("1")).thenReturn(true);
        when(caffRepository.getAllByUserId("1")).thenReturn(List.of(caffOne, caffTwo));
        this.mvc.perform(get("/users/auth/1/caffs")
                .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("[{\"id\":\"1\",\"userId\":\"1\",\"name\":\"b\",\"imageUrl\":\"/caffs/unauth/image/1\"},{\"id\":\"2\",\"userId\":\"1\",\"name\":\"b\",\"imageUrl\":\"/caffs/unauth/image/2\"}]"));
    }

    @Test
    void getCaffsByUserId_UserNotFound() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        when(userRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(get("/users/auth/1/caffs")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: User does not exist!\"}"));
    }

    @Test
    void getCaffsByUserId_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl(null, null, null, null, null);
        this.mvc.perform(get("/users/auth/1/caffs")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
        verify(userRepository, never()).existsById("1");
        verify(caffRepository, never()).getAllByUserId("1");
    }

    @Test
    void deleteUserById_Success() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(userRepository.existsById("1")).thenReturn(true);
        this.mvc.perform(delete("/users/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"message\":\"User deleted successfully!\"}"));
        verify(userRepository, times(1)).deleteById("1");
        verify(caffRepository, times(1)).deleteAllByUserId("1");
    }

    @Test
    void deleteUserById_UserNotFound() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        when(userRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(delete("/users/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: User does not exist!\"}"));
        verify(userRepository, never()).deleteById("1");
        verify(caffRepository, never()).deleteAllByUserId("1");
    }

    @Test
    void deleteUserById_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        when(userRepository.existsById("1")).thenReturn(false);
        this.mvc.perform(delete("/users/admin/1")
                        .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
        verify(userRepository, never()).deleteById("1");
        verify(caffRepository, never()).deleteAllByUserId("1");
    }

    @Test
    void updateUserById_Success() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        User param = new User("ASD", "e@mail.com", "aaaaaaaaaaa");
        param.setId("1");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.findById("1")).thenReturn(Optional.of(param));
        when(userRepository.existsById("1")).thenReturn(true);
        when(userRepository.existsByEmail("1")).thenReturn(false);
        when(userRepository.existsByUsername("1")).thenReturn(false);
        this.mvc.perform(put("/users/admin/1")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(param))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"message\":\"User updated successfully!\"}"));
        verify(userRepository, times(1)).save(param);
    }

    @Test
    void updateUserById_Email_Taken() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        User param = new User("ASD", "e@mail.com", "aaaaaaaaaaa");
        param.setId("1");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.findById(param.getId())).thenReturn(Optional.of(param));
        when(userRepository.existsById(param.getId())).thenReturn(true);
        when(userRepository.existsByEmail(param.getEmail())).thenReturn(true);
        when(userRepository.existsByUsername(param.getUsername())).thenReturn(true);
        this.mvc.perform(put("/users/admin/1")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(param))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Email is already in use!\"}"));
        verify(userRepository, never()).save(param);
    }

    @Test
    void updateUserById_UserName_Taken() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        User param = new User("ASD", "e@mail.com", "aaaaaaaaaaa");
        param.setId("1");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.findById(param.getId())).thenReturn(Optional.of(param));
        when(userRepository.existsById(param.getId())).thenReturn(true);
        when(userRepository.existsByEmail(param.getEmail())).thenReturn(false);
        when(userRepository.existsByUsername(param.getUsername())).thenReturn(true);
        this.mvc.perform(put("/users/admin/1")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(param))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Username is already taken!\"}"));
        verify(userRepository, never()).save(param);
    }

    @Test
    void updateUserById_Password_Too_Short() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_ADMIN"));
        User param = new User("ASD", "e@mail.com", "a");
        param.setId("1");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.findById(param.getId())).thenReturn(Optional.of(param));
        when(userRepository.existsById(param.getId())).thenReturn(true);
        when(userRepository.existsByEmail(param.getEmail())).thenReturn(false);
        when(userRepository.existsByUsername(param.getUsername())).thenReturn(false);
        this.mvc.perform(put("/users/admin/1")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(param))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Password should be at least 8 characters long!\"}"));
        verify(userRepository, never()).save(param);
    }

    @Test
    void updateUserById_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        User param = new User("ASD", "e@mail.com", "aaaaaaaaaaa");
        param.setId("1");
        ObjectMapper objectMapper = new ObjectMapper();
        this.mvc.perform(put("/users/admin/1")
                        .with(user(user))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(param))).andDo(print())
                .andExpect(status().isForbidden());
        verify(userRepository, never()).save(param);
    }

    @Test
    void createCaff_Success() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        Path path = Paths.get("test.caff");
        String name = "data";
        String originalFileName = "test.caff";
        String contentType = "*/*";
        byte[] content = null;
        try {
            content = Files.readAllBytes(path);
        } catch (final IOException e) {
        }
        MockMultipartFile result = new MockMultipartFile(name,
                originalFileName, contentType, content);
        this.mvc.perform(
                MockMvcRequestBuilders.multipart("/users/auth/1/caffs")
                .file(result)
                .param("name", "CaffName")
                .with(user(user))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"message\":\"Added Caff to Database, Parse successful!\"}"));
    }

    @Test
    void createCaff_Parse_Error() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl("1", "hasza98", "hasza98@gmail.com", "password", AuthorityUtils.createAuthorityList("ROLE_USER"));
        Path path = Paths.get("sample.gif");
        String name = "data";
        String originalFileName = "test.caff";
        String contentType = "*/*";
        byte[] content = null;
        try {
            content = Files.readAllBytes(path);
        } catch (final IOException e) {
        }
        MockMultipartFile result = new MockMultipartFile(name,
                originalFileName, contentType, content);
        this.mvc.perform(
                        MockMvcRequestBuilders.multipart("/users/auth/1/caffs")
                                .file(result)
                                .param("name", "CaffName")
                                .with(user(user))).andDo(print())
                .andExpect(status().isBadRequest());
    }

    @Test
    void createCaff_Unauthorized() throws Exception {
        UserDetailsImpl user = new UserDetailsImpl(null, null, null, null, null);
        Path path = Paths.get("sample.gif");
        String name = "data";
        String originalFileName = "test.caff";
        String contentType = "*/*";
        byte[] content = null;
        try {
            content = Files.readAllBytes(path);
        } catch (final IOException e) {
        }
        MockMultipartFile result = new MockMultipartFile(name,
                originalFileName, contentType, content);
        this.mvc.perform(
                        MockMvcRequestBuilders.multipart("/users/auth/1/caffs")
                                .file(result)
                                .param("name", "CaffName")
                                .with(user(user))).andDo(print())
                .andExpect(status().isForbidden());
    }

    @Test
    void authenticateUser_Success() throws Exception {
        /*
        Login login = new Login();
        login.setUsername("userName1");
        login.setPassword("aaaaaaaaaa");
        User user = new User(login.getUsername(),"evmail.hu",login.getPassword());
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(login.getUsername())).thenReturn(true);
        when(userRepository.findByUsername(login.getUsername())).thenReturn(Optional.of(user));
        when(encoder.matches(login.getPassword() ,userRepository.findByUsername(login.getUsername()).get().getPassword())).thenReturn(true);
        this.mvc.perform(post("/users/unauth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(login))).andDo(print())
                .andExpect(status().isOk());

         */
    }

    @Test
    void authenticateUser_UserNameNotFound() throws Exception {
        Login login = new Login();
        login.setUsername("userName1");
        login.setPassword("aaaaaaaaaa");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(login.getUsername())).thenReturn(false);
        this.mvc.perform(post("/users/unauth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(login))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Username is not found\"}"));
    }

    @Test
    void authenticateUser_PasswordIncorrect() throws Exception {
        Login login = new Login();
        login.setUsername("userName1");
        login.setPassword("aaaaaaaaaa");
        User user = new User(login.getUsername(),"evmail.hu",login.getPassword());
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(login.getUsername())).thenReturn(true);
        when(userRepository.findByUsername(login.getUsername())).thenReturn(Optional.of(user));
        when(encoder.matches(login.getPassword() ,userRepository.findByUsername(login.getUsername()).get().getPassword())).thenReturn(false);
        this.mvc.perform(post("/users/unauth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(login))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Password is incorrect\"}"));
    }

    @Test
    void registerUser_Success() throws Exception {
        Registration reg = new Registration("UserName1","e@mail.hu", null, "LongPassword");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(reg.getUsername())).thenReturn(false);
        when(userRepository.existsByEmail(reg.getEmail())).thenReturn(false);
        when(roleRepository.findByName(RoleType.ROLE_USER)).thenReturn(Optional.of(new Role(RoleType.ROLE_USER)));
        this.mvc.perform(post("/users/unauth/registration")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(reg))).andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().string("{\"message\":\"User registered successfully!\"}"));
    }

    @Test
    void registerUser_UserName_Taken() throws Exception {
        Registration reg = new Registration("UserName1","e@mail.hu", null, "LongPassword");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(reg.getUsername())).thenReturn(true);
        this.mvc.perform(post("/users/unauth/registration")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(reg))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Username is already taken!\"}"));
    }

    @Test
    void registerUser_Email_Taken() throws Exception {
        Registration reg = new Registration("UserName1","e@mail.hu", null, "LongPassword");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(reg.getUsername())).thenReturn(false);
        when(userRepository.existsByEmail(reg.getEmail())).thenReturn(true);
        this.mvc.perform(post("/users/unauth/registration")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(reg))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Email is already in use!\"}"));
    }

    @Test
    void registerUser_Password_TooShort() throws Exception {
        Registration reg = new Registration("UserName1","e@mail.hu", null, "shortpp");
        ObjectMapper objectMapper = new ObjectMapper();
        when(userRepository.existsByUsername(reg.getUsername())).thenReturn(false);
        when(userRepository.existsByEmail(reg.getEmail())).thenReturn(false);
        when(roleRepository.findByName(RoleType.ROLE_USER)).thenReturn(Optional.of(new Role(RoleType.ROLE_USER)));
        this.mvc.perform(post("/users/unauth/registration")
                        .contentType(MediaType.APPLICATION_JSON)
                        .characterEncoding(Encoding.DEFAULT_CHARSET)
                        .content(objectMapper.writeValueAsString(reg))).andDo(print())
                .andExpect(status().isBadRequest())
                .andExpect(content().string("{\"message\":\"Error: Password should be at least 8 characters long!\"}"));

    }
}