package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import com.cosec.backend.payload.response.CaffResponse;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
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

    public CaffController() throws IOException {
        fh = new FileHandler("C:/work/MyLogFile.log");
        logger.addHandler(fh);
        SimpleFormatter formatter = new SimpleFormatter();
        fh.setFormatter(formatter);
    }

    @GetMapping("/unauth/all")
    public List<CaffResponse> getAll(){
        List<Caff> caffs = this.caffRepository.findAll();
        List<CaffResponse> responseList = new ArrayList<>();
         for (Caff caff : caffs) {
             responseList.add(new CaffResponse(caff));
         }
        return responseList;
    }

    @GetMapping("/unauth/{id}")
    public Optional<Caff> getCaffById(@PathVariable("id") String id){
        Optional<Caff> caff = this.caffRepository.findById(id);
        return caff;
    }

    @GetMapping("/unauth/{id}/download")
    public ResponseEntity<?> downloadCaffById(@PathVariable("id") String id){
        Optional<Caff> caff = this.caffRepository.findById(id);
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(MediaType.MULTIPART_MIXED_VALUE))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + caff.get().getName() + "\"")
                .body(caff.get().getData().getData());
    }

    @GetMapping("/unauth/search")
    public List<Caff> searchCaffByName(@Valid @RequestBody String name){
        List<Caff> caffs = this.caffRepository.findByName(name);
        return caffs;
    }

    @GetMapping("/unauth/{id}/comments")
    public List<Comment> getAllComment(@PathVariable("id") String id){
        List<Comment> comments = this.commentRepository.findAllByCaffId(id);
        return comments;
    }

    @PostMapping("/auth/comments")
    public Comment createComment(@RequestBody Comment comment){
        this.commentRepository.save(comment);
        return comment;
    }

    @DeleteMapping("/admin/{id}")
    public void deleteCaffById(@PathVariable("id") String id){
        this.caffRepository.deleteById(id);
        this.commentRepository.deleteAllByCaffId(id);
    }

    @DeleteMapping("/admin/comments/{commentId}")
    public void deleteCommentById(@PathVariable("commentId") String commentId){
        this.commentRepository.deleteById(commentId);
    }

    @GetMapping("/unauth/image/{caffId}")
    public ResponseEntity<?> getCaffImage(@PathVariable String caffId) {
        Caff caff = this.caffRepository.findById(caffId).get();
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(MediaType.IMAGE_GIF_VALUE))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + caff.getName() + ".gif\"")
                .body(parseCaff(caff));
    }

    public String parseCaff(Caff caff) {
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
