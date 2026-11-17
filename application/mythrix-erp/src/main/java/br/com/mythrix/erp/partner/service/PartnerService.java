package br.com.mythrix.erp.partner.service;

import br.com.mythrix.erp.media.entity.MediaFile;
import br.com.mythrix.erp.media.exception.MediaFileNotFoundException;
import br.com.mythrix.erp.media.repository.MediaFileRepository;
import br.com.mythrix.erp.partner.dto.PartnerRequestDTO;
import br.com.mythrix.erp.partner.dto.PartnerResponseDTO;
import br.com.mythrix.erp.partner.dto.PartnerUpdateRequestDTO;
import br.com.mythrix.erp.partner.entity.Partner;
import br.com.mythrix.erp.partner.exception.InvalidPartnerDocumentException;
import br.com.mythrix.erp.partner.exception.PartnerAlreadyExistsException;
import br.com.mythrix.erp.partner.exception.PartnerNotFoundException;
import br.com.mythrix.erp.partner.mapper.PartnerMapper;
import br.com.mythrix.erp.partner.repository.PartnerRepository;
import br.com.mythrix.erp.validation.DocumentValidator;
import jakarta.persistence.EntityManager;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class PartnerService {
    private final PartnerRepository partnerRepository;
    private final MediaFileRepository mediaFileRepository;
    private final EntityManager entityManager;
    private final PartnerMapper partnerMapper;

    @Transactional(readOnly = true)
    public Page<PartnerResponseDTO> listPartners(Pageable pageable) {
        Page<Partner> partners = partnerRepository.findAll(pageable);

        return partners.map(partnerMapper::toResponseDTO);
    }

    @Transactional(readOnly = true)
    public PartnerResponseDTO findPartnerById(Integer id) {

        return partnerRepository.findById(id)
                .map(partnerMapper::toResponseDTO)
                .orElseThrow(() -> new PartnerNotFoundException("Não foi encontrado parceiro com ID=" + id + "."));
    }

    @Transactional
    public PartnerResponseDTO savePartner(PartnerRequestDTO partnerRequest) {
        String document = validateAndNormalizeDocument(partnerRequest);

        if (partnerRepository.existsByDocument(document)) {
            throw new PartnerAlreadyExistsException("Já existe um parceiro cadastrado com este documento.");
        }

        MediaFile mediaFile = findMediaFile(partnerRequest.mediaFileId());

        Partner partner = partnerMapper.toPartner(partnerRequest);

        // Atribui os campos tratados individualmente pelo serviço e são ignorados pelo Mapper.
        partner.setDocument(document);
        partner.setMediaFile(mediaFile);

        Partner savedPartner = partnerRepository.save(partner);

        // Atualiza a entidade com os valores gerenciados pelo banco de dados.
        entityManager.refresh(savedPartner);

        return partnerMapper.toResponseDTO(savedPartner);
    }

    @Transactional
    public PartnerResponseDTO updatePartnerById(Integer id, PartnerUpdateRequestDTO partnerRequest) {
        Partner partner = partnerRepository.findById(id)
                .orElseThrow(() -> new PartnerNotFoundException("Não foi encontrado um parceiro com ID=" + id + " para atualizar."));

        // Atualiza somente os campos informados na requisição, preservando os valores dos campos nulos.
        partnerMapper.updatePartnerFromDTO(partnerRequest, partner);

        return partnerMapper.toResponseDTO(partner);
    }

    // Normaliza o documento e valida sua estrutura conforme o tipo informado.
    private String validateAndNormalizeDocument(PartnerRequestDTO partnerRequest) {
        String document = DocumentValidator.normalizeDocument(partnerRequest.document());

        switch (partnerRequest.documentType()) {
            case CPF -> {
                if (!DocumentValidator.isValidCpf(document)) {
                    throw new InvalidPartnerDocumentException("O CPF informado é inválido.");
                }
            }

            case CNPJ -> {
                if (!DocumentValidator.isValidCnpj(document)) {
                    throw new InvalidPartnerDocumentException("O CNPJ informado é inválido.");
                }
            }
        }

        return document;
    }

    private MediaFile findMediaFile(Integer mediaFileId) {
        if (mediaFileId == null) {
            return null;
        }

        return mediaFileRepository.findById(mediaFileId)
                .orElseThrow(() -> new MediaFileNotFoundException(
                        "O arquivo de mídia informado não foi encontrado."));
    }
}