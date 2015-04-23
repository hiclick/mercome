package com.mercome.activity.timertask;

import org.springframework.stereotype.Service;

import java.util.Date;

@Service
public class Task {
	//@Autowired
	//VoteService voteService;

/*
	@Scheduled(
		cron = "* * * * * ?"
	)
*/
	public void run() {

		System.out.println("<Task>: " + new Date());

		//voteService.clear();
	}
}
