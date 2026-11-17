package br.com.mythrix.erp;

import br.com.mythrix.erp.validation.DocumentValidator;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class DocumentValidatorTest {
    @Test
    void shouldValidateValidCpf() {
        assertTrue(DocumentValidator.isValidCpf("053.197.621-19"));
        assertTrue(DocumentValidator.isValidCpf("05319762119"));
    }

    @Test
    void shouldRejectInvalidCpf() {
        assertFalse(DocumentValidator.isValidCpf("529.982.247-26"));
        assertFalse(DocumentValidator.isValidCpf("111.111.111-11"));
        assertFalse(DocumentValidator.isValidCpf("123456789"));
        assertFalse(DocumentValidator.isValidCpf(null));
    }

    @Test
    void shouldValidateValidNumericCnpj() {
        assertTrue(DocumentValidator.isValidCnpj("11.222.333/0001-81"));
        assertTrue(DocumentValidator.isValidCnpj("11222333000181"));
    }

    @Test
    void shouldRejectInvalidCnpj() {
        assertFalse(DocumentValidator.isValidCnpj("11.222.333/0001-82"));
        assertFalse(DocumentValidator.isValidCnpj("11111111111111"));
        assertFalse(DocumentValidator.isValidCnpj("123456789"));
        assertFalse(DocumentValidator.isValidCnpj(null));
    }
}