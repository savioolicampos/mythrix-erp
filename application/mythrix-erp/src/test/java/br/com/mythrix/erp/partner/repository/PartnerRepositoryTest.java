package br.com.mythrix.erp.partner.repository;

import br.com.mythrix.erp.media.entity.MediaFile;
import br.com.mythrix.erp.media.repository.MediaFileRepository;
import br.com.mythrix.erp.partner.entity.Partner;
import br.com.mythrix.erp.partner.enums.PartnerDocumentType;
import br.com.mythrix.erp.partner.enums.PartnerPersonType;
import br.com.mythrix.erp.partner.enums.PartnerStatus;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class PartnerRepositoryTest {
    @Autowired
    private PartnerRepository partnerRepository;

    @Autowired
    private MediaFileRepository mediaFileRepository;

    @Test
    void shouldSavePartner() {
        MediaFile mediaFile = new MediaFile();
        mediaFile.setStorageKey("D:\\Sávio Campos\\Mythrix\\Mythrix ERP\\media\\partners");
        mediaFile.setOriginalFilename("tecken.png");
        mediaFile.setContentType("image/png");
        mediaFile.setSizeBytes(5568877L);

        MediaFile savedMediaFile = mediaFileRepository.save(mediaFile);

        Partner partner = new Partner();
        partner.setName("Tecken - Insumos para sublimação e transfer");
        partner.setDocument("54090107000105");
        partner.setDocumentType(PartnerDocumentType.CNPJ);
        partner.setEmail("atendimento@tecken.com.br");
        partner.setAltEmail("atendimento@tecken.com.br");
        partner.setMainPhone("6134354444");
        partner.setAltPhone("6134354444");
        partner.setStatus(PartnerStatus.A);
        partner.setPersonType(PartnerPersonType.LE);
        partner.setEmailOptIn(true);
        partner.setWhatsappOptIn(true);
        partner.setSmsOptIn(true);
        partner.setMediaFile(mediaFile);
        partner.setLastUpdatedInfo("alt_email = null; alt_phone = null");

        Partner savedPartner = partnerRepository.save(partner);
        assertNotNull(savedPartner.getId());
    }
}