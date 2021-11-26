package com.cosec.backend.controllers;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import com.cosec.backend.models.User;
import com.cosec.backend.repository.CaffRepository;
import com.cosec.backend.repository.CommentRepository;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/all")
    public List<Caff> getAll(){
        List<Caff> caffs = this.caffRepository.findAll();
        return caffs;
    }

    @GetMapping("/{id}")
    public Optional<Caff> getCaffById(@PathVariable("id") String id){
        Optional<Caff> caff = this.caffRepository.findById(id);
        return caff;
    }

    @GetMapping("/{id}/comments")
    public List<Comment> getAllComment(@PathVariable("id") String id){
        List<Comment> comments = this.commentRepository.findAllByCaffId(id);
        return comments;
    }

    @DeleteMapping("/{id}")
    public void deleteCaffById(@PathVariable("id") String id){
        this.caffRepository.deleteById(id);
        this.commentRepository.deleteAllByCaffId(id);
    }

    @DeleteMapping("/comments/{commentId}")
    public void deleteCommentById(@PathVariable("commentId") String commentId){
        this.commentRepository.deleteById(commentId);
    }

}
