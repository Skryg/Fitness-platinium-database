package com.tcs.project;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@ControllerAdvice
public class Handler {
    @ExceptionHandler(value = Exception.class)
    @ResponseBody
    public String handleException(Exception e) {
        return e.getMessage();
    }
}
