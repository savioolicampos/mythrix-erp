package br.com.mythrix.erp.partner.dto;

import br.com.mythrix.erp.media.dto.MediaFileResponseDTO;
import br.com.mythrix.erp.partner.enums.PartnerDocumentType;
import br.com.mythrix.erp.partner.enums.PartnerPersonType;
import br.com.mythrix.erp.partner.enums.PartnerStatus;

import java.time.LocalDateTime;

public record PartnerResponseDTO(
        Integer id,
        String name,
        String document,
        PartnerDocumentType documentType,
        String email,
        String altEmail,
        String mainPhone,
        String altPhone,
        PartnerStatus status,
        PartnerPersonType personType,
        Boolean emailOptIn,
        Boolean whatsappOptIn,
        Boolean smsOptIn,
        MediaFileResponseDTO mediaFile,
        LocalDateTime updatedAt,
        LocalDateTime createdAt
)
{}