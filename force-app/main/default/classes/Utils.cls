public with sharing class Utils {
    // Como não é nescessário desenvolver a validação real do cpf/cnpj para este teste, 
    // para simular um valor inválido é checado se contem "@" na string.

    public static Boolean ValidaCNPJ(String cnpj){
        return !cnpj.contains('@');
    }

    public static Boolean ValidaCPF(String cpf){
        return !cpf.contains('@');
    }
}