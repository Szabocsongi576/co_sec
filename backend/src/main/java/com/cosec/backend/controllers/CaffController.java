package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import com.cosec.backend.payload.response.CaffResponse;
import com.cosec.backend.payload.response.MessageResponse;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.CommentRepository;
import com.cosec.backend.security.services.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.io.*;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Optional;
import java.util.logging.FileHandler;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
@RequestMapping("caffs")
public class CaffController {

    Logger logger = Logger.getLogger("MyLog");
    FileHandler fh;

    @Autowired
    private CaffRepository caffRepository;
    @Autowired
    private CommentRepository commentRepository;

    public CaffController(CaffRepository caffRepository,CommentRepository commentRepository) throws IOException {
        this.caffRepository = caffRepository;
        this.commentRepository = commentRepository;
        fh = new FileHandler("C:/work/CaffController.log");
        logger.addHandler(fh);
        SimpleFormatter formatter = new SimpleFormatter();
        fh.setFormatter(formatter);
    }

    private UserDetailsImpl getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (UserDetailsImpl) authentication.getPrincipal();
    }

    @GetMapping("/unauth/all")
    public ResponseEntity<?> getAll(){
        List<Caff> caffs = this.caffRepository.findAll();
        if(caffs.size() == 0){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff database is empty!"));
        }
        else {
            List<CaffResponse> responseList = new ArrayList<>();

            for (Caff caff : caffs) {
                responseList.add(new CaffResponse(caff));
            }
            return ResponseEntity
                    .ok()
                    .body(responseList);
        }
    }

    @GetMapping("/unauth/{id}")
    public ResponseEntity<?> getCaffById(@PathVariable("id") String id){

        if(!caffRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist!"));
        }
        else {
            Optional<Caff> caff = this.caffRepository.findById(id);
            return ResponseEntity
                    .ok()
                    .body(new CaffResponse(caff.get()));
        }
    }

    @GetMapping("/unauth/{id}/download")
    public ResponseEntity<?> downloadCaffById(@PathVariable("id") String id){
        if(!caffRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist!"));
        }
        else {
            Optional<Caff> caff = this.caffRepository.findById(id);
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(MediaType.MULTIPART_MIXED_VALUE))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + caff.get().getName() + "\"")
                    .body(caff.get().getData().getData());
        }
    }

    @GetMapping("/unauth/search")
    public ResponseEntity<?> searchCaffByName(@Valid @RequestParam String name){
        if(!caffRepository.existsByName(name)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist with this name!"));
        }
        else {
            List<Caff> caffs = this.caffRepository.findByName(name);
            List<CaffResponse> responseList = new ArrayList<>();
            for (Caff caff : caffs) {
                responseList.add(new CaffResponse(caff));
            }
            return ResponseEntity
                    .ok()
                    .body(responseList);
        }
    }

    @GetMapping("/unauth/{id}/comments")
    public ResponseEntity<?> getAllComment(@PathVariable("id") String id){
        if(!caffRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist!"));
        }
        else {
            List<Comment> comments = this.commentRepository.findAllByCaffId(id);
            return ResponseEntity
                    .ok()
                    .body(comments);
        }
    }

    @PostMapping("/auth/comments")
    public ResponseEntity<?> createComment(@RequestBody Comment comment){
        if(!caffRepository.existsById(comment.getCaffId())){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist!"));
        }
        else {
            logger.info(String.format("USER %s(%s) Created Comment(%s)",getCurrentUser().getUsername(),getCurrentUser().getId(),comment.getId()));
            this.commentRepository.save(comment);
            return ResponseEntity
                    .ok()
                    .body(comment);
        }
    }

    @DeleteMapping("/admin/{id}")
    public ResponseEntity<?> deleteCaffById(@PathVariable("id") String id){
        if(!caffRepository.existsById(id)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist!"));
        }
        else {
            logger.info(String.format("ADMIN %s(%s) Deleted Caff(%s) and related comments.",getCurrentUser().getUsername(),getCurrentUser().getId(),id));
            this.caffRepository.deleteById(id);
            this.commentRepository.deleteAllByCaffId(id);
            return ResponseEntity
                    .ok()
                    .body(new MessageResponse("Caff deleted successfully!"));
        }
    }

    @DeleteMapping("/admin/comments/{commentId}")
    public ResponseEntity<?> deleteCommentById(@PathVariable("commentId") String commentId){
        if(!commentRepository.existsById(commentId)){
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Comment does not exist!"));
        }
        else {
            logger.info(String.format("ADMIN %s(%s) Deleted Comment(%s)", getCurrentUser().getUsername(), getCurrentUser().getId(), commentId));
            this.commentRepository.deleteById(commentId);
            return ResponseEntity
                    .ok()
                    .body(new MessageResponse("Comment deleted successfully!"));
        }
    }

    @GetMapping("/unauth/image/{caffId}")
    public ResponseEntity<?> getCaffImage(@PathVariable String caffId) {
        if(!this.caffRepository.existsById(caffId)) {
            return ResponseEntity
                    .badRequest()
                    .body(new MessageResponse("Error: Caff does not exist!"));
        }
        else {
            Optional<Caff> caff = this.caffRepository.findById(caffId);
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(MediaType.IMAGE_GIF_VALUE))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + caff.get().getName() + ".gif\"")
                    .body(parseCaff(caff.get()));
        }
    }

    private String parseCaff(Caff caff) {
        String retVal ="";
        try {
            FileOutputStream outputStream = new FileOutputStream( "sample.caff");
            outputStream.write(caff.getData().getData());
            outputStream.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
        try {
            File parser = new ClassPathResource("parser/parser.exe").getFile();
            if (parser.exists()) {
                try {
                    ProcessBuilder pb = new ProcessBuilder(parser.getAbsolutePath(), "sample.caff");
                    pb.redirectError();
                    Process p = pb.start();
                    InputStream is = p.getInputStream();
                    int value = -1;
                    while ((value = is.read()) != -1) {
                        System.out.print((char) value);
                    }
                    int exitCode = p.waitFor();
                    System.out.println(parser.getAbsolutePath() + " exited with " + exitCode);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                System.err.println(parser.getAbsolutePath() + " does not exist");
            }
            try (
                    InputStream inputStream = new FileInputStream("sample.gif");
            ) {
                long fileSize = new File("sample.gif").length();

                byte[] allBytes = new byte[(int) fileSize];

                inputStream.read(allBytes);
                retVal = Base64.getEncoder().encodeToString(allBytes);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return retVal;
    }
}
