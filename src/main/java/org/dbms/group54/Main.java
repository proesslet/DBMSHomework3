package org.example;

import java.util.logging.Logger;

public class Main {
    private static final Logger log;

    static {
        System.setProperty("java.util.logging.SimpleFormatter.format", "[%4$-7s] %5$s %n");
        log =Logger.getLogger(DemoApplication.class.getName());
    }
    public static void main(String[] args) {


    }
}