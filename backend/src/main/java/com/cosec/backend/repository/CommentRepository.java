package com.cosec.backend.repository;

import com.cosec.backend.models.Caff;
import com.cosec.backend.models.Comment;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface CommentRepository extends MongoRepository<Comment, String> {

    Optional<Comment> findById(String id);

    List<Comment> findAllByCaffId(String caffId);

    List<Comment> findAllByCaffIdAndId(String caffId, String commentId);

    void deleteAllByCaffId(String caffId);
}