package cl.talentodigital.Certificaciondevops2024.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    
     @GetMapping("/hola")
    public String sayHello() {
        return "¡Hola Mundo!";
    }
}
