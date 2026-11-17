package br.com.mythrix.erp.partner.controller;

import br.com.mythrix.erp.partner.dto.PartnerRequestDTO;
import br.com.mythrix.erp.partner.dto.PartnerResponseDTO;
import br.com.mythrix.erp.partner.dto.PartnerUpdateRequestDTO;
import br.com.mythrix.erp.partner.service.PartnerService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/partners")
@RequiredArgsConstructor
public class PartnerController {
    private final PartnerService partnerService;

    @GetMapping
    public ResponseEntity<Page<PartnerResponseDTO>> listPartners(@PageableDefault(sort = "id",
            direction = Sort.Direction.ASC) Pageable pageable) {
        Page<PartnerResponseDTO> partnerResponse = partnerService.listPartners(pageable);
        return ResponseEntity.ok(partnerResponse);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PartnerResponseDTO> findPartnerById(@PathVariable Integer id) {
        return ResponseEntity.ok(partnerService.findPartnerById(id));
    }

    @PostMapping
    public ResponseEntity<PartnerResponseDTO> savePartner(@Valid @RequestBody PartnerRequestDTO partnerRequest) {
        PartnerResponseDTO partnerResponse = partnerService.savePartner(partnerRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body(partnerResponse);
    }

    @PatchMapping("/{id}")
    public ResponseEntity<PartnerResponseDTO> updatePartnerById(@PathVariable Integer id,
                                                                @Valid @RequestBody PartnerUpdateRequestDTO partnerRequest) {
        PartnerResponseDTO partnerResponse = partnerService.updatePartnerById(id, partnerRequest);
        return ResponseEntity.ok(partnerResponse);
    }
}