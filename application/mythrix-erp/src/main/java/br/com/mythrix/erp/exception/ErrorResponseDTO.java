package br.com.mythrix.erp.exception;

public record ErrorResponseDTO (
        int status,
        String error,
        String message
) {}