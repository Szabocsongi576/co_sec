package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.CommentRepository;
import org.bson.types.Binary;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
@RequestMapping("caffs")
public class CaffController {

    private CaffRepository caffRepository;
    private CommentRepository commentRepository;

    public CaffController(CaffRepository caffRepository) {
        this.caffRepository = caffRepository;
    }

    @GetMapping("/unauth/all")
    public List<Caff> getAll(){
        List<Caff> caffs = this.caffRepository.findAll();
        return caffs;
    }

    @GetMapping("/unauth/{id}")
    public Optional<Caff> getCaffById(@PathVariable("id") String id){
        Optional<Caff> caff = this.caffRepository.findById(id);
        return caff;
    }

    @GetMapping("/unauth/{id}/download")
    public Binary downloadCaffById(@PathVariable("id") String id){
        Optional<Caff> caff = this.caffRepository.findById(id);
        return caff.get().getData();
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

}
