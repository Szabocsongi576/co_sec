package com.cosec.backend.repository;

import com.cosec.backend.models.Role;
import com.cosec.backend.models.RoleType;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface RoleRepository extends MongoRepository<Role, String> {
    Optional<Role> findByName(RoleType name);
}
