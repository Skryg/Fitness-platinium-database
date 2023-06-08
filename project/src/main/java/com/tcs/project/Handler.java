package com.tcs.project;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ResponseBody;
//import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class ExceptionHandler {
    @ExceptionHandler(value = Exception.class)
    @ResponseBody
    public String handleException(Exception e) {
        return e.getMessage();
    }
}
