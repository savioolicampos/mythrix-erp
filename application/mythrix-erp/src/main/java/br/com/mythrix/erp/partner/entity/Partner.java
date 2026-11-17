package br.com.mythrix.erp.partner.entity;

import br.com.mythrix.erp.media.entity.MediaFile;
import br.com.mythrix.erp.partner.enums.PartnerDocumentType;
import br.com.mythrix.erp.partner.enums.PartnerPersonType;
import br.com.mythrix.erp.partner.enums.PartnerStatus;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDateTime;

/**
 * Representa um parceiro cadastrado no sistema Mythrix ERP.
 *
 * Armazena informações de identificação, contato, classificação
 * e preferências de comunicação do parceiro.
 */

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "partner")
public class Partner {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @NotBlank
    @Size(max = 200)
    @Column(nullable = false, length = 200)
    private String name;

    @NotBlank
    @Size(max = 18)
    @Column(nullable = false, unique = true, length = 14)
    private String document;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "document_type", nullable = false, length = 4)
    private PartnerDocumentType documentType;

    @Email
    @Size(max = 255)
    private String email;

    @Email
    @Size(max = 255)
    @Column(name = "alt_email")
    private String altEmail;

    @Size(max = 25)
    @Column(name = "main_phone", length = 25)
    private String mainPhone;

    @Size(max = 25)
    @Column(name = "alt_phone", length = 25)
    private String altPhone;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private PartnerStatus status;

    @NotNull
    @Enumerated(EnumType.STRING)
    @Column(name = "person_type", nullable = false, length = 2)
    private PartnerPersonType personType;

    @NotNull
    @Column(name = "email_opt_in", nullable = false)
    private boolean emailOptIn;

    @NotNull
    @Column(name = "whatsapp_opt_in", nullable = false)
    private boolean whatsappOptIn;

    @NotNull
    @Column(name = "sms_opt_in", nullable = false)
    private boolean smsOptIn;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "media_file_id", unique = true)
    private MediaFile mediaFile;

    @Column(name = "created_at", insertable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at", insertable = false, updatable = false)
    private LocalDateTime updatedAt;

    @Column(name = "last_updated_info")
    private String lastUpdatedInfo;
}