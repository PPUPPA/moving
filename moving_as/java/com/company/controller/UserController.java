package com.company.controller;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.company.dto.MovieDto;
import com.company.dto.Reservation_ViewDto;
import com.company.dto.ScheduleDto;
import com.company.dto.WeatherGenre;
import com.company.service.MovieService;
import com.company.service.ReservationService;
import com.google.gson.Gson;

@Controller

public class UserController {
	@Autowired
	MovieService mv_service;
	@Autowired
	ReservationService service;

	@GetMapping("/main.ks")
	public String main(Model model) {
		List<MovieDto> movieList = mv_service.mv_readLive();

		// 메인 비주얼 영화 출력
		List<MovieDto> nonEmptyVideoList = movieList.stream()
				.filter(movie -> movie.getMv_video() != null && !movie.getMv_video().isEmpty()).limit(10)
				.collect(Collectors.toList());

		MovieDto randomMovie = getRandomMovie(nonEmptyVideoList);

		if (randomMovie != null) {
			String[] imageArray = randomMovie.getMv_stilcut().split(",");
			String firstImageUrl = imageArray.length > 0 ? imageArray[0].trim() : null;
			model.addAttribute("randomMovie", randomMovie);
			model.addAttribute("firstImageUrl", firstImageUrl);
		} else {
			model.addAttribute("randomMovie", null);
			model.addAttribute("firstImageUrl", null);
		}

		model.addAttribute("list", movieList);

		return "main";
	}

	private MovieDto getRandomMovie(List<MovieDto> movieList) {
		Random random = new Random();
		int listSize = movieList.size();
		int randomIndex;
		if (listSize > 0) {
			randomIndex = random.nextInt(listSize);
			return movieList.get(randomIndex);
		} else {
			return null;
		}
	}
	
	@RequestMapping(value="/sendWeatherGenre.as", method={RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public ResponseEntity<List<MovieDto>> sendWeatherGenre(@RequestBody WeatherGenre weatherGenre) { 
	    try {
			List<MovieDto> weatherGenreList = mv_service.mv_readGenreLive(weatherGenre.getGenres());
			
			Collections.shuffle(weatherGenreList);
			
			if (weatherGenreList.size() > 5) {
	            weatherGenreList = weatherGenreList.subList(0, 5);
	        }
			
	        return ResponseEntity.ok(weatherGenreList);
	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
	    }
	}

	@GetMapping("/reservation_view.ks")
	public String reservation_view(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		
		service.reservation_view(request, response);
		return "reservation";
	}

	@GetMapping(value = "/getTheaterList.ks", produces = "application/text; charset=utf8")
	@ResponseBody
	public String getTheaterList(Reservation_ViewDto dto) {
		Gson gson = new Gson();
		String json = gson.toJson(service.getTheaterList(dto));

		return json;
	}

	@GetMapping(value = "/getMovieList.ks", produces = "application/text; charset=utf8")
	@ResponseBody
	public String getMovieList(Reservation_ViewDto dto) throws IOException {
		Gson gson = new Gson();
		String json = gson.toJson(service.getMovieList(dto));

		return json;

	}

	@GetMapping(value = "/getDateList.ks", produces = "application/text; charset=utf8")
	@ResponseBody
	public String getDateList(Reservation_ViewDto dto) throws IOException {
		Gson gson = new Gson();
		String json = gson.toJson(service.getDateList(dto));

		return json;

	}

	@GetMapping(value = "/getScheduleList.ks", produces = "application/text; charset=utf8")
	@ResponseBody
	public String getScheduleList(Reservation_ViewDto dto) throws IOException {
		Gson gson = new Gson();
		String json = gson.toJson(service.getScheduleList(dto));

		return json;

	}

	@GetMapping(value = "/allClick.ks", produces = "application/text; charset=utf8")
	@ResponseBody
	public String allClick(Reservation_ViewDto dto) throws IOException {
		Gson gson = new Gson();
		String json = gson.toJson(service.allClick(dto));

		return json;

	}

	@PostMapping(value = "/seat_view.ks", produces = "application/text; charset=utf8")

	public String seat_view(Model model, ScheduleDto dto) {
		service.seat_view(model, dto);
		return "seat";

	}

	@PostMapping(value = "/pay_view.ks", produces = "application/text; charset=utf8")

	public String pay_view(HttpServletRequest request, ScheduleDto dto) {

		request.setAttribute("seatList", request.getParameterValues("seat_name"));
		request.setAttribute("dto", service.getPayList(dto));
		return "pay";

	}

	@PostMapping(value = "/kakaoPay.ks", produces = "application/text; charset=utf8")
	public void kakaoPay(HttpServletRequest request, HttpServletResponse response, Reservation_ViewDto dto)
			throws Exception {
		service.kakaoPay(request, response, dto);
	}

	@GetMapping(value = "/success.ks", produces = "application/text; charset=utf8")

	public void success(HttpServletRequest request, HttpServletResponse response) throws Exception {
		service.success(request, response);

	}

	@GetMapping(value = "/fail.ks", produces = "application/text; charset=utf8")

	public void fail(HttpServletRequest request, HttpServletResponse response) throws Exception {
		service.fail(request, response);

	}

	@GetMapping(value = "/cancel.ks", produces = "application/text; charset=utf8")

	public void cancel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		service.cancel(request, response);

	}

	@GetMapping(value = "/my_reservation.ks", produces = "application/text; charset=utf8")

	public String myReservation(Reservation_ViewDto dto, Model model, HttpServletRequest request) throws IOException {

		service.my_reservation_view(dto, model, request);

		return "my_reservation";

	}

	@GetMapping(value = "/getMyReservationView_2.ks", produces = "application/text; charset=utf8")
	@ResponseBody
	public String getMyReservationView_2(Reservation_ViewDto dto) {
		Gson gson = new Gson();
		String json = gson.toJson(service.getMyReservationView_2(dto));
		return json;

	}

	@GetMapping(value = "/reservationcancel.ks", produces = "application/text; charset=utf8")

	public void reservationcancel(Reservation_ViewDto dto, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		service.reservationcancel(dto, request, response);

	}

	@GetMapping(value = "/my_canceled_reservation.ks", produces = "application/text; charset=utf8")

	public String my_canceled_reservation_view(Reservation_ViewDto dto, Model model, HttpServletRequest request)
			throws IOException {

		service.my_canceled_reservation_view(dto, model, request);

		return "my_canceled_reservation";

	}

	@RequestMapping(value = "stt.ks", produces = "application/json; charset=utf8", method = RequestMethod.POST)
	@ResponseBody
	public String stt(@RequestParam MultipartFile file, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		/*
		 * Gson gson = new Gson(); String json = gson.toJson();
		 */
		return service.stt(file, request, response);

	}

}
