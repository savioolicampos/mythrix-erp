package br.com.mythrix.erp.media.repository;

import br.com.mythrix.erp.media.entity.MediaFile;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MediaFileRepository extends JpaRepository<MediaFile, Integer> {

}