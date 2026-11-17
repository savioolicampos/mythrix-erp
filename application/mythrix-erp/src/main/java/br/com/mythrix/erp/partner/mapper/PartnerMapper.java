package br.com.mythrix.erp.partner.mapper;

import br.com.mythrix.erp.media.dto.MediaFileResponseDTO;
import br.com.mythrix.erp.media.entity.MediaFile;
import br.com.mythrix.erp.partner.dto.PartnerRequestDTO;
import br.com.mythrix.erp.partner.dto.PartnerResponseDTO;
import br.com.mythrix.erp.partner.dto.PartnerUpdateRequestDTO;
import br.com.mythrix.erp.partner.entity.Partner;
import org.mapstruct.*;

@Mapper(componentModel = "spring")
public interface PartnerMapper {
    @Mapping(target = "document", ignore = true)
    @Mapping(target = "status", source = "status", defaultExpression = "java(PartnerStatus.A)")
    @Mapping(target = "emailOptIn", defaultExpression = "java(false)")
    @Mapping(target = "whatsappOptIn", defaultExpression = "java(false)")
    @Mapping(target = "smsOptIn", defaultExpression = "java(false)")
    @Mapping(target = "mediaFile", ignore = true)
    Partner toPartner(PartnerRequestDTO request);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updatePartnerFromDTO(PartnerUpdateRequestDTO request, @MappingTarget Partner partner);

    PartnerResponseDTO toResponseDTO(Partner partner);

    MediaFileResponseDTO toMediaFileResponseDTO(MediaFile mediaFile);
}