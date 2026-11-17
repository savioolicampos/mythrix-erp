package br.com.mythrix.erp.partner.repository;

import br.com.mythrix.erp.partner.entity.Partner;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PartnerRepository extends JpaRepository<Partner, Integer> {
    boolean existsByDocument(String document);
}