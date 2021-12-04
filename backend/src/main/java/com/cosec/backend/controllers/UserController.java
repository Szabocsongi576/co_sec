package com.cosec.backend.controllers;

import java.io.*;
import java.util.*;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import java.util.stream.Collectors;

import javax.validation.Valid;

import com.cosec.backend.models.*;
import com.cosec.backend.payload.request.CaffRequest;
import com.cosec.backend.payload.request.Login;
import com.cosec.backend.payload.request.Registration;
import com.cosec.backend.payload.response.CaffResponse;
import com.cosec.backend.payload.response.JwtResponse;
import com.cosec.backend.payload.response.MessageResponse;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.RoleRepository;
import com.cosec.backend.repository.UserRepository;
import com.cosec.backend.security.jwt.JwtUtils;
import com.cosec.backend.security.services.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*", maxAge = 3600)
@RestController
@RequestMapping("/users")
public class UserController {

    Logger logger = Logger.getLogger("MyLog");
    FileHandler fh;


    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    UserRepository userRepository;

    @Autowired
    RoleRepository roleRepository;

    @Autowired
    PasswordEncoder encoder;

    @Autowired
    JwtUtils jwtUtils;

    @Autowired
    CaffRepository caffRepository;

    UserController() throws IOException {
        fh = new FileHandler("C:/work/UserController.log");
        logger.addHandler(fh);
        SimpleFormatter formatter = new SimpleFormatter();
        fh.setFormatter(formatter);
    }

    private UserDetailsImpl getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (UserDetailsImpl) authentication.getPrincipal();
    }

    @GetMapping("/admin/all")
    public ResponseEntity<?> getAll(){
        logger.info(String.format("ADMIN %s(%s) requested all Users.",getCurrentUser().getUsername(),getCurrentUser().getId()));
        List<User> users = this.userRepository.findAll();
        if(users.size() == 0) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: User database is empty!"));
        }
        return ResponseEntity
                .ok()
                .body(users);
    }

    @GetMapping("/admin/{id}")
    public ResponseEntity<?> getUserById(@PathVariable("id") String id){
        logger.info(String.format("ADMIN %s(%s) requested User(%s)'s data.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        if(!userRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: User does not exist!"));
        }

        Optional<User> user = this.userRepository.findById(id);
        return ResponseEntity
                .ok()
                .body(user);
    }

    @GetMapping("/auth/{id}/caffs")
    public ResponseEntity<?> getCaffsByUserId(@PathVariable("id") String id){
        logger.info(String.format("USER %s(%s) requested Caffs of User(%s).",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        if(!userRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: User does not exist!"));
        }

        List<Caff> caffs = this.caffRepository.getAllByUserId(id);
        List<CaffResponse> responseList = new ArrayList<>();
        for (Caff caff : caffs) {
            responseList.add(new CaffResponse(caff));
        }
        return ResponseEntity
                .ok()
                .body(responseList);
    }

    @DeleteMapping("/admin/{id}")
    public ResponseEntity<?> deleteUserById(@PathVariable("id") String id){
        if(!userRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: User does not exist!"));
        }
        logger.info(String.format("ADMIN %s(%s) deleted User(%s).",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        this.userRepository.deleteById(id);
        this.caffRepository.deleteAllByUserId(id);
        return ResponseEntity
                .ok()
                .body(new MessageResponse("User deleted successfully!"));
    }

    @PutMapping("/admin/{id}")
    public ResponseEntity<?> updateUserById(@PathVariable("id") String id, @Valid @RequestBody User userDetails){
        if(userRepository.existsById(id)) {
            User toEdit = userRepository.findById(id).get();
            if(userDetails.getEmail() != null)
                if (userRepository.existsByEmail(userDetails.getEmail())) {
                    return ResponseEntity
                            .badRequest()
                            .body(new MessageResponse("Error: Email is already in use!"));
                }
                toEdit.setEmail(userDetails.getEmail());
            if(userDetails.getUsername() != null)
                if (userRepository.existsByUsername(userDetails.getUsername())) {
                    return ResponseEntity
                            .badRequest()
                            .body(new MessageResponse("Error: Username is already taken!"));
                }
                toEdit.setUsername(userDetails.getUsername());
            if(userDetails.getPassword() != null)
                if((userDetails.getPassword().length() < 8)) {
                return ResponseEntity
                        .badRequest()
                        .body(new MessageResponse("Error: Password should be at least 8 characters long!"));
                }
                toEdit.setPassword(encoder.encode(userDetails.getPassword()));
            if(userDetails.getRoles().size() != 0)
                toEdit.setRoles(userDetails.getRoles());
            userRepository.save(toEdit);
            logger.info(String.format("ADMIN %s(%s) updated User(%s).",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
            return ResponseEntity
                    .ok()
                    .body(new MessageResponse("User updated successfully!"));
        }
        else{
            logger.info(String.format("ADMIN %s(%s) try to update User(%s), but User does not exist.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: User does not exist!"));
        }
    }

    @PostMapping("/auth/{id}/caffs")
    public ResponseEntity<?> createCaff(@PathVariable("id") String id,  @ModelAttribute CaffRequest paramCaff){
        logger.info(String.format("USER %s(%s) created Caff.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        Caff newCaff = new Caff(id,paramCaff);
        String message = CheckCaff(newCaff);
        if(!message.equals("Parse successful."))
        {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse(message));
        }
        else {
            caffRepository.save(newCaff);
            return ResponseEntity
                    .ok()
                    .body(new MessageResponse("Added Caff to Database, Parse successful!"));
        }
    }

    @PostMapping("/unauth/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody Login loginRequest) {

        if (!userRepository.existsByUsername(loginRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username is not found"));
        }

        if(!(encoder.matches(loginRequest.getPassword() ,userRepository.findByUsername(loginRequest.getUsername()).get().getPassword()))){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Password is incorrect"));
        }

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        String jwt = jwtUtils.generateJwtToken(authentication);

        UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
        List<String> roles = userDetails.getAuthorities().stream()
                .map(item -> item.getAuthority())
                .collect(Collectors.toList());

        return ResponseEntity.ok(new JwtResponse(jwt,
                userDetails.getId(),
                userDetails.getUsername(),
                userDetails.getEmail(),
                roles));
    }

    @PostMapping("/unauth/registration")
    public ResponseEntity<?> registerUser(@Valid @RequestBody Registration signUpRequest) {
        if (userRepository.existsByUsername(signUpRequest.getUsername())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Username is already taken!"));
        }

        if (userRepository.existsByEmail(signUpRequest.getEmail())) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Email is already in use!"));
        }

        if (signUpRequest.getPassword().length() < 8) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Password should be at least 8 characters long!"));
        }

        // Create new user's account
        User user = new User(signUpRequest.getUsername(),
                signUpRequest.getEmail(),
                encoder.encode(signUpRequest.getPassword()));

        Set<String> strRoles = signUpRequest.getRoles();
        Set<Role> roles = new HashSet<>();

        if (strRoles == null) {
            Role userRole = roleRepository.findByName(RoleType.ROLE_USER)
                    .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
            roles.add(userRole);
        } else {
            strRoles.forEach(role -> {
                switch (role) {
                    case "admin":
                        Role adminRole = roleRepository.findByName(RoleType.ROLE_ADMIN)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(adminRole);

                        break;

                    default:
                        Role userRole = roleRepository.findByName(RoleType.ROLE_USER)
                                .orElseThrow(() -> new RuntimeException("Error: Role is not found."));
                        roles.add(userRole);
                }
            });
        }

        user.setRoles(roles);
        userRepository.save(user);

        return ResponseEntity.ok(new MessageResponse("User registered successfully!"));
    }

    public String CheckCaff(Caff caff) {
        StringBuilder retVal = new StringBuilder();
        try {
            FileOutputStream outputStream = new FileOutputStream( "check.caff");
            outputStream.write(caff.getData().getData());
            outputStream.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
        try {
            File parser = new ClassPathResource("parser/parser.exe").getFile();
            if (parser.exists()) {
                try {
                    ProcessBuilder pb = new ProcessBuilder(parser.getAbsolutePath(), "check.caff");
                    pb.redirectError();
                    Process p = pb.start();
                    InputStream is = p.getInputStream();
                    int value = -1;
                    while ((value = is.read()) != -1) {
                        System.out.print((char) value);
                        retVal.append((char) value);
                    }
                    int exitCode = p.waitFor();
                    return retVal.toString();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                System.err.println(parser.getAbsolutePath() + " does not exist");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return retVal.toString();
    }
}