package br.com.mythrix.erp.validation;

import java.util.Locale;

public final class DocumentValidator {
    private DocumentValidator() {

    }

    public static boolean isValidCpf(String cpf) {
        if (cpf == null) {
            return false;
        }

        String document = normalizeDocument(cpf);

        // CPF deve possuir exatamente 11 dígitos.
        if (!document.matches("\\d{11}")) {
            return false;
        }

        // Rejeita sequências repetidas, como 11111111111.
        if (hasRepeatedCharacters(document)) {
            return false;
        }

        String base = document.substring(0, 9);

        int firstDigit = calculateCpfDigit(base, 10);

        String baseWithFirstDigit = base + firstDigit;

        int secondDigit = calculateCpfDigit(baseWithFirstDigit, 11);

        return document.equals(base + firstDigit + secondDigit);
    }

    public static boolean isValidCnpj(String cnpj) {
        if (cnpj == null) {
            return false;
        }

        String document = normalizeDocument(cnpj);

        // CNPJ possui 14 posições: 12 alfanuméricas e 2 numéricas.
        if (!document.matches("[A-Z0-9]{12}\\d{2}")) {
            return false;
        }

        if (hasRepeatedCharacters(document)) {
            return false;
        }

        String base = document.substring(0, 12);

        int firstDigit = calculateCnpjDigit(base);

        String baseWithFirstDigit = base + firstDigit;

        int secondDigit = calculateCnpjDigit(baseWithFirstDigit);

        return document.equals(base + firstDigit + secondDigit);
    }

    public static String normalizeDocument(String document) {
        return document
                .trim()
                .replaceAll("[./\\-\\s]", "")
                .toUpperCase(Locale.ROOT);
    }

    private static int calculateCpfDigit(String base, int initialWeight) {
        int sum = 0;

        for (int i = 0; i < base.length(); i++) {
            int digit = Character.getNumericValue(base.charAt(i));
            int weight = initialWeight - i;

            sum += digit * weight;
        }

        int remainder = sum % 11;

        return remainder < 2 ? 0 : 11 - remainder;
    }

    private static int calculateCnpjDigit(String base) {
        int sum = 0;
        int weight = 2;

        // Percorre da direita para a esquerda.
        for (int i = base.length() - 1; i >= 0; i--) {
            int value = base.charAt(i) - 48;

            sum += value * weight;

            weight++;

            if (weight > 9) {
                weight = 2;
            }
        }

        int remainder = sum % 11;

        return remainder < 2 ? 0 : 11 -remainder;
    }

    private static boolean hasRepeatedCharacters(String document) {
        char firstCharacter = document.charAt(0);

        for (int i = 1; i < document.length(); i++) {
            if (document.charAt(i) != firstCharacter) {
                return false;
            }
        }

        return true;
    }
}