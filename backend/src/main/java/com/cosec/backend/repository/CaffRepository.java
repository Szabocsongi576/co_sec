package com.cosec.backend.repository;

import com.cosec.backend.models.Caff;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface CaffRepository extends MongoRepository<Caff, String> {

    Optional<Caff> findById(String id);

    void deleteAllByUserId(String userId);

    List<Caff> getAllByUserId(String userId);

    List<Caff> findByName(String name);

    boolean existsByName(String name);
}
