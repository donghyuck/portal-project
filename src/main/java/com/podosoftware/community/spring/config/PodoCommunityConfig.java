package com.podosoftware.community.spring.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;


@Configuration
@EnableWebMvc
@ComponentScan(basePackages = { 
	"com.podosoftware.community.spring.controller"})
public class PodoCommunityConfig extends WebMvcConfigurerAdapter {

}
