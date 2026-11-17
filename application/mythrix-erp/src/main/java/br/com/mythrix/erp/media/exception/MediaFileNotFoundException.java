package br.com.mythrix.erp.media.exception;

public class MediaFileNotFoundException extends RuntimeException {
    public MediaFileNotFoundException(String message) {
        super(message);
    }
}