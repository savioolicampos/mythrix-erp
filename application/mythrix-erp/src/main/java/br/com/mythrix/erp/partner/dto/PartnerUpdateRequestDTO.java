package br.com.mythrix.erp.partner.dto;

import br.com.mythrix.erp.partner.enums.PartnerStatus;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record PartnerUpdateRequestDTO(
        @NotBlank
        @Size(max = 255)
        String name,
        @Email String email,
        @Email String altEmail,
        String mainPhone,
        String altPhone,
        PartnerStatus status,
        Boolean emailOptIn,
        Boolean whatsappOptIn,
        Boolean smsOptIn
)
{}