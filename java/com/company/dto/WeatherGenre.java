package com.company.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class WeatherGenre {
    private int weatherId;
    private List<String> genres;
}