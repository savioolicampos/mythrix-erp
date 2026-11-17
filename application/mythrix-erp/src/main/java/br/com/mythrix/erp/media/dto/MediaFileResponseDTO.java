package br.com.mythrix.erp.media.dto;

import java.time.LocalDateTime;

public record MediaFileResponseDTO(
        Integer id,
        String originalFileName,
        String contentType,
        Long sizeBytes,
        LocalDateTime createdAt
) {}