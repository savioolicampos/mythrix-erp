package br.com.mythrix.erp.partner.dto;

import br.com.mythrix.erp.partner.enums.PartnerDocumentType;
import br.com.mythrix.erp.partner.enums.PartnerPersonType;
import br.com.mythrix.erp.partner.enums.PartnerStatus;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record PartnerRequestDTO(
        @NotBlank
        @Size(max = 200)
        String name,

        @NotBlank
        @Size(max = 18)
        String document,

        @NotNull
        PartnerDocumentType documentType,

        @Email
        @Size(max = 255)
        String email,

        @Email
        @Size(max = 255)
        String altEmail,

        @Size(max = 25)
        String mainPhone,

        @Size(max = 25)
        String altPhone,

        PartnerStatus status,

        @NotNull
        PartnerPersonType personType,

        Boolean emailOptIn,

        Boolean whatsappOptIn,

        Boolean smsOptIn,

        Integer mediaFileId
) {}