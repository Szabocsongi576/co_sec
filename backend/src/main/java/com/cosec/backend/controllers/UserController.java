package com.cosec.backend.controllers;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;
import java.util.stream.Collectors;

import javax.validation.Valid;

import com.cosec.backend.models.*;
import com.cosec.backend.payload.request.CaffRequest;
import com.cosec.backend.payload.request.Login;
import com.cosec.backend.payload.request.Registration;
import com.cosec.backend.payload.response.JwtResponse;
import com.cosec.backend.payload.response.MessageResponse;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.RoleRepository;
import com.cosec.backend.repository.UserRepository;
import com.cosec.backend.security.jwt.JwtUtils;
import com.cosec.backend.security.services.UserDetailsImpl;
import org.bson.BsonBinarySubType;
import org.bson.types.Binary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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
    public List<User> getAll(){
        logger.info(String.format("ADMIN %s(%s) requested all Users.",getCurrentUser().getUsername(),getCurrentUser().getId()));
        List<User> users = this.userRepository.findAll();
        return users;
    }

    @GetMapping("/admin/{id}")
    public Optional<User> getUserById(@PathVariable("id") String id){
        logger.info(String.format("ADMIN %s(%s) requested User(%s)'s data.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        Optional<User> user = this.userRepository.findById(id);
        return user;
    }

    @GetMapping("/auth/{id}/caffs")
    public List<Caff> getCaffsByUserId(@PathVariable("id") String id){
        logger.info(String.format("USER %s(%s) requested Caffs of User(%s).",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        List<Caff> caffs = this.caffRepository.getAllByUserId(id);
        return caffs;
    }

    @DeleteMapping("/admin/{id}")
    public void deleteUserById(@PathVariable("id") String id){
        logger.info(String.format("ADMIN %s(%s) deleted User(%s).",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        this.userRepository.deleteById(id);
        this.caffRepository.deleteAllByUserId(id);
    }

    @PutMapping("/admin/{id}")
    public void updateUserById(@PathVariable("id") String id, @Valid @RequestBody User userDetails){
        if(userRepository.existsById(userDetails.getId())) {
            userRepository.save(userDetails);
            logger.info(String.format("ADMIN %s(%s) updated User(%s).",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        }
        else{
            logger.info(String.format("ADMIN %s(%s) try to update User(%s), but User does not exist.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        }
    }

    @PostMapping("/auth/{id}/caffs/")
    public ResponseEntity<?> createCaff(@PathVariable("id") String id,  @ModelAttribute CaffRequest paramCaff){
        logger.info(String.format("USER %s(%s) created Caff.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
        Caff newCaff = new Caff(id,paramCaff);
        caffRepository.save(newCaff);
        return ResponseEntity
                .ok()
                .body(new MessageResponse("Added Caff to Database!"));
    }

    @PostMapping("/unauth/login")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody Login loginRequest) {

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
}